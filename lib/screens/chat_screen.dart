import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/services/audio_player.dart';
import 'package:flash_chat/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final ScrollController scrollController = ScrollController();
final List<MessageBubble> messages = [];
late final User loggedInUser;
void sendMessage(String message) async {
  await _firestore.collection('messages').add({
    'text': message,
    'sender': loggedInUser.email,
    'timestamp': Timestamp.now(),
  });
}

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isScrollArrowShown = false;
  String message = '';
  void getCurrentUser() {
    loggedInUser = _auth.currentUser!;
  }

  @override
  void initState() {
    getCurrentUser();
    scrollController.addListener(() => autoShowScrollArrow());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                MessageStream(),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          maxLines: 4,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) => message = value,
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      TextButton(
                        onPressed: onSendButtonPressed,
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isScrollArrowShown)
              Positioned(
                bottom: 60,
                left: 15,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.zero),
                  child: Icon(Icons.arrow_downward, size: 30),
                  onPressed: () {
                    scrollController.animateTo(scrollController.position.minScrollExtent,
                        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onSendButtonPressed() {
    //Notifications().push(sender: loggedInUser.email!, message: message);
    sendMessage(message);
    message = '';
    textEditingController.clear();
  }

  void autoShowScrollArrow() {
    if (!isScrollArrowShown && scrollController.offset > scrollController.position.minScrollExtent + 35)
      setState(() => isScrollArrowShown = true);
    else if (isScrollArrowShown && scrollController.offset == scrollController.position.minScrollExtent)
      setState(() => isScrollArrowShown = false);
  }
}

class MessageStream extends StatefulWidget {
  @override
  State<MessageStream> createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (messages.length != snapshot.data!.docs.length) {
            for (var doc in snapshot.data!.docs) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              var messageText = data['text'];
              debugPrint('Messagooo: $messageText');
              var messageSender = data['sender'];
              messages.add(MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: messageSender == loggedInUser.email,
              ));
            }
          }
          debugPrint('lastoo : ' + messages.last.text);
          debugPrint('list length = ${messages.length}');
          //ChatAudioPlayer().play();
          return Expanded(
            child: ListView.builder(
              itemBuilder: (context, item) {
                return MessageBubble(
                    text: snapshot.data!.docs[item]['text'],
                    sender: snapshot.data!.docs[item]['sender'],
                    isMe: snapshot.data!.docs[item]['sender'] == loggedInUser.email);
              },
              itemCount: snapshot.data!.docs.length,
              //children: messages,
              reverse: true,
              controller: scrollController,
            ),
          );
        });
  }
}
