import { initializeApp } from "firebase-admin/app";
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
