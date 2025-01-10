import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
import 'package:busy_faker/services/ChatGPT/api_key.dart';

class ChatGPTService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  final String apiKey = gptApiKey;
  final String command;

  ChatGPTService({required this.command});

  Future<String> getChatResponse(String message) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "model": "gpt-4o-mini",
      "store": true,
      "messages": [
        {"role": "system", "content": "Respond in zh-tw"},
        {"role": "system", "content": command},
        {"role": "user", "content": message}
      ]
    });

    try {
      final response = await http.post(Uri.parse(_baseUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final generatedMessage = jsonResponse['choices'][0]['message']['content'];
        dev.log('Response: $generatedMessage');
        return generatedMessage;
      } else {
        dev.log('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('Exception: $e');
      throw Exception('Failed to send message: $e');
    }
  }
}
