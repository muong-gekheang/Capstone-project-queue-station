const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { logger } = require("firebase-functions");

// 2. Firebase Admin - Core app and Firestore database
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

// 3. Initialize (Top-level)
initializeApp();
const db = getFirestore();

exports.createQueue = onCall(async (request) => {
  const {
    customerId,
    id, // Your UUID from Flutter
    joinedMethod,
    orderId,
    restId,
    partySize,
    customerName,
    phoneNumber,
    joinTime,
    queueNumber,
    tableNumber,
  } = request.data;

  if (!restId || !partySize || !id) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  const now = new Date();

  try {
    // 1. Fetch tables and categories in parallel
    const [tablesSnap, categoriesSnap] = await Promise.all([
      db.collection("queue_tables").where("restaurantId", "==", restId).get(),
      db
        .collection("tableCategories")
        .where("restaurantId", "==", restId)
        .get(),
    ]);

    // Map categories for quick access
    const categoryMap = {};
    categoriesSnap.forEach((doc) => {
      categoryMap[doc.id] = doc.data();
    });

    // 2. Filter for tables that can fit this party
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

    // 3. Find the table with the EARLIEST ready time
    // We use latestEstimatedReadyAt as our source of truth
    let tableSlots = eligibleTables.map((t) => {
      const avg = t.avgDiningTimeMinutes || 45;
      const buffer = t.adminDelayMinutes || 0;

      // If the target is in the past, the table is free NOW.
      // If the target is in the future, it represents the end of the existing line.
      const lastTarget = t.latestEstimatedReadyAt
        ? new Date(t.latestEstimatedReadyAt)
        : now;
      const startTime = lastTarget < now ? now : lastTarget;

      return {
        tableId: t.id,
        startTime,
        avg: avg + buffer,
      };
    });

    // Sort to find the table that opens up soonest
    tableSlots.sort((a, b) => a.startTime - b.startTime);
    const bestTable = tableSlots[0];

    // Calculate when THIS specific user will be ready
    const finalEstimatedTime = new Date(
      bestTable.startTime.getTime() + bestTable.avg * 60000,
    );

    // 4. Update the Table and Create the Queue Entry in a Transaction
    // This ensures two people don't "grab" the same slot at the same time
    const tableRef = db.collection("queue_tables").doc(bestTable.tableId);
    const newEntryRef = db.collection("queue_entries").doc(id);

    await db.runTransaction(async (transaction) => {
      // Re-fetch table inside transaction for safety
      const tDoc = await transaction.get(tableRef);
      const tData = tDoc.data();

      const lastT = tData.latestEstimatedReadyAt
        ? new Date(tData.latestEstimatedReadyAt)
        : now;
      const startT = lastT < now ? now : lastT;
      const readyAt = new Date(
        startT.getTime() + (tData.avgDiningTimeMinutes || 45) * 60000,
      );

      // 1. Update the table's "Finish Line"
      transaction.update(tableRef, {
        latestEstimatedReadyAt: readyAt.toISOString(),
      });

      // 2. Create the queue document
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
        joinTime: joinTime || now.toISOString(),
        queueNumber,
        tableNumber: tData.tableNumber || "",
        assignedTableId: bestTable.tableId,
        expectedTableReadyAt: readyAt.toISOString(),
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
    const before = event.data.before.data();
    const after = event.data.after.data();

    if (before.status === "completed" || after.status !== "completed")
      return null;

    if (!after.servedTime || !after.endedTime || !after.tableId) {
      console.error("Missing data for calculation");
      return null;
    }

    const served = new Date(after.servedTime);
    const ended = new Date(after.endedTime);
    const durationMinutes = (ended - served) / (1000 * 60);

    if (durationMinutes < 5 || durationMinutes > 300) return null;

    const tableRef = db.collection("queue_tables").doc(after.tableId);

    // We return the new average from the transaction so we can log it
    const newAverage = await db.runTransaction(async (transaction) => {
      const tableDoc = await transaction.get(tableRef);
      if (!tableDoc.exists) return null;

      const t = tableDoc.data();
      const now = new Date();

      // --- 1. Math for the Moving Average ---
      const currentAvg = t.avgDiningTimeMinutes || 45;
      const currentSessions = t.totalSessions || 0;
      const newTotalSessions = currentSessions + 1;
      const updatedAvg = Math.round(
        (currentAvg * currentSessions + durationMinutes) / newTotalSessions,
      );

      // --- 2. Buffer Shifting Logic ---
      const predictedReady = new Date(
        t.latestEstimatedReadyAt || now.toISOString(),
      );
      let newTargetIso = now.toISOString();

      if (predictedReady > now) {
        // Table cleared early! Shift the whole "stack" of waiting people forward
        const timeSavedMs = predictedReady.getTime() - now.getTime();
        newTargetIso = new Date(
          predictedReady.getTime() - timeSavedMs,
        ).toISOString();
      }

      transaction.update(tableRef, {
        avgDiningTimeMinutes: updatedAvg,
        totalSessions: newTotalSessions,
        latestEstimatedReadyAt: newTargetIso,
        tableStatus: "available",
        currentServedTime: null,
        // Remove this entry from the table's active list
        queueEntryIds: FieldValue.arrayRemove(after.id),
      });

      return updatedAvg; // Return for the logger
    });

    console.log(
      `Table ${after.tableId} updated. New Average: ${newAverage} mins.`,
    );
    return null;
  },
);
