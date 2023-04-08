import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_like_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
          "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(video);
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreateAt,
  }) {
    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);
    if (lastItemCreateAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreateAt]).get();
    }
  }

  Future<bool> likeVideo({
    required String videoId,
    required String userId,
  }) async {
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();

    if (!like.exists) {
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
      return false;
    } else {
      await query.delete();
      return true;
    }
  }

  Future<VideoLikeModel> isLiked({
    required String videoId,
    required String userId,
  }) async {
    final likeQuery = _db.collection("likes").doc("${videoId}000$userId");
    final videoQuery = _db.collection("videos").doc(videoId);

    final like = await likeQuery.get();
    final video = await videoQuery.get();
    final videoData = video.data();

    final VideoModel vm =
        VideoModel.fromJson(json: videoData!, videoId: videoId);

    return VideoLikeModel(isLikeVideo: like.exists, likeCount: vm.likes);
  }
}

final videosRepo = Provider(
  (ref) => VideosRepository(),
);
