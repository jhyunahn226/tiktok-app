import 'package:flutter/cupertino.dart';
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
      body: Column(
        children: const [
          CupertinoActivityIndicator(
            radius: 40,
            animating: true,
          ),
          CircularProgressIndicator(),
          CircularProgressIndicator
              .adaptive(), //플랫폼에 따라 cupertino or material indicator 보여줌
        ],
      ),
    );
  }
}
