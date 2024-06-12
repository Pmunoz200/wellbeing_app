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
      // Get the message from the text input field
      String message = _controller.text;

      // Add the message to the stream
      _chatService.addMessage(message);

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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // StreamBuilder widget to handle changes in the message stream
              Expanded(
                child: StreamBuilder<String>(
                  stream: _chatService.messageStream,
                  builder: (context, snapshot) {
                    // Handle different states of the stream (error, empty, loading, has content)
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
                    // Pass the updated messages list to StreamBasedChatDisplay
                    return StreamBasedChatDisplay(messages: _messages);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  color: Colors.lightGreen,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
