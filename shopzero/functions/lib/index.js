'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();
exports.sendToDevice = functions.firestore
    .document('orders/{orderId}')
    .onCreate(async (snapshot) => {
    const order = snapshot.data();
    const querySnapshot = await db
        .collection('users')
        .doc()
        .collection('tokens')
        .get();
    const tokens = querySnapshot.docs.map(snap => snap.id);
    const payload = {
        notification: {
            title: 'New Order!',
            body: `you sold a ${null} for ${null}`,
            icon: 'your-icon-url',
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
    };
    return fcm.sendToDevice(tokens, payload);
});
//# sourceMappingURL=index.js.map