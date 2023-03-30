import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/common/widgets/video_configuration/video_config.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/videos/widgets/video_button.dart';
import 'package:tiktok/features/videos/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    Key? key,
    required this.onVideoFinished,
    required this.index,
  }) : super(key: key);

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;

  bool _isPaused = false;
  final Duration _animationDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/video.mp4');
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0); //웹에서는 볼륨이 0이어야 autoplay를 지원함
    }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // print('Video #${widget.index} is ${info.visibleFraction * 100}% visible');
    if (!mounted) return; //Widget트리에서 제거된 상태라면 아무것도 안함
    if (info.visibleFraction == 1 && //VisibilityDetector위젯이 100% 보는 상태가 되면
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse(); //1.0 -> 1.5
      setState(() {
        _isPaused = true;
      });
    } else {
      _videoPlayerController.play();
      _animationController.forward(); //1.5 -> 1.0
      setState(() {
        _isPaused = false;
      });
    }
  }

  void _onCommentsTap() async {
    if (_videoPlayerController.value.isPlaying) {
      //영상이 재생 중이면
      _onTogglePause(); //일시정지
    }
    await showModalBottomSheet(
      //await을 붙이면 modal bottom sheet을 닫을 때 까지 기다린다
      context: context,
      builder: (context) => const VideoComments(),
      shape: RoundedRectangleBorder(
        //이렇게 해야 borderradius를 줄 수 있음
        borderRadius: BorderRadius.circular(Sizes.size16),
      ),
      isScrollControlled: true, //bottomsheet안에 ListView를 넣을거라면 true로 해야함
    );
    _onTogglePause(); //다시재생
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.index}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              //클릭 무시
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: AnimatedOpacity(
                        opacity: _isPaused ? 1 : 0,
                        duration: _animationDuration,
                        child: const FaIcon(
                          FontAwesomeIcons.play,
                          color: Colors.white,
                          size: Sizes.size52,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: FaIcon(
                VideoConfigData.of(context).autoMute
                    ? FontAwesomeIcons.volumeHigh
                    : FontAwesomeIcons.volumeOff,
                color: Colors.white,
              ),
              onPressed: VideoConfigData.of(context).toggleMuted,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '@jhyun_beem',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.v10,
                Text(
                  '모여서 각자 BEEM! Join Us!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/23349047?v=4"),
                  child: Text('JH'),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: '2.9M',
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onCommentsTap,
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: '33k',
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: 'Share',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
