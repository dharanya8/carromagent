import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("http://YOUR_BACKEND_URL/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}),
    );

    final data = jsonDecode(response.body);
    return data["reply"];
  }
}