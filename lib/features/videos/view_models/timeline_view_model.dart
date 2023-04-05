import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];

  void uploadVideo() async {
    // timeline view model이 다시 loading state가 되도록 만들어 줌
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 2));

    // final newVideo = VideoModel(title: "${DateTime.now()}");
    // _list = [..._list, newVideo];

    _list = [..._list];
    // state = _list;  // 이렇게 데이터를 받을 수 없다.
    // AsyncNotifier 안에 있기 때문에 AsyncValue로 데이터를 받을수 있다.
    state = AsyncValue.data(_list);
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(const Duration(seconds: 5));
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
