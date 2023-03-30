import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/utils.dart';

class ChatDetailScreen extends StatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  bool _isWriting = false;

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _onStopWriting() {
    FocusScope.of(context).unfocus();
    _isWriting = false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: Sizes.size20,
                foregroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/23349047?v=4'),
                child: Text('JH'),
              ),
              Positioned(
                bottom: -Sizes.size2,
                right: 0,
                child: Container(
                  width: Sizes.size16,
                  height: Sizes.size16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white,
                      width: Sizes.size2,
                    ),
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            'Lynn (${widget.chatId})',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text('Active now'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _onStopWriting,
        child: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size20,
                horizontal: Sizes.size14,
              ),
              itemBuilder: (context, index) {
                final isMine = index % 2 == 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Sizes.size14),
                      decoration: BoxDecoration(
                        color: isMine
                            ? Colors.blue
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(Sizes.size20),
                          topRight: const Radius.circular(Sizes.size20),
                          bottomLeft: Radius.circular(
                              isMine ? Sizes.size20 : Sizes.size5),
                          bottomRight: Radius.circular(
                              !isMine ? Sizes.size20 : Sizes.size5),
                        ),
                      ),
                      child: const Text(
                        'this is a message!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 10,
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                padding: const EdgeInsets.only(
                  left: Sizes.size14,
                  right: Sizes.size14,
                  top: Sizes.size6,
                  bottom: Sizes.size28,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onTap: _onStartWriting,
                        minLines: null,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          hintText: 'Send a message...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Sizes.size20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size12,
                            vertical: Sizes.size10,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: Sizes.size14,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.faceLaugh,
                                  size: Sizes.size20,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_isWriting)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: Sizes.size10,
                        ),
                        child: Container(
                          width: Sizes.size36,
                          height: Sizes.size36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade400,
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidPaperPlane,
                              color: Colors.white,
                              size: Sizes.size20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
