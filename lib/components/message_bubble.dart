import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  MessageBubble({required this.text, required this.sender, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(color: Colors.black54)),
          GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: text)).then((value) {
                HapticFeedback.heavyImpact();
                final snackBar = SnackBar(
                  content: Text('Message Copied'),
                  duration: Duration(milliseconds: 400),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            },
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5),
              child: Material(
                color: isMe ? Colors.lightBlue : Colors.purple,
                elevation: 6,
                borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(20) : Radius.zero,
                  topRight: isMe ? Radius.zero : Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: Text(
                    text,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
