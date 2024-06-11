import 'dart:async';

class MockChatService {
  final StreamController<String> _messageController =
      StreamController<String>();

  MockChatService() {
    // Simulate incoming messages
    Timer.periodic(const Duration(seconds: 5), (timer) {
      String message = 'New message at ${DateTime.now()}';
      
      _messageController.add(message);
    });
  }

  Stream<String> get messageStream => _messageController.stream;

  void dispose() {
    _messageController.close();
  }
}
