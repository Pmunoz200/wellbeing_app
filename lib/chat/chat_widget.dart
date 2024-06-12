import 'package:flutter/material.dart';
import 'package:gemini_folder/chat/mock_chat_service.dart';
import 'package:gemini_folder/chat/stream_based_chat_display.dart';

class ChatScaffold extends StatefulWidget {
  const ChatScaffold({super.key});

  @override
  State<ChatScaffold> createState() => _ChatScaffoldState();
}

// Define the state for the chat screen
class _ChatScaffoldState extends State<ChatScaffold> {
  // Create a mock chat service
  final MockChatService _chatService = MockChatService();
  // Controller for the text input field
  final TextEditingController _controller = TextEditingController();
  // List to hold chat messages
  final List<String> _messages = [];

  @override
  void dispose() {
    // Dispose of resources when the widget is disposed
    _chatService.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Function to send a message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // Clear the text field after sending the message
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            // Display chat messages using StreamBasedChatDisplay widget
            child: StreamBasedChatDisplay(
                messageStream: _chatService.messageStream, messages: _messages),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  // Text input field for typing messages
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                IconButton(
                  // Button to send messages
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
