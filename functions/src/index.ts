import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// firestore 외에도 database, auth도 가능
export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    // snapshot은 방금 만들어진 영상을 의미
    await snapshot.ref.update({"hello":"from functions"});
  });
