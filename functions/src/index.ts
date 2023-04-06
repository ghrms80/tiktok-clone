import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    // 새 영상이 생성될 때 실행
    // await snapshot.ref.update({"hello":"from functions"});
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl, // download video
      "-ss",
      "00:00:01.000", // 1 sec frame
      "-vframes",
      "1",
      "-vf", // video filter
      "scale=150:-1", // width=150, height=aspect ratio
      `/tmp/${snapshot.id}.jpg`, // temp storage
    ]);
    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
    await file.makePublic();
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });

    const db = admin.firestore();
    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({ thumbnailUrl: file.publicUrl(), videoId: snapshot.id });
  });
