import 'dart:async';

// Mock chat service to generate a stream of messages
class MockChatService {
  final StreamController<String> _messageController =
      StreamController<String>();

  MockChatService() {
    // Simulate incoming messages using a timer
    Timer.periodic(const Duration(seconds: 5), (timer) {
      String message = 'New message at ${DateTime.now()}';

      _messageController.add(message);
    });
  }

  // Getter for the message stream
  Stream<String> get messageStream => _messageController.stream;

  // Dispose of resources
  void dispose() {
    _messageController.close();
  }
}
