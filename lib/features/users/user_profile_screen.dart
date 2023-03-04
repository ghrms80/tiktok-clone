import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          // pinned: true,
          stretch: true,
          backgroundColor: Colors.teal,
          collapsedHeight: 80,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.blurBackground,
              // StretchMode.fadeTitle,
              StretchMode.zoomBackground,
            ],
            background: Image.asset(
              "assets/images/placeholder.jpg",
              fit: BoxFit.cover,
            ),
            title: const Text("Hello!"),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 20,
              )
            ],
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            childCount: 25,
            (context, index) => Container(
              color: Colors.amber[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text("Item $index"),
              ),
            ),
          ),
          itemExtent: 100,
        ),
        SliverPersistentHeader(
          delegate: CustomDelegate(),
          floating: true,
          // pinned: true,
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: 40,
            (context, index) => Container(
              color: Colors.blue[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text("Item $index"),
              ),
            ),
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            mainAxisSpacing: Sizes.size20,
            crossAxisSpacing: Sizes.size20,
            childAspectRatio: 1,
          ),
        ),
      ],
    );
  }
}

class CustomDelegate extends SliverPersistentHeaderDelegate {
  @override
  // 사용자가 보게될 위젯을 반환
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.indigo,
      // 부모로부터 최대한 많은 공간을 차지하는 위젯
      child: const FractionallySizedBox(
        heightFactor: 1,
        child: Center(
          child: Text(
            'Title!!!',
            style: TextStyle(
              color: Colors.white,
              fontSize: Sizes.size20,
            ),
          ),
        ),
      ),
    );
  }

  @override
  // 최대 높이, getter이므로 double을 return
  double get maxExtent => 150;

  @override
  // 최저 높이, getter이므로 double을 return
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // flutter에게 persistent header가 보여져야 되는지 알려주는 메서드
    return false;
  }
}
