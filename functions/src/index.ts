import { initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";
import { getMessaging } from "firebase-admin/messaging";
import { onDocumentCreated, onDocumentUpdated } from "firebase-functions/v2/firestore";
import { defineString } from "firebase-functions/params";
import { HttpsError, onCall } from "firebase-functions/v2/https";

initializeApp();

const ownerEmail = defineString("ELYRAMART_OWNER_EMAIL");

export const claimOwnerAdmin = onCall(
  { enforceAppCheck: false },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "প্রথমে লগইন করুন।");
    }

    const tokenEmail = request.auth.token.email;
    const emailVerified = request.auth.token.email_verified === true;
    const configuredEmail = ownerEmail.value().trim().toLowerCase();

    if (!configuredEmail || typeof tokenEmail !== "string" ||
        tokenEmail.trim().toLowerCase() !== configuredEmail || !emailVerified) {
      throw new HttpsError(
        "permission-denied",
        "শুধু যাচাইকৃত Elyramart মালিকের ইমেইল অ্যাডমিন হতে পারবে।"
      );
    }

    const auth = getAuth();
    const user = await auth.getUser(request.auth.uid);
    if (!user.emailVerified || user.email?.trim().toLowerCase() !== configuredEmail) {
      throw new HttpsError("permission-denied", "মালিকের ইমেইল যাচাই হয়নি।");
    }

    const claims = { ...(user.customClaims ?? {}), admin: true };
    await auth.setCustomUserClaims(user.uid, claims);

    return {
      success: true,
      message: "অ্যাডমিন অনুমতি দেওয়া হয়েছে। নতুন ID token নিয়ে আবার লগইন করুন।"
    };
  }
);


export const placeOrder = onCall(async (request) => {
  if (!request.auth || request.auth.token.email_verified !== true) {
    throw new HttpsError("unauthenticated", "অর্ডার করতে যাচাইকৃত অ্যাকাউন্টে লগইন করুন।");
  }
  const data = request.data as {
    orderNumber?: unknown; customerName?: unknown; phone?: unknown;
    address?: unknown; paymentMethod?: unknown; items?: unknown;
  };
  if (typeof data.customerName !== "string" || !data.customerName.trim() ||
      typeof data.phone !== "string" || !/^01[3-9]\d{8}$/.test(data.phone) ||
      typeof data.address !== "string" || !data.address.trim() ||
      data.paymentMethod !== "cash_on_delivery" ||
      !Array.isArray(data.items) || data.items.length < 1 || data.items.length > 30) {
    throw new HttpsError("invalid-argument", "অর্ডারের তথ্য সঠিক নয়।");
  }

  const customerName = data.customerName.trim();
  const deliveryAddress = data.address.trim();
  const quantities = new Map<string, number>();
  for (const item of data.items) {
    const productId = item && typeof item === "object"
      ? (item as { productId?: unknown }).productId : null;
    if (typeof productId !== "string" || !productId.trim()) {
      throw new HttpsError("invalid-argument", "কার্টে পণ্যের পরিচয় পাওয়া যায়নি।");
    }
    quantities.set(productId, (quantities.get(productId) ?? 0) + 1);
  }

  const db = getFirestore();
  const orderRef = db.collection("orders").doc();
  const total = await db.runTransaction(async (transaction) => {
    let amount = 0;
    const settingsSnap = await transaction.get(db.collection("settings").doc("business"));
    const configuredFee = settingsSnap.data()?.deliveryFee;
    const deliveryFee = Number.isInteger(configuredFee) && configuredFee >= 0
      ? configuredFee : 80;
    const orderItems: Array<Record<string, unknown>> = [];
    const sellerIds = new Set<string>();
    const productRefs = [...quantities.entries()].map(([id, quantity]) => ({
      ref: db.collection("products").doc(id), quantity
    }));
    const snapshots = [];
    for (const entry of productRefs) snapshots.push(await transaction.get(entry.ref));

    for (let index = 0; index < productRefs.length; index++) {
      const { ref, quantity } = productRefs[index];
      const snapshot = snapshots[index];
      if (!snapshot.exists) throw new HttpsError("not-found", "একটি পণ্য আর পাওয়া যাচ্ছে না।");
      const product = snapshot.data()!;
      if (product.status !== "active" || typeof product.sellerId !== "string" ||
          typeof product.price !== "number" || product.price <= 0 ||
          !Number.isInteger(product.stock) || product.stock < quantity) {
        throw new HttpsError("failed-precondition", "একটি পণ্যের স্টক বা মূল্য পরিবর্তিত হয়েছে।");
      }
      const lineTotal = product.price * quantity;
      amount += lineTotal;
      sellerIds.add(product.sellerId);
      orderItems.push({
        productId: snapshot.id, name: String(product.title ?? "পণ্য"),
        category: String(product.categoryId ?? "অন্যান্য"),
        unitPrice: product.price, quantity, price: lineTotal,
        sellerId: product.sellerId
      });
      transaction.update(ref, {
        stock: product.stock - quantity,
        updatedAt: FieldValue.serverTimestamp()
      });
    }

    transaction.set(orderRef, {
      orderNumber: typeof data.orderNumber === "string" ? data.orderNumber : orderRef.id,
      customerId: request.auth!.uid,
      customerName, phone: data.phone,
      address: deliveryAddress, items: orderItems,
      sellerIds: [...sellerIds], subtotal: amount, deliveryFee,
      totalAmount: amount + deliveryFee,
      paymentMethod: "cash_on_delivery", createdAt: FieldValue.serverTimestamp(),
      status: "placed", deliveryStatus: "unassigned"
    });
    return { subtotal: amount, deliveryFee, totalAmount: amount + deliveryFee };
  });

  return { success: true, orderId: orderRef.id,
    orderNumber: typeof data.orderNumber === "string" ? data.orderNumber : orderRef.id,
    subtotal: total.subtotal, deliveryFee: total.deliveryFee, totalAmount: total.totalAmount };
});


