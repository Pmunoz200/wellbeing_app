import 'package:flutter/material.dart';
import 'package:gemini_folder/chat/audio_player_widget.dart';
import 'package:gemini_folder/chat/message_class.dart';

class StreamBasedChatDisplay extends StatelessWidget {
  const StreamBasedChatDisplay({
    super.key,
    required this.messages,
  });

  final List<MessageObject> messages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            title: message.textMessage != null
                ? Text(message.textMessage!)
                : const Text("<<Empty Text>>"),
            subtitle: Text('Sent by ${message.owner}'),
            trailing: message.audioMessage != null
                ? AudioPlayerWidget(audioData: message.audioMessage!)
                : null,
          );
        },
      ),
    );
  }
}
