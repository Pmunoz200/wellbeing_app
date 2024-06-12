import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  MessageInput({super.key, this.sendMessageFunction});

  final void Function(dynamic)? sendMessageFunction;
  // Controller for the text input field
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      String message = _controller.text;
                      sendMessageFunction!(message);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
