// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class UploadvideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  Future<void> uploadVideo({
    required File video,
    required BuildContext context,
    required String title,
    required String description,
  }) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;

    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );
        if (task.metadata != null) {
          await _repository.saveVideo(
            VideoModel(
              id: "",
              title: title,
              description: description,
              fileUrl: await task.ref.getDownloadURL(),
              thumbnailUrl: "",
              creatorUid: user.uid,
              creator: userProfile.name,
              likes: 0,
              comments: 0,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          context.pop();
          context.pop();
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadvideoViewModel, void>(
  () => UploadvideoViewModel(),
);
