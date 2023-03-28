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

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool? _hasPermission;
  bool _isSelfieMode = false;
  late FlashMode _flashMode;

  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    initPermissions();
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
                          ],
                        )
                      : null,
        ));
  }
}
