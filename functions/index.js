const { onCall, HttpsError } = require("firebase-functions/v2/https");
const {
  onDocumentUpdated,
  onDocumentDeleted,
} = require("firebase-functions/v2/firestore");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");

// 2. Firebase Admin - Core app and Firestore database
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

// 3. Initialize (Top-level)
initializeApp();
const db = getFirestore();

exports.createQueue = onCall(async (request) => {
  const {
    customerId,
    id,
    joinedMethod,
    orderId,
    restId,
    partySize,
    customerName,
    phoneNumber,
    queueNumber,
  } = request.data;

  if (!restId || !partySize || !id) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  const now = new Date();

  try {
    const [tablesSnap, categoriesSnap] = await Promise.all([
      db.collection("queue_tables").where("restaurantId", "==", restId).get(),
      db
        .collection("table_categories")
        .where("restaurantId", "==", restId)
        .get(),
    ]);

    const categoryMap = {};
    categoriesSnap.forEach((doc) => {
      categoryMap[doc.id] = doc.data();
    });

    const eligibleTables = tablesSnap.docs
      .map((doc) => {
        const tableData = doc.data();
        const category = categoryMap[tableData.tableCategoryId];
        return {
          id: doc.id,
          ...tableData,
          minCapacity: category?.minSeat || 0,
          maxCapacity: category?.seatAmount || 100,
        };
      })
      .filter((t) => partySize >= t.minCapacity && partySize <= t.maxCapacity);

    if (eligibleTables.length === 0) {
      throw new HttpsError(
        "failed-precondition",
        "No tables match this party size.",
      );
    }

    // Helper to safely convert Firestore data to JS Date
    const toJSDate = (val) =>
      val && typeof val.toDate === "function"
        ? val.toDate()
        : new Date(val || now);

    let tableSlots = eligibleTables.map((t) => {
      const avg = t.avgDiningTimeMinutes || 45;
      const lastTarget = toJSDate(t.latestEstimatedReadyAt);
      const startTime = lastTarget < now ? now : lastTarget;

      return { tableId: t.id, startTime, avg: avg };
    });

    tableSlots.sort((a, b) => a.startTime - b.startTime);
    const bestTable = tableSlots[0];

    const tableRef = db.collection("queue_tables").doc(bestTable.tableId);
    const newEntryRef = db.collection("queue_entries").doc(id);

    await db.runTransaction(async (transaction) => {
      const tDoc = await transaction.get(tableRef);
      const tData = tDoc.data();

      const lastT = toJSDate(tData.latestEstimatedReadyAt);
      const startT = lastT < now ? now : lastT;

      // Calculate Ready Time for THIS user
      const readyAt = new Date(
        startT.getTime() + (tData.avgDiningTimeMinutes || 45) * 60000,
      );

      transaction.update(tableRef, {
        latestEstimatedReadyAt: readyAt, // Firestore stores as Timestamp
      });

      transaction.set(newEntryRef, {
        customerId,
        id: newEntryRef.id,
        joinedMethod,
        orderId,
        restId,
        partySize,
        customerName: customerName || "Guest",
        phoneNumber: phoneNumber || "",
        status: "waiting",
        joinTime: now,
        queueNumber,
        tableNumber: tData.tableNumber || "",
        assignedTableId: bestTable.tableId,
        expectedTableReadyAt: readyAt,
      });
    });

    return { success: true };
  } catch (error) {
    console.error("Queue Error:", error);
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Server error processing queue.");
  }
});

exports.updateTableAverage = onDocumentUpdated(
  "queue_entries/{entryId}",
  async (event) => {
    const after = event.data.after.data();
    const before = event.data.before.data();

    // Only run when status changes to 'completed'
    if (before.status === "completed" || after.status !== "completed")
      return null;

    if (!after.servedTime || !after.endedTime || !after.assignedTableId) {
      console.error("Missing timing data for average calculation");
      return null;
    }

    // --- CRITICAL: Safe Date Parsing ---
    const toJSDate = (val) =>
      val && typeof val.toDate === "function" ? val.toDate() : new Date(val);

    const served = toJSDate(after.servedTime);
    const ended = toJSDate(after.endedTime);

    // Final NaN check before math
    if (isNaN(served.getTime()) || isNaN(ended.getTime())) {
      console.error(
        "Invalid Date objects created. Check Firestore field types.",
      );
      return null;
    }

    const durationMinutes = (ended.getTime() - served.getTime()) / (1000 * 60);
    if (durationMinutes < 1 || durationMinutes > 600) return null; // Logic guard

    const tableRef = db.collection("queue_tables").doc(after.assignedTableId);

    const result = await db.runTransaction(async (transaction) => {
      const tableDoc = await transaction.get(tableRef);
      if (!tableDoc.exists) return null;

      const t = tableDoc.data();
      const now = new Date();

      // 1. Moving Average Logic
      const currentAvg = t.avgDiningTimeMinutes || 45;
      const currentSessions = t.totalSessions || 0;
      const newTotalSessions = currentSessions + 1;

      const updatedAvg = Math.round(
        (currentAvg * currentSessions + durationMinutes) / newTotalSessions,
      );

      // 2. Buffer Shifting (Early Exit Logic)
      const predictedReady = toJSDate(t.latestEstimatedReadyAt);
      let newTargetDate = now;

      if (predictedReady > now) {
        // Table cleared earlier than expected.
        // We shift the entire "queue line" forward by the saved time.
        const timeSavedMs = predictedReady.getTime() - now.getTime();
        newTargetDate = new Date(predictedReady.getTime() - timeSavedMs);
      }

      transaction.update(tableRef, {
        avgDiningTimeMinutes: updatedAvg,
        totalSessions: newTotalSessions,
        latestEstimatedReadyAt: newTargetDate,
        tableStatus: "available",
        currentServedTime: null,
        // Using FieldValue to ensure atomic removal
        queueEntryIds: admin.firestore.FieldValue.arrayRemove(after.id),
      });

      return updatedAvg;
    });

    console.log(`Table ${after.assignedTableId} updated. New Avg: ${result}m`);
    return null;
  },
);
exports.deleteTableOnCascade = onDocumentDeleted(
  "table_categories/{table_catId}",
  async (event) => {
    console.log("TRIGGER FIRED", event.params.table_catId);
    const tableCategoryId = event.params.table_catId;

    const tablesRef = db
      .collection("queue_tables")
      .where("tableCategoryId", "==", tableCategoryId);

    const tablesSnap = await tablesRef.get();

    const deletePromises = tablesSnap.docs.map((doc) => doc.ref.delete());
    return Promise.all(deletePromises);
  },
);

exports.deleteMenuOnCascade = onDocumentDeleted(
  "menu_item_categories/{menu_catId}",
  async (event) => {
    console.log("TRIGGER FIRED", event.params.menu_catId);
    const menuCategoryId = event.params.menu_catId;

    const menusRef = db
      .collection("menu_items")
      .where("categoryId", "==", menuCategoryId);

    const menusSnap = await menusRef.get();

    const deletePromises = menusSnap.docs.map((doc) => doc.ref.delete());
    return Promise.all(deletePromises);
  },
);
