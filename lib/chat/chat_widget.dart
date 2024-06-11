import 'package:flutter/material.dart';
import 'package:gemini_folder/chat/mock_chat_service.dart';
import 'package:gemini_folder/chat/stream_based_chat_display.dart';

class ChatScaffold extends StatefulWidget {
  const ChatScaffold({super.key});

  @override
  State<ChatScaffold> createState() => _ChatScaffoldState();
}

class _ChatScaffoldState extends State<ChatScaffold> {
  // I use a mock stream of data as gemini generates a stream too.
  final MockChatService _chatService = MockChatService();
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void dispose() {
    _chatService.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // Here, you would normally send the message to the server or add it to the stream
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
            child: StreamBasedChatDisplay(
                messageStram: _chatService.messageStream, messages: _messages),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                IconButton(
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