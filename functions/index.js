const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// Yeni task eklendiğinde tetiklenecek
exports.sendTaskNotification = functions.firestore
    .document("users/{userId}/tasks/{taskId}")
    .onCreate(async (snap, context) => {
      const task = snap.data();
      const userId = context.params.userId;

      if (!task) return null;

      // Kullanıcının FCM tokenlarını al
      const tokensSnapshot = await db
          .collection("users")
          .doc(userId)
          .collection("fcmTokens")
          .get();

      const tokens = tokensSnapshot.docs.map((doc) => doc.id);
      if (tokens.length === 0) return null;

      // Bildirim mesajı oluştur
      const payload = {
        notification: {
          title: "Yeni Görev!",
          body: task.title || "Yeni bir göreviniz eklendi.",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {
          taskId: snap.id,
        },
      };

      // Tokenlara bildirim gönder
      try {
        const response = await messaging.sendToDevice(tokens, payload);
        console.log("Notification sent:", response);
      } catch (error) {
        console.error("Error sending notification:", error);
      }

      return null;
    });