async function sendUserNotification(uid: string, title: string, body: string, data: Record<string, string> = {}) {
  const db = getFirestore();
  const tokensSnapshot = await db.collection("users").doc(uid).collection("fcmTokens").get();
  const tokens = tokensSnapshot.docs.map((doc) => doc.id).filter(Boolean);
  if (tokens.length === 0) return;
  const response = await getMessaging().sendEachForMulticast({
    tokens, notification: { title, body }, data,
    android: { priority: "high", notification: { channelId: "elyramart_updates" } }
  });
  const stale: string[] = [];
  response.responses.forEach((result, index) => {
    if (!result.success && (result.error?.code === "messaging/registration-token-not-registered" ||
        result.error?.code === "messaging/invalid-registration-token")) stale.push(tokens[index]);
  });
  if (stale.length) {
    const batch = db.batch();
    for (const token of stale) batch.delete(db.collection("users").doc(uid).collection("fcmTokens").doc(token));
    await batch.commit();
  }
}

export const notifyNewOrder = onDocumentCreated("orders/{orderId}", async (event) => {
  const order = event.data?.data();
  if (!order) return;
  const orderId = event.params.orderId;
  const orderNumber = String(order.orderNumber ?? orderId);
  await sendUserNotification(String(order.customerId), "Elyramart: অর্ডার গ্রহণ করা হয়েছে",
    `আপনার অর্ডার ${orderNumber} গ্রহণ করা হয়েছে। মোট ৳${order.totalAmount ?? 0}`,
    { type: "order", orderId });
  const sellers = Array.isArray(order.sellerIds) ? order.sellerIds : [];
  await Promise.all(sellers.filter((uid): uid is string => typeof uid === "string")
    .map((uid) => sendUserNotification(uid, "নতুন অর্ডার",
      `অর্ডার ${orderNumber}-এ আপনার পণ্য রয়েছে।`, { type: "order", orderId })));
});

export const notifyNewServiceBooking = onDocumentCreated("serviceBookings/{bookingId}", async (event) => {
  const booking = event.data?.data();
  if (!booking) return;
  await sendUserNotification(String(booking.customerId), "Elyramart: বুকিং গ্রহণ করা হয়েছে",
    `${String(booking.service ?? "সার্ভিস")} বুকিং অনুরোধ গ্রহণ করা হয়েছে।`,
    { type: "booking", bookingId: event.params.bookingId });
});

export const notifyAssignedTechnician = onDocumentUpdated("serviceBookings/{bookingId}", async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!before || !after) return;
  const bookingId = event.params.bookingId;
  if (before.technicianId !== after.technicianId && typeof after.technicianId === "string") {
    await sendUserNotification(after.technicianId, "নতুন সার্ভিস কাজ বরাদ্দ",
      `${String(after.service ?? "সার্ভিস")} কাজটি আপনার নামে বরাদ্দ হয়েছে।`,
      { type: "booking", bookingId });
  }
  if (before.status !== after.status && typeof after.customerId === "string") {
    await sendUserNotification(after.customerId, "সার্ভিস বুকিং আপডেট",
      `আপনার বুকিংয়ের অবস্থা: ${String(after.status)}`,
      { type: "booking", bookingId });
  }
});


export const notifyOrderProgress = onDocumentUpdated("orders/{orderId}", async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!before || !after) return;
  const orderId = event.params.orderId;
  const orderNumber = String(after.orderNumber ?? orderId);
  if (before.status !== after.status && typeof after.customerId === "string") {
    await sendUserNotification(after.customerId, "অর্ডারের অবস্থা আপডেট",
      `অর্ডার ${orderNumber}: ${String(after.status)}`, { type: "order", orderId });
  }
  if (before.deliveryStatus !== after.deliveryStatus && typeof after.customerId === "string") {
    const rider = typeof after.riderName === "string" ? after.riderName : "রাইডার";
    await sendUserNotification(after.customerId, "ডেলিভারি আপডেট",
      `${rider} আপনার অর্ডারের ডেলিভারির দায়িত্ব পেয়েছেন।`, { type: "order", orderId });
  }
});
