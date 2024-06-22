import 'package:chat_app_ayna/constant.dart';
import 'package:chat_app_ayna/core/manager/font_manager.dart';
import 'package:chat_app_ayna/core/manager/image_manager.dart';
import 'package:chat_app_ayna/model/user_model.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core/manager/color_manager.dart';
import '../core/services/web_socket_services.dart';
import '../utils/user_data.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final WebSocketService _webSocketService = WebSocketService();
  late Future<Box> _chatBoxFuture;
  List<Map<String, dynamic>> _messages = [];
  LocalUser? registeredUser;

  @override
  void initState() {
    super.initState();
    _chatBoxFuture = _initHive();
    _webSocketService.connect();
    _loadMessages();
    _webSocketService.messages.listen((message) {
      setState(() {
        final receivedMessage = {
          "sender": false,
          "message": message,
          "timestamp": DateTime.now().toIso8601String(),
        };
        _messages.add(receivedMessage);
        _saveMessage(receivedMessage);
      });
    });
  }

  Future<Box> _initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    final chatBox = await Hive.openBox('chatBox');
    _loadMessages();
    registeredUser = await getUserData();
    return chatBox;
  }

  void _loadMessages() async {
    final boxofchat = await Hive.openBox('chatBox');
    var messages = boxofchat.values.toList();
    List<Map<String, dynamic>> formattedMessages = [];
    messages.forEach((dynamic message) {
      formattedMessages.add(Map<String, dynamic>.from(message));
    });
    setState(() {
      _messages = formattedMessages;
    });
  }

  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      final sentMessage = {
        "sender": true,
        "message": message,
        "timestamp": DateTime.now().toIso8601String(),
      };
      setState(() {
        _messages.add(sentMessage);
        _saveMessage(sentMessage);
      });
      _webSocketService.sendMessage(message);
      _messageController.clear();
    }
  }

  Future<void> _saveMessage(Map<String, dynamic> message) async {
    final chatBox = await Hive.openBox('chatBox');
    chatBox.add(message);
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(homeBg), fit: BoxFit.cover)),
        child: GlassContainer(
          blur: 2,
          borderColor: Colors.white.withOpacity(0.2),
          borderGradient:
              LinearGradient(colors: [Colors.white.withOpacity(0.2)]),
          gradient: LinearGradient(colors: [
            Colors.black.withOpacity(0.4),
            Colors.white.withOpacity(0.2)
          ]),
          child: FutureBuilder(
            future: _chatBoxFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 2.w,
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.toNamed("/profile");
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 3.h,
                            backgroundImage: registeredUser == null
                               && (registeredUser?.profilePic).toString().contains("null")
                                ? null
                                : NetworkImage(registeredUser?.profilePic ?? ""),
                            child: registeredUser == null
                                && (registeredUser?.profilePic).toString().contains("null")
                                ? const SizedBox() : Icon(Icons.perm_identity_outlined,color: Colors.white,size: 2.h,)
                          ),
                        ),
                        SizedBox(
                          width: 35.w,
                        ),
                        Text(
                          "Chat Screen",
                          style: titleStyle,
                        ),
                        SizedBox(
                          width: 25.w,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              userRepo.logOut();
                            },
                            child: Text(
                              "LogOut",
                              style: logoutStyle,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 78.h,
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return BubbleSpecialOne(
                            delivered: !message['sender'],
                            text: message['message'],
                            isSender: message['sender'],
                            color: message['sender']
                                ? primaryDark.withOpacity(0.6)
                                : Colors.white.withOpacity(0.6),
                            textStyle:
                                message['sender'] ? senderStyle : receiverStyle,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 80.w,
                      height: 12.h,
                      child: Center(
                        child: SearchBar(
                            controller: _messageController,
                            hintText: "Enter message",
                            padding: WidgetStatePropertyAll(
                                EdgeInsets.only(left: 2.w)),
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.white60),
                            hintStyle: WidgetStatePropertyAll(textFieldStyle),
                            trailing: [
                              ElevatedButton(
                                onPressed: _sendMessage,
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        primaryDark.withOpacity(0.6))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.w, horizontal: 2.h),
                                  child: Text(
                                    "Send",
                                    style: buttonStyle,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    )
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
