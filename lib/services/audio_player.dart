import 'package:audioplayers/audioplayers.dart';

class ChatAudioPlayer {
  ChatAudioPlayer._privateCOnstructor();
  static final ChatAudioPlayer chatAudioPlayer = ChatAudioPlayer._privateCOnstructor();
  factory ChatAudioPlayer() {
    return chatAudioPlayer;
  }
  final player = AudioCache();
  void play() {
    player.play('new_messagge.wav');
  }
}
