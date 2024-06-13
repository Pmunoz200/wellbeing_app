import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gemini_folder/chat/message_class.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageInput extends StatefulWidget {
  final void Function(MessageObject)? sendMessageFunction;

  const MessageInput({super.key, this.sendMessageFunction});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  Uint8List? audioData;

  Future<void> _initializeRecorder() async {
    // Check microphone permission status
    // In case it is needed, I can send users to to app settings with: openAppSettings();
    var status = await Permission.microphone.status;
    if (status != PermissionStatus.granted) {
      // Request microphone permission if it is not granted or denied
      await _requestMicrophonePermission();
      // Handle case where microphone permission is not granted
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied) {
        // Display dialog informing the user about the requirement to grant microphone permission
        _requestPermissionDialog();
        return;
      }
    }

    // Open audio session
    await _recorder.openRecorder();
  }

  // In case the user does not allow the app to use the mic,
  // we can offer to take them to the config to change it.
  Future<void> _requestPermissionDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
            "Microphone permission is required for audio recording."),
        actions: <Widget>[
          TextButton(
            child: const Text("Go to Settings"),
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              await openAppSettings(); // Open app settings
            },
          ),
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
          ),
        ],
      ),
    );
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Handle case where user denied or did not grant microphone permission
      _showErrorToast("Microphone permission are required for the audio");
      return;
    }
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _shoeMessageToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  void _startRecording() async {
    if (!_isRecording) {
      try {
        await _recorder.startRecorder(
          toFile: 'audio_record.aac',
          codec: Codec.aacADTS,
        );
        setState(() {
          _isRecording = true;
        });
        _shoeMessageToast("Hold button to record");
      } catch (e) {
        _showErrorToast("Error starting recording: $e");
      }
    }
  }

  void _stopRecording() async {
    if (_isRecording) {
      try {
        String? path = await _recorder.stopRecorder();
        if (path != null) {
          audioData = await _loadAudioFile(path);
          // _sendMessage(audioMessage: audioData);
          _shoeMessageToast("Recording stopped");
        }
      } catch (e) {
        _showErrorToast("Error stopping recording: $e");
      } finally {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  Future<Uint8List> _loadAudioFile(String path) async {
    final file = File(path);
    return await file.readAsBytes();
  }

  void _handleSendMessage() {
    String? textMessage;
    Uint8List? audioMessage = audioData;
    if (_controller.text.isNotEmpty) {
      textMessage = _controller.text;
      _controller.clear();
    }
    if (textMessage != null || audioMessage != null) {
      _sendMessage(textMessage: textMessage, audioMessage: audioMessage);
    }
    setState(() {
      audioData = null;
    });
  }

  void _sendMessage({String? textMessage, Uint8List? audioMessage}) {
    MessageObject messageObject = MessageObject(
      textMessage: textMessage,
      audioMessage: audioMessage,
      date: DateTime.now(),
      owner: 'User', // Replace with actual owner identifier
    );
    widget.sendMessageFunction?.call(messageObject);
  }

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(180.0)),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: GestureDetector(
                onLongPress: _startRecording,
                onLongPressUp: _stopRecording,
                onTap: () {
                  // Option to delete recorded audio;
                  if (audioData != null) {
                    setState(() {
                      audioData = null;
                    });
                    _shoeMessageToast("Audio deleted");
                  }
                },
                child: Icon(
                  Icons.mic,
                  color: (_isRecording)
                      ? Colors.red
                      : audioData != null
                          ? Colors.blue
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter a message',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              onPressed: _handleSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
