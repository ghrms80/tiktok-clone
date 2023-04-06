import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload a video file
  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
          "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(video);
  }

  // create a video document
  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos() {
    // 모든 비디오들을 얻음
    // return _db.collection("videos").get();
    // 필터 적용
    // return _db.collection("videos")
    //          .where("likes", isGreaterThan: 10,).get();
    return _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .get(); //내림차순: 가장 큰 날짜부터 작은 날짜순으로 정렬
  }
}

final videosRepo = Provider((ref) => VideosRepository());
