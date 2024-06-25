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
            trailing: _buildTrailingWidget(message),
          );
        },
      ),
    );
  }

  Widget? _buildTrailingWidget(MessageObject message) {
    List<Widget> widgets = [];

    if (message.audioMessage != null) {
      widgets.add(AudioPlayerWidget(audioData: message.audioMessage!));
    }

    if (message.pictureMessage != null) {
      widgets.add(Image.memory(
        message.pictureMessage!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ));
    }

    // Return null if no widgets to show
    if (widgets.isEmpty) {
      return null;
    }

    // Wrap widgets in a row if there are multiple
    if (widgets.length > 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      );
    } else {
      return widgets.first;
    }
  }
}
