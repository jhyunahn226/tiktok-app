import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/features/videos/view_models/playback_config_vm.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

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
          SwitchListTile.adaptive(
            value: context.watch<PlaybackConfigViewModel>().muted,
            onChanged: (value) =>
                context.read<PlaybackConfigViewModel>().setMuted(value),
            title: const Text("Mute Video"),
            subtitle: const Text("Videos will be muted by default."),
          ),
          SwitchListTile.adaptive(
            value: context.watch<PlaybackConfigViewModel>().autoplay,
            onChanged: (value) =>
                context.read<PlaybackConfigViewModel>().setAutoplay(value),
            title: const Text("Auto Play"),
            subtitle: const Text("Videos will start playing automatically."),
          ),
          SwitchListTile.adaptive(
            value: _notifications,
            onChanged: _onNotificationsChanged,
            title: const Text("Enable notifications"),
            subtitle: const Text("They will be cute"),
          ),
          CheckboxListTile(
            value: _notifications,
            onChanged: _onNotificationsChanged,
            title: const Text("Marketing emails"),
            subtitle: const Text("We won't spam you"),
            checkColor: Colors.white,
            activeColor: Colors.black,
          ),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
              print(date);
              if (!mounted) return;
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print(time);
              if (!mounted) return;
              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              print(booking);
            },
            title: const Text("What is your birthday?"),
            subtitle: const Text("I need to know!"),
          ),

          ListTile(
            title: const Text('Log out (iOS)'),
            textColor: Colors.red,
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("Please don't go"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("No"),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Log out (Android)'),
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const FaIcon(FontAwesomeIcons.skull),
                  title: const Text("Are you sure?"),
                  content: const Text("Please don't go"),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const FaIcon(FontAwesomeIcons.car),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Log out (iOS / Bottom)'),
            textColor: Colors.red,
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: const Text("Are you sure?"),
                  message: const Text("Please doooont goooo"),
                  actions: [
                    CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Not log out'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDestructiveAction: true,
                      child: const Text('Yes plz'),
                    ),
                  ],
                ),
              );
            },
          ),
          const AboutListTile(
            applicationVersion: "1.0",
            applicationLegalese: "Don't copy me.",
          ), //위의 ListTile과 완전히 동일
        ],
      ),
    );
  }
}
