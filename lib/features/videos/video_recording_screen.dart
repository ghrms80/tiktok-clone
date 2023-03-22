import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/flash_mode.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  bool _needPermissionAlert = false;

  bool _isSelfieMode = false;

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
                        FlashModeWidget(
                          cameraController: _cameraController,
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
