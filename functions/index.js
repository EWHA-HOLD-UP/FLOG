var admin = require("firebase-admin");
const functions = require("firebase-functions");
var serviceAccount = require("./flog-e708e-firebase-adminsdk-aj67m-97a960b137.json");
const express = require("express");
const cors = require("cors");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();

const app = express();
app.use(cors({origin: true}));

exports.pushFcm = functions.https.onRequest(app);

// "/update" 엔드포인트
app.post("/update", (req, res) => {
    const flogCode = req.body.flogCode; // 요청에서 flogCode 가져오기
    const tokens = [];
    if (flogCode) {
        // Firebase Firestore에서 flogCode와 일치하는 사용자 찾기
        db.collection("User")
            .where("flogCode", "==", flogCode)
            .get()
            .then((snapshot) => {
                snapshot.forEach((doc) => {
                    const token = doc.data().token;
                    if (token) {
                        tokens.push(token);
                    }
                });
                console.log(tokens);
                if (tokens.length > 0) {
                    const payload = {
                        notification: {
                            title: "가족알림",
                            body: "가족알림테스트입니다",
                        },
                    };
                    // 토큰 목록에 알림 보내기
                    admin.messaging().sendToDevice(tokens, payload)
                        .then((response) => {
                            console.log("Successfully sent message:", response);
                            return true;
                        });
                }
            })
            .catch((err) => {
                console.log("Error getting documents", err);
                tokens.push("Error getting documents");
                return tokens;
            });
    }
});

// "/updateAnswer" 엔드포인트
app.post("/updateAnswer", (req, res) => {
    const sendingUid = req.body.sendingUid; // 알림을 보내는 User의 uid
    const receivingUid = req.body.receivingUid; // 알림을 받는 User의 uid
    if (sendingUid && receivingUid) {
        // Firebase Firestore에서 receivingUid에 해당하는 사용자의 토큰 가져오기
        db.collection("User")
            .where("email", "==", receivingUid)
            .get()
            .then((snapshot) => {
                snapshot.forEach((doc) => {
                    const token = doc.data().token;
                    if (token) {
                        const payload = {
                            notification: {
                                title: "특정유저알림",
                                body: "특정유저알림테스트입니다",
                            },
                            data: {
                                sendingUid: sendingUid, // 알림을 보내는 User의 uid를 데이터로 포함
                            },
                        };
                        // 토큰에 알림 보내기
                        admin.messaging().sendToDevice(token, payload)
                            .then((response) => {
                                console.log("Successfully sent message:", response);
                                return true;
                            });
                    }
                });
            })
            .catch((err) => {
                console.log("Error getting documents", err);
            });
    }
});

// Express 앱을 Firebase Functions로 내보내기
exports.api = functions.https.onRequest(app);

exports.sendNotification = functions.https.onCall(async (data, context) => {
    await admin.messaging().sendMulticast({
    tokens: data.tokens,
    notification: {
        title: data.title,
        body: data.body,
        imageUrl: data.imageUrl,
    },
    });
})
