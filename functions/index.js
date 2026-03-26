const { onCall, HttpsError } = require("firebase-functions/v2/https");
const {
  onDocumentUpdated,
  onDocumentDeleted,
} = require("firebase-functions/v2/firestore");
const { logger } = require("firebase-functions");

// 2. Firebase Admin - Core app and Firestore database
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

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
    // 1. Fetch tables and categories in parallel
    const [tablesSnap, categoriesSnap] = await Promise.all([
      db.collection("queue_tables").where("restaurantId", "==", restId).get(),
      db
        .collection("table_categories")
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

      // If the target is in the past, the table is free NOW.
      // If the target is in the future, it represents the end of the existing line.
      const lastTarget = t.latestEstimatedReadyAt
        ? new Date(t.latestEstimatedReadyAt)
        : now;
      const startTime = lastTarget < now ? now : lastTarget;

      return {
        tableId: t.id,
        startTime,
        avg: avg,
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
        joinTime: now.toISOString(),
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
        queueEntryIds: FieldValue.arrayRemove(after.id),
      });

      return updatedAvg;
    });

    console.log(
      `Table ${after.tableId} updated. New Average: ${newAverage} mins.`,
    );
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

// ─────────────────────────────────────────
// Notify store when customer confirms an order (new or updated)
// Requires Firestore composite index: users(userType, restaurantId)
// ─────────────────────────────────────────
exports.sendOrderNotificationToStore = onDocumentUpdated(
  "orders/{orderId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    if (!after.lastConfirmedAt) return null;
    if (before.lastConfirmedAt === after.lastConfirmedAt) return null;

    const restaurantId = after.restaurantId;
    if (!restaurantId) return null;

    const itemCount = (after.orderedIds || []).length;
    const isFirstConfirm = !before.lastConfirmedAt;

    const usersSnap = await db
      .collection("users")
      .where("userType", "==", "store")
      .where("restaurantId", "==", restaurantId)
      .get();

    const tokens = [];
    usersSnap.forEach((doc) => {
      const fcmToken = doc.data().fcmToken;
      if (fcmToken) tokens.push(fcmToken);
    });

    if (tokens.length === 0) return null;

    const title = isFirstConfirm ? "New Order" : "Order Updated";
    const body = `${itemCount} item${itemCount === 1 ? "" : "s"} confirmed`;

    try {
      await getMessaging().sendEachForMulticast({
        notification: { title, body },
        data: {
          type: isFirstConfirm ? "new_order" : "order_update",
          orderId: event.params.orderId,
          itemCount: String(itemCount),
        },
        tokens,
      });
    } catch (e) {
      console.error("FCM send error:", e);
    }

    return null;
  },
);

// ─────────────────────────────────────────
// Accept all pending order items and notify the customer
// Called by the store when they accept an order
// ─────────────────────────────────────────
exports.acceptOrderAndNotifyCustomer = onCall(async (request) => {
  const { orderId, queueEntryId, restaurantId, customerId } = request.data;

  if (!orderId || !queueEntryId || !restaurantId || !customerId) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  // 1. Batch-accept all pending order items
  const itemsSnap = await db
    .collection("order_items")
    .where("orderId", "==", orderId)
    .where("status", "==", "pending")
    .get();

  if (!itemsSnap.empty) {
    const batch = db.batch();
    itemsSnap.forEach((doc) => {
      batch.update(doc.ref, {
        status: "accepted",
        acceptedAt: new Date().toISOString(),
      });
    });
    await batch.commit();
  }

  // 2. Find customer FCM token (only for remote / app users)
  const userDoc = await db.collection("users").doc(customerId).get();
  if (!userDoc.exists) return { success: true };

  const fcmToken = userDoc.data().fcmToken;
  if (!fcmToken) return { success: true };

  // 3. Determine queue position and queue number from waiting entries
  const waitingSnap = await db
    .collection("queue_entries")
    .where("restId", "==", restaurantId)
    .where("status", "==", "waiting")
    .orderBy("joinTime")
    .get();

  const positionIndex = waitingSnap.docs.findIndex(
    (doc) => doc.id === queueEntryId,
  );
  const position = positionIndex >= 0 ? String(positionIndex + 1) : "1";

  // Extract queue number from the waiting results; fall back to a direct read
  // if the entry has already moved out of the waiting state.
  let queueNumber =
    positionIndex >= 0
      ? waitingSnap.docs[positionIndex].data().queueNumber || ""
      : "";

  if (!queueNumber) {
    const entryDoc = await db
      .collection("queue_entries")
      .doc(queueEntryId)
      .get();
    queueNumber = entryDoc.exists ? entryDoc.data().queueNumber || "" : "";
  }

  // 5. Get the currently serving queue number
  const servingSnap = await db
    .collection("queue_entries")
    .where("restId", "==", restaurantId)
    .where("status", "==", "serving")
    .orderBy("servedTime", "desc")
    .limit(1)
    .get();

  const currentQueue =
    servingSnap.docs.length > 0
      ? servingSnap.docs[0].data().queueNumber || queueNumber
      : queueNumber;

  // 6. Send FCM to customer
  try {
    await getMessaging().send({
      notification: {
        title: "Order Accepted",
        body: `Queue ${queueNumber} — Position ${position}`,
      },
      data: {
        type: "order_accepted",
        queueNumber,
        position,
        currentQueue,
        restaurantId,
      },
      token: fcmToken,
    });
  } catch (e) {
    console.error("FCM send error:", e);
  }

  return { success: true };
});

// ─────────────────────────────────────────
// Notify customer when store moves them to "serving"
// ─────────────────────────────────────────
exports.sendQueueServedNotification = onDocumentUpdated(
  "queue_entries/{entryId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    if (before.status === after.status) return null;
    if (after.status !== "serving") return null;

    const customerId = after.customerId;
    if (!customerId) return null;
    if (after.joinedMethod === "walkIn") return null;

    const userDoc = await db.collection("users").doc(customerId).get();
    if (!userDoc.exists) return null;

    const fcmToken = userDoc.data().fcmToken;
    if (!fcmToken) return null;

    const queueNumber = after.queueNumber || "";
    const tableNumber = after.tableNumber || "";

    try {
      await getMessaging().send({
        notification: {
          title: "You're being served!",
          body: `Queue ${queueNumber} — Table ${tableNumber} is ready`,
        },
        data: {
          type: "queue_served",
          queueNumber,
          tableNumber,
          restId: after.restId || "",
        },
        token: fcmToken,
      });
    } catch (e) {
      console.error("FCM send error:", e);
    }

    return null;
  },
);
