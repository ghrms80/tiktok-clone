import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [];

/*   @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);

    final result = await _repository.fetchVideos(
      lastItemCreateAt: null,
    );
    final newList = result.docs.map(
      (doc) => VideoModel.fromJson(
        doc.data(),
      ),
    );

    _list = newList.toList();
    return _list;
  } */

  // 공통으로 사용되는 부분
  Future<List<VideoModel>> _fetchVideos({
    int? lastItemCreateAt,
  }) async {
    final result = await _repository.fetchVideos(
      lastItemCreateAt: null,
    );
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        doc.data(),
      ),
    );

    return videos.toList();
  }

  // 처음 호출시
  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);
    _list = await _fetchVideos(lastItemCreateAt: null);
    return _list;
  }

  // 연속해서 호출시
  fetchNextPage() async {
    final nextPage = await _fetchVideos(
      lastItemCreateAt: _list.last.createdAt,
    );
    _list = [..._list, ...nextPage];
    state = AsyncValue.data(_list);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
