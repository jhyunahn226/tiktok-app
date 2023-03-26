import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => showAboutDialog(
              context: context,
              applicationVersion: '1.0',
              applicationLegalese: "All rights reserved. Please don't copy me",
            ), //앱정보를 보여주는 기본 함수
            title: const Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'About this app...',
            ),
          ),
          const AboutListTile(),
        ],
      ),
    );
  }
}