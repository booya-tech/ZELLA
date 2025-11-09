import {SENDGRID_API_KEY, SENDER_EMAIL} from "./config";
import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import sgMail from "@sendgrid/mail";

admin.initializeApp();

// Set SendGrid API key from environment
sgMail.setApiKey(SENDGRID_API_KEY);

interface VerificationEmailRequest {
  email: string;
  code: string;
  name: string;
}

export const sendVerificationEmail = functions
  .region("asia-southeast1")
  .https.onCall(async (data: VerificationEmailRequest, context) => {
    // Verify authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const {email, code, name} = data;

    // Validate input
    if (!email || !code || !name) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required fields"
      );
    }

    const msg = {
      to: email,
      from: SENDER_EMAIL,
      subject: "Verify Your ZELLA Account",
      text: `Hi ${name}, Your verification code is: ${code}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2>Welcome to ZELLA!</h2>
          <p>Hi ${name},</p>
          <p>Your verification code is:</p>
          <h1 style="background: #f4f4f4; padding: 20px; text-align: center; letter-spacing: 5px;">
            ${code}
          </h1>
          <p>This code will expire in 30 minutes.</p>
          <p>If you didn't create an account, please ignore this email.</p>
          <hr>
          <p style="color: #666; font-size: 12px;">ZELLA - Thai Fashion Marketplace</p>
        </div>
      `,
    };

    try {
      await sgMail.send(msg);
      functions.logger.info(`Verification email sent to ${email}`);
      return {success: true};
    } catch (error) {
      functions.logger.error("Error sending email:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Failed to send verification email"
      );
    }
  });