import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_models.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

const keywords = [
  "tag1",
  "tag2",
  "tag3",
  "tag4",
  "tag5",
  "tag6",
  "tag7",
  "tag8",
  "tag9",
];

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final VideoModel videoData;

  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
    required this.videoData,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

  bool _isPaused = false;
  bool _isMoreTagsShowed = false;

  final Iterable<String> _tags = keywords.map((tag) => "#$tag");
  late final String _tagString;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset(
      "assets/videos/video_mod.mp4",
    );
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    // if (kIsWeb) {
    //   await _videoPlayerController.setVolume(0.0);
    // }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _tagString = _tags.reduce((value, element) => "$value $element");

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );

    if (!ref.read(playbackConfigProvider).autoplay) {
      _isPaused = true;
    }
  }

  void _onPlaybackConfigChanged() {
    if (!mounted) return;
    final muted = ref.read(playbackConfigProvider).muted;
    ref.read(playbackConfigProvider.notifier).setMuted(!muted);
    if (muted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  }

  void _onLikeTap() {
    ref
        .read(videoPostProvider(
                '${widget.videoData.id}000${ref.read(authRepo).user!.uid}')
            .notifier)
        .likeVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;

    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
    }
    if (info.visibleFraction == 0 && _videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onSeeMoreClick() {
    setState(() {
      _isMoreTagsShowed = !_isMoreTagsShowed;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const VideoComments(),
      isScrollControlled: true,
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) => ref
      .watch(videoPostProvider(
          '${widget.videoData.id}000${ref.read(authRepo).user!.uid}'))
      .when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Could not load videos. $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (like) => VisibilityDetector(
          key: Key("${widget.index}"),
          onVisibilityChanged: _onVisibilityChanged,
          child: Stack(
            children: [
              Positioned.fill(
                child: _videoPlayerController.value.isInitialized
                    // https://stackoverflow.com/questions/57077639/
                    // how-to-boxfit-cover-a-fullscreen-videoplayer-widget-with-specific-aspect-ratio
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoPlayerController.value.aspectRatio,
                          height: 1,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      )
                    : Image.network(
                        widget.videoData.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  onTap: _onTogglePause,
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animationController.value,
                          child: child,
                        );
                      },
                      child: AnimatedOpacity(
                        opacity: _isPaused ? 1 : 0,
                        duration: _animationDuration,
                        child: const FaIcon(
                          FontAwesomeIcons.play,
                          color: Colors.white,
                          size: Sizes.size52,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 40,
                child: IconButton(
                  icon: FaIcon(
                    ref.watch(playbackConfigProvider).muted
                        ? FontAwesomeIcons.volumeOff
                        : FontAwesomeIcons.volumeHigh,
                    color: Colors.white,
                  ),
                  onPressed: _onPlaybackConfigChanged,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "@${widget.videoData.creator}",
                      style: const TextStyle(
                        fontSize: Sizes.size20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      widget.videoData.description,
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                        color: Colors.white,
                      ),
                    ),
                    Gaps.v10,
                    SizedBox(
                      width: 300,
                      child: _isMoreTagsShowed
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _tagString,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: Sizes.size16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _onSeeMoreClick,
                                  child: const Text(
                                    "Folded",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Sizes.size16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    _tagString,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: Sizes.size16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _onSeeMoreClick,
                                  child: const Text(
                                    "See more",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Sizes.size16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                    Gaps.v10,
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.music,
                          size: 16,
                          color: Colors.white,
                        ),
                        Gaps.h8,
                        SizedBox(
                          width: 200,
                          height: 16,
                          child: Marquee(
                            text:
                                "This text is to long to be shown in just one line",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: Sizes.size16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      foregroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-fb-proj.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media"),
                      child: Text(widget.videoData.creator),
                    ),
                    Gaps.v24,
                    GestureDetector(
                      onTap: _onLikeTap,
                      child: VideoButton(
                        icon: FontAwesomeIcons.solidHeart,
                        iconColor: like.isLikeVideo ? Colors.red : Colors.white,
                        text: S.of(context).likeCount(like.likeCount),
                      ),
                    ),
                    Gaps.v24,
                    GestureDetector(
                      onTap: () => _onCommentsTap(context),
                      child: VideoButton(
                        icon: FontAwesomeIcons.solidComment,
                        // text: S.of(context).commentCount(
                        //       widget.videoData.comments,
                        //     ),
                        text: "${widget.videoData.comments}",
                      ),
                    ),
                    Gaps.v24,
                    const VideoButton(
                      icon: FontAwesomeIcons.share,
                      text: "Share",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
