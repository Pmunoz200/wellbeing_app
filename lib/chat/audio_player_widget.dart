import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List audioData;

  const AudioPlayerWidget({required this.audioData, Key? key}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.openPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.closePlayer();
    super.dispose();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stopPlayer();
    } else {
      // Request audio permission if not granted
      if (await Permission.microphone.request().isGranted) {
        await _audioPlayer.startPlayer(
          fromDataBuffer: widget.audioData,
          codec: Codec.aacADTS,
        );
      } else {
        // Handle permission denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Microphone permission is required to play audio')),
        );
        return;
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
      onPressed: _playPauseAudio,
    );
  }
}
