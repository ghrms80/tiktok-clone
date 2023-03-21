import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  bool _needPermissionAlert = false;

  bool _isSelfieMode = false;

  late FlashMode _flashMode;

  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    _flashMode = _cameraController.value.flashMode;
  }

  Future<void> initPermissions() async {
    _hasPermission = false;
    _needPermissionAlert = false;

    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraPermanentlyDenied = cameraPermission.isPermanentlyDenied;
    final micPermanentlyDenied = micPermission.isPermanentlyDenied;

    final cameraDenied = cameraPermission.isDenied || cameraPermanentlyDenied;
    final micDenied = micPermission.isDenied || micPermanentlyDenied;

    if (cameraPermanentlyDenied || micPermanentlyDenied) {
      openAppSettings();
    } else {
      if (!cameraDenied && !micDenied) {
        _hasPermission = true;
        await initCamera();
        setState(() {});
      } else {
        _needPermissionAlert = true;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  Future<void> toogleSelfieMode() async {
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
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? _needPermissionAlert
                ? AlertDialog(
                    title: const Text(
                        "The camera & microphone are permission denied"),
                    content: const Text("please set permission again"),
                    actions: [
                      TextButton(
                        onPressed: () => initPermissions(),
                        child: const Text("Again"),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Requesting permissions...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size20,
                        ),
                      ),
                      Gaps.v20,
                      CircularProgressIndicator.adaptive(),
                    ],
                  )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController),
                  Positioned(
                    top: Sizes.size20,
                    right: Sizes.size20,
                    child: Column(
                      children: [
                        IconButton(
                          color: Colors.grey.shade300,
                          onPressed: toogleSelfieMode,
                          icon: const Icon(
                            Icons.cameraswitch,
                          ),
                        ),
                        Gaps.v5,
                        IconButton(
                          color: _flashMode == FlashMode.off
                              ? Colors.amber.shade200
                              : Colors.grey.shade300,
                          onPressed: () => _setFlashMode(FlashMode.off),
                          icon: const Icon(
                            Icons.flash_off_rounded,
                          ),
                        ),
                        Gaps.v5,
                        IconButton(
                          color: _flashMode == FlashMode.always
                              ? Colors.amber.shade200
                              : Colors.grey.shade300,
                          onPressed: () => _setFlashMode(FlashMode.always),
                          icon: const Icon(
                            Icons.flash_on_rounded,
                          ),
                        ),
                        Gaps.v5,
                        IconButton(
                          color: _flashMode == FlashMode.auto
                              ? Colors.amber.shade200
                              : Colors.grey.shade300,
                          onPressed: () => _setFlashMode(FlashMode.auto),
                          icon: const Icon(
                            Icons.flash_auto_rounded,
                          ),
                        ),
                        Gaps.v5,
                        IconButton(
                          color: _flashMode == FlashMode.torch
                              ? Colors.amber.shade200
                              : Colors.grey.shade300,
                          onPressed: () => _setFlashMode(FlashMode.torch),
                          icon: const Icon(
                            Icons.flashlight_on,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.v10,
                ],
              ),
      ),
    );
  }
}
