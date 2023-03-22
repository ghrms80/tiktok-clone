import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';

class FlashModeWidget extends StatelessWidget {
  const FlashModeWidget({
    super.key,
    required this.cameraController,
  });

  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlashModeWidgetItem(
          cameraController: cameraController,
          mode: FlashMode.off,
        ),
        Gaps.v10,
        FlashModeWidgetItem(
          cameraController: cameraController,
          mode: FlashMode.always,
        ),
        Gaps.v10,
        FlashModeWidgetItem(
          cameraController: cameraController,
          mode: FlashMode.auto,
        ),
        Gaps.v10,
        FlashModeWidgetItem(
          cameraController: cameraController,
          mode: FlashMode.torch,
        ),
      ],
    );
  }
}

class FlashModeWidgetItem extends StatefulWidget {
  final CameraController cameraController;
  final FlashMode mode;
  late final IconData iconData;

  FlashModeWidgetItem({
    Key? key,
    required this.cameraController,
    required this.mode,
  }) : super(key: key) {
    switch (mode) {
      case FlashMode.off:
        iconData = Icons.flash_off;
        break;
      case FlashMode.auto:
        iconData = Icons.flash_auto;
        break;
      case FlashMode.always:
        iconData = Icons.flash_on;
        break;
      case FlashMode.torch:
        iconData = Icons.flashlight_on;
        break;
    }
  }

  @override
  State<FlashModeWidgetItem> createState() => _FlashModeWidgetItemState();
}

class _FlashModeWidgetItemState extends State<FlashModeWidgetItem> {
  late bool _isMe;

  void _checkMode() {
    _isMe = widget.cameraController.value.flashMode == widget.mode;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _checkMode();
    widget.cameraController.addListener(() {
      _checkMode();
    });
  }

  @override
  void dispose() {
    widget.cameraController.removeListener(() {});
    super.dispose();
  }

  Future<void> _onTap() async {
    await widget.cameraController.setFlashMode(widget.mode);
    _checkMode();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(
        widget.iconData,
        color: _isMe ? Colors.amber.shade300 : Colors.grey.shade200,
      ),
      onPressed: _onTap,
    );
  }
}
