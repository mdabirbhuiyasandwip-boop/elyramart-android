import { initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";
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
      sellerIds: [...sellerIds], totalAmount: amount,
      paymentMethod: "cash_on_delivery", createdAt: FieldValue.serverTimestamp(),
      status: "placed"
    });
    return amount;
  });

  return { success: true, orderId: orderRef.id,
    orderNumber: typeof data.orderNumber === "string" ? data.orderNumber : orderRef.id,
    totalAmount: total };
});
