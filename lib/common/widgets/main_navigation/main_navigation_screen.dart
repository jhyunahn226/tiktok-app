import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/discover/discover_screen.dart';
import 'package:tiktok/features/inbox/inbox_screen.dart';
import 'package:tiktok/common/widgets/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok/common/widgets/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok/features/users/user_profile_screen.dart';
import 'package:tiktok/features/videos/views/video_recording_screen.dart';
import 'package:tiktok/features/videos/views/video_timeline_screen.dart';
import 'package:tiktok/utils.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = 'mainnavigation';

  final String tab;

  const MainNavigationScreen({super.key, required this.tab});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "discover",
    "video",
    "inbox",
    "profile",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    context.pushNamed(VideoRecordingScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return Scaffold(
      resizeToAvoidBottomInset: false, //키보드가 나타날 때 자동으로 화면사이즈를 줄이지 않음
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(username: 'JHyun', tab: ''),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
        padding: const EdgeInsets.only(
          bottom: Sizes.size32,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: 'Home',
                isSelected: _selectedIndex == 0,
                selectedIndex: _selectedIndex,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
              ),
              NavTab(
                text: 'Discover',
                isSelected: _selectedIndex == 1,
                selectedIndex: _selectedIndex,
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                onTap: () => _onTap(1),
              ),
              Gaps.h24,
              GestureDetector(
                onTap: _onPostVideoButtonTap,
                child: PostVideoButton(
                  inverted: _selectedIndex != 0,
                ),
              ),
              Gaps.h24,
              NavTab(
                text: 'Inbox',
                isSelected: _selectedIndex == 3,
                selectedIndex: _selectedIndex,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTap: () => _onTap(3),
              ),
              NavTab(
                text: 'Profile',
                isSelected: _selectedIndex == 4,
                selectedIndex: _selectedIndex,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
