import 'dart:async';
import 'package:gemini_folder/chat/message_class.dart';

class MockChatService {
  final StreamController<MessageObject> _messageController =
      StreamController<MessageObject>();

  MockChatService() {
    // Simulate incoming messages using a timer
    Timer.periodic(const Duration(seconds: 5), (timer) {
      // Create a new MessageObject
      MessageObject message = MessageObject(
        textMessage: 'New message at ${DateTime.now()}',
        audioMessage: null, // No audio message in this example
        pictureMessage: null, // No picture message in this example
        date: DateTime.now(),
        owner: 'system', // Example owner
      );

      // Add the message to the stream
      _messageController.add(message);
    });
  }

  // Getter for the message stream
  Stream<MessageObject> get messageStream => _messageController.stream;

  // Method to add a new message to the stream
  void addMessage(MessageObject message) {
    _messageController.add(message);
  }

  // Dispose of resources
  void dispose() {
    _messageController.close();
  }
}