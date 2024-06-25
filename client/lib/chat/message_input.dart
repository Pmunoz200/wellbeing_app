import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gemini_folder/chat/message_class.dart';
import 'package:image_picker/image_picker.dart';
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
  // Variables of type required as input for the audio and photo libraries
  Uint8List? _audioData;
  Uint8List? _imageData;

  //////////////// FUNCTIONS TO HANDLE USER PERMISSIONS AND ITS INTERACTIONS WITH THEM ////////////////
  Future<void> _initializeRecorderAndCamera() async {
    // Check microphone and camera permission status
    var microphoneStatus = await Permission.microphone.status;
    var cameraStatus = await Permission.camera.status;

    // List to keep track of missing permissions
    List<String> missingPermissions = [];

    // If microphone permission is not granted, add to missing permissions list
    if (microphoneStatus != PermissionStatus.granted) {
      missingPermissions.add("Microphone");
    }

    // If camera permission is not granted, add to missing permissions list
    if (cameraStatus != PermissionStatus.granted) {
      missingPermissions.add("Camera");
    }

    // Request permissions if there are any missing
    if (missingPermissions.isNotEmpty) {
      await _requestPermissions();

      // Update the status after requesting permissions
      microphoneStatus = await Permission.microphone.status;
      cameraStatus = await Permission.camera.status;
    }

    // Open audio session if microphone permission is granted
    if (microphoneStatus == PermissionStatus.granted) {
      await _recorder.openRecorder();
    }
  }

  Future<void> _requestPermissionDialog(List<String> missingPermissions) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Required"),
          content: Text(
              "The following permissions are required: ${missingPermissions.join(', ')}. Please grant these permissions to continue."),
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
        );
      },
    );
  }

  Future<void> _requestPermissions() async {
    List<String> missingPermissions = [];

    // Request microphone permission
    var microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus != PermissionStatus.granted) {
      missingPermissions.add("Microphone");
    }

    // Request camera permission
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus != PermissionStatus.granted) {
      missingPermissions.add("Camera");
    }

    if (missingPermissions.isNotEmpty) {
      _showErrorToast("Permissions required: ${missingPermissions.join(', ')}");
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

  //////////////// FUNCTIONS TO HANDLE AUDIO RECORDING AND MANAGING OF THE RESULTING FILE ////////////////
  void _startRecording() async {
    // Check microphone permission status
    var microphoneStatus = await Permission.microphone.status;
    // Handle case where permissions are still not granted
    if (microphoneStatus != PermissionStatus.granted) {
      _requestPermissionDialog(["Microphone"]);
      return;
    } else {
      if (!_isRecording) {
        try {
          await _recorder.openRecorder();
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
  }

  void _stopRecording() async {
    if (_isRecording) {
      try {
        String? path = await _recorder.stopRecorder();
        if (path != null) {
          _audioData = await _loadAudioFile(path);
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

  //////////////// FUNCTIONS TO HANDLE THE CAMERA AND THE RESULTING FILE ////////////////
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Check camera permission status
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus != PermissionStatus.granted) {
      _requestPermissionDialog(["Camera"]);
    } else {
      // Open the camera to pick an image
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      // If an image was picked, read it as bytes (Uint8List) and store it in the state
      if (image != null) {
        setState(() {
          _imageData = File(image.path)
              .readAsBytesSync(); // Read the image file as bytes and store it in _imageData
        });
      }
    }
  }

  //////////////// FUNCTIONS TO HANDLE AND SENDING THE MESSAGE OBJECT ////////////////
  void _handleSendMessage() {
    String? textMessage;
    Uint8List? audioMessage = _audioData;
    Uint8List? pictureMessage = _imageData;
    if (_controller.text.isNotEmpty) {
      textMessage = _controller.text;
      _controller.clear();
    }
    if (textMessage != null || audioMessage != null || pictureMessage != null) {
      _sendMessage(
          textMessage: textMessage,
          audioMessage: audioMessage,
          pictureMessage: pictureMessage);
    }
    setState(() {
      _audioData = null;
      _imageData = null;
    });
  }

  void _sendMessage(
      // This functions is the one risponsible of sending the message object to the db
      {String? textMessage,
      Uint8List? audioMessage,
      Uint8List? pictureMessage}) {
    MessageObject messageObject = MessageObject(
      textMessage: textMessage,
      audioMessage: audioMessage,
      pictureMessage: pictureMessage,
      date: DateTime.now(),
      owner: 'User', // TODO: Replace with actual owner identifier
    );
    widget.sendMessageFunction?.call(messageObject);
  }

  //////////////// FUNCTIONS OF THE REQUIRED OVERRIDES ////////////////
  @override
  void initState() {
    super.initState();
    _initializeRecorderAndCamera();
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
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          // Button to start working with the camera
          IconButton(
              onPressed: () async {
                if (_imageData != null) {
                  setState(() {
                    _imageData = null;
                  });
                }
                await _pickImage();
              },
              icon: Icon(
                Icons.camera_enhance_rounded,
                color: _imageData != null
                    ? Colors.blue
                    : Theme.of(context).colorScheme.onSurface,
              )),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: <Widget>[
                  /// Message input was divided into three parts: left and right buttons, and central input
                  /// The central input shows the data that will be sent, and the buttons allows to handle it.
                  /// The central input has two textField widgets, one is read only but this made it easy to
                  /// keep it symetric.
                  Column(
                    // Left widget to handle audio input.
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //
                      IconButton(
                        onPressed: () {},
                        icon: GestureDetector(
                          onLongPress: _startRecording,
                          onLongPressUp: _stopRecording,
                          onTap: () {
                            // Option to delete recorded audio;
                            if (_audioData != null) {
                              setState(() {
                                _audioData = null;
                              });
                              _shoeMessageToast("Audio deleted");
                            }
                          },
                          child: Icon(
                            _audioData == null ? Icons.mic : Icons.delete,
                            color: (_isRecording)
                                ? Colors.blue
                                : _audioData != null
                                    ? Colors.red
                                    : Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    // Central widget to visualize the current message to send
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.grey.withOpacity(0.5),
                          child: Row(
                            // Row with the audio and picture information if present
                            children: [
                              if (_audioData != null) ...[
                                Expanded(
                                  child: TextField(
                                    controller: null,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.audiotrack,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      hintText: 'Audio file.',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                )
                              ],
                              if (_imageData != null) ...[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.memory(
                                          _imageData!,
                                          width: 64,
                                          fit: BoxFit.cover,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            setState(() {
                                              _imageData = null;
                                            });
                                          },
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                        LayoutBuilder(builder: (context, constraints) {
                          double maxHeight =
                              MediaQuery.of(context).size.height / 5;
                          return SingleChildScrollView(
                              child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: maxHeight),
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: 'Enter text...',
                                border: InputBorder.none,
                              ),
                            ),
                          ));
                        }),
                      ],
                    ),
                  ),
                  Column(
                    // Send message widget
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.send,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                        onPressed: _handleSendMessage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
