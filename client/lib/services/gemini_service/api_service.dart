import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'conversation_model.dart';

class ApiService {
  final String baseUrl;

  // Constructor to initialize the base URL
  ApiService({required this.baseUrl});

  // Method to get a response from the server
  Future<ConversationModel> getResponse(String uid, String query, DateTime date) async {
    // Format the date to the required string format
    final String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(date);
    // Make a GET request to the server
    final response = await http.get(Uri.parse('$baseUrl/get_response?uid=$uid&query=$query&date=$formattedDate'));

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // Parse the JSON response and return the ConversationModel
      return ConversationModel.fromJson(jsonDecode(response.body));
    } else {
      // Throw an exception if the request failed
      throw Exception('Failed to load conversation');
    }
  }
  // Method to get a list of messages on a specific date from the server
  Future<ConversationModel> getUserMessagesByDate(String uid, String query, DateTime date) async {
    // Format the date to the required string format
    final String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(date);
    // Make a GET request to the server
    final response = await http.get(Uri.parse('$baseUrl/get_user_messages_by_date?uid=$uid&date=$formattedDate'));

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // Parse the JSON response and return the ConversationModel
      final conversationList = ConversationModel.fromJson(jsonDecode(response.body));
      return conversationList;
    } else {
      // Throw an exception if the request failed
      throw Exception('Failed to load conversation');
    }
  }
}
