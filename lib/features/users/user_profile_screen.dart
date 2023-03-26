import 'package:flutter/material.dart';
import 'package:tiktok/constants/sizes.dart';

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
          // floating: true, //어느 위치에서든 스크롤을 살짝 올리면 앱바가 나타남
          // snap: true, //스크롤을 살짝 올리면 앱바가 스크롤양에 따라 나타나는 것이 아니라 전체가 바로 나타남
          pinned: true, //스크롤을 내려도 앱바 고정
          stretch: true,
          backgroundColor: Colors.deepPurple.shade100,
          elevation: 1,
          collapsedHeight: 80,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.blurBackground,
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            title: const Text('Hello'),
            background: Image.asset(
              'assets/images/placeholder.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            childCount: 10,
            (context, index) => Container(
              color: Colors.deepPurple[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text('Item $index'),
              ),
            ),
          ),
          itemExtent: 100,
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: 20,
            (context, index) => Container(
              color: Colors.deepPurple[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text('Item $index'),
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
