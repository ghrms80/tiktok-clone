import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

void main() {
  runApp(const TicTokApp());
}

class TicTokApp extends StatelessWidget {
  const TicTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFFE9435A),
      ),
      home: Padding(
        padding: const EdgeInsets.all(Sizes.size14),
        child: Container(
          child: Row(
            children: const [
              Text('hello'),
              Gaps.h20,
              Text('hello'),
            ],
          ),
        ),
      ),
    );
  }
}
