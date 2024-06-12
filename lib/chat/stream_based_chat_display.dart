import 'package:flutter/material.dart';

// Widget to display chat messages based on a stream
class StreamBasedChatDisplay extends StatelessWidget {
  const StreamBasedChatDisplay({
    super.key,
    required Stream<String> messageStream,
    required List<String> messages,
  })  : _messageStream = messageStream,
        _messages = messages;

  final Stream<String> _messageStream;
  final List<String> _messages;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      // StreamBuilder widget to handle changes in the message stream
      stream: _messageStream,
      builder: (context, snapshot) {
        // Handle different states of the stream
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Display an error message if there's an error with the stream
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || !snapshot.hasData) {
          // Display a message when there are no messages yet
          return const Center(child: Text('No messages yet'));
        } else {
          // Add new message to the list of messages
          _messages.add(snapshot.data!);
        }
        // Display a list of messages
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
