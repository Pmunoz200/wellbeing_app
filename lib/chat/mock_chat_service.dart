import 'dart:async';

// Mock chat service to generate a stream of messages
class MockChatService {
  final StreamController<String> _messageController =
      StreamController<String>();

  MockChatService() {
    // Simulate incoming messages using a timer
    Timer.periodic(const Duration(seconds: 5), (timer) {
      String message = 'New message at ${DateTime.now()}';

      // Add the message to the stream
      _messageController.add(message);
    });
  }

  // Getter for the message stream
  Stream<String> get messageStream => _messageController.stream;

  // Method to add a new message to the stream
  void addMessage(String message) {
    _messageController.add(message);
  }

  // Dispose of resources
  void dispose() {
    _messageController.close();
  }
}
