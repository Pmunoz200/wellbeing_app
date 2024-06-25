import 'dart:convert';
import 'dart:typed_data';

class MessageObject {
  String? textMessage;
  Uint8List? audioMessage; // Using Uint8List for audio data
  Uint8List? pictureMessage; // Using Uint8List for picture data
  DateTime date;
  String owner;

  MessageObject({
    this.textMessage,
    this.audioMessage,
    this.pictureMessage,
    required this.date,
    required this.owner,
  });

  // Convert Uint8List to base64 string
  static String? encodeToBase64(Uint8List? data) {
    return data != null ? base64Encode(data) : null;
  }

  // Convert base64 string to Uint8List
  static Uint8List? decodeFromBase64(String? data) {
    return data != null ? base64Decode(data) : null;
  }

  // Method to convert MessageObject to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'textMessage': textMessage,
      // We neeed to modify the audio and picture data to store it on Firestore
      'audioMessage': encodeToBase64(audioMessage),
      'pictureMessage': encodeToBase64(pictureMessage),
      'date': date.toIso8601String(),
      'owner': owner,
    };
  }

  // Method to create a MessageObject from a Firestore map
  factory MessageObject.fromMap(Map<String, dynamic> map) {
    return MessageObject(
      textMessage: map['textMessage'],
      audioMessage: decodeFromBase64(map['audioMessage']),
      pictureMessage: decodeFromBase64(map['pictureMessage']),
      date: DateTime.parse(map['date']),
      owner: map['owner'],
    );
  }
}
