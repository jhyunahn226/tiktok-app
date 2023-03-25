import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/sizes.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Direct messages'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        child: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(
                radius: 30,
                foregroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/23349047?v=4'),
                child: Text('JH'),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Lynn',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '2:16 PM',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: Sizes.size12,
                    ),
                  ),
                ],
              ),
              subtitle: const Text("Don't forget to make video"),
            ),
          ],
        ),
      ),
    );
  }
}
