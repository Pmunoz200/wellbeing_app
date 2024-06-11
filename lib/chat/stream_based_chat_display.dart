import 'package:flutter/material.dart';

class StreamBasedChatDisplay extends StatelessWidget {
  const StreamBasedChatDisplay({
    super.key,
    required Stream<String> messageStram,
    required List<String> messages,
  })  : _messageStream = messageStram,
        _messages = messages;

  final Stream<String> _messageStream;
  final List<String> _messages;

  @override
  Widget build(BuildContext context) {
    // I use a stream builder as it helps me handle the changing state of the stream
    return StreamBuilder<String>(
      stream: _messageStream,
      builder: (context, snapshot) {
        // First we consider the loading, error, new, and empty states of the stream
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || !snapshot.hasData) {
          return const Center(child: Text('No messages yet'));
        } else {
          // Only add the new message if snapshot has data
          // setState is not necesary as the builder handles the rebuild
          _messages.add(snapshot.data!);
        }
        // Display a list of messages if there is a stream
        return ListView.builder(
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_messages[index]),
            );
          },
        );
      },
    );
  }
}
