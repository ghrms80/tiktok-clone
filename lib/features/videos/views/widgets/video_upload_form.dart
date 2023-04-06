import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/models/video_upload.dart';

class VideoUploadForm extends StatefulWidget {
  const VideoUploadForm({super.key});
  static Route<VideoUpload?> route() =>
      MaterialPageRoute(builder: (context) => const VideoUploadForm());

  @override
  State<VideoUploadForm> createState() => _VideoUploadFormState();
}

class _VideoUploadFormState extends State<VideoUploadForm> {
  late final TextEditingController _titleController =
      TextEditingController(text: "");
  late final TextEditingController _descriptionController =
      TextEditingController(text: "");

  void _onSubmit() {
    final data = VideoUpload(
      title: _titleController.text,
      description: _descriptionController.text,
    );
    Navigator.pop(
      context,
      data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video upload"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gaps.h24,
                const CloseButton(),
                Gaps.h24,
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                  ),
                ),
                Gaps.v24,
                TextField(
                  controller: _descriptionController,
                  maxLength: 250,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.size14),
                      ),
                    ),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onSubmit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.size18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.size14),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      "Upload Video",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
