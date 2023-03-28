import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  //두개 이상의 animationController가 있으면 SingleTickerProviderStateMixin 못씀
  bool? _hasPermission;
  bool _isSelfieMode = false;
  late FlashMode _flashMode;

  late CameraController _cameraController;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void initState() {
    super.initState();
    initPermissions();
    _progressAnimationController.addListener(() {
      //애니메이션 값의 모든 변화가 생길때마다 호출될 함수
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      //애니메이션의 상태가 변할때마다 호출될 함수(끝났을 때 등)
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  Future<void> initPermissions() async {
    final camaeraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        camaeraPermission.isDenied || camaeraPermission.isPermanentlyDenied;
    final micdenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micdenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      _hasPermission = false;
      setState(() {});
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );
    await _cameraController.initialize();
    _flashMode = _cameraController.value.flashMode;
  }

  Future<void> _toggleSelphieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  void _startRecording() {
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  void _stopRecording() {
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _hasPermission == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Initializing...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                      ),
                    ),
                    Gaps.v20,
                    CircularProgressIndicator.adaptive(),
                  ],
                )
              : _hasPermission == false
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "You haven't accepted permissios :(",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size20,
                          ),
                        ),
                      ],
                    )
                  : _cameraController.value.isInitialized
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            CameraPreview(
                              _cameraController,
                            ),
                            Positioned(
                              top: Sizes.size20,
                              right: Sizes.size20,
                              child: Column(
                                children: [
                                  IconButton(
                                    color: Colors.white,
                                    onPressed: _toggleSelphieMode,
                                    icon: const Icon(Icons.cameraswitch),
                                  ),
                                  Gaps.v10,
                                  IconButton(
                                    color: _flashMode == FlashMode.off
                                        ? Colors.amber.shade200
                                        : Colors.white,
                                    onPressed: () =>
                                        _setFlashMode(FlashMode.off),
                                    icon: const Icon(Icons.flash_off_rounded),
                                  ),
                                  Gaps.v10,
                                  IconButton(
                                    color: _flashMode == FlashMode.always
                                        ? Colors.amber.shade200
                                        : Colors.white,
                                    onPressed: () =>
                                        _setFlashMode(FlashMode.always),
                                    icon: const Icon(Icons.flash_on_rounded),
                                  ),
                                  Gaps.v10,
                                  IconButton(
                                    color: _flashMode == FlashMode.auto
                                        ? Colors.amber.shade200
                                        : Colors.white,
                                    onPressed: () =>
                                        _setFlashMode(FlashMode.auto),
                                    icon: const Icon(Icons.flash_auto_rounded),
                                  ),
                                  Gaps.v10,
                                  IconButton(
                                    color: _flashMode == FlashMode.torch
                                        ? Colors.amber.shade200
                                        : Colors.white,
                                    onPressed: () =>
                                        _setFlashMode(FlashMode.torch),
                                    icon:
                                        const Icon(Icons.flashlight_on_rounded),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: Sizes.size40,
                              child: GestureDetector(
                                onTapDown: (details) => _startRecording(),
                                onTapUp: (details) => _stopRecording(),
                                child: ScaleTransition(
                                  scale: _buttonAnimation,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: Sizes.size80 + Sizes.size14,
                                        height: Sizes.size80 + Sizes.size14,
                                        child: CircularProgressIndicator(
                                          color: Colors.red.shade400,
                                          strokeWidth: Sizes.size6,
                                          value: _progressAnimationController
                                              .value,
                                        ),
                                      ),
                                      Container(
                                        width: Sizes.size80,
                                        height: Sizes.size80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
        ));
  }
}
