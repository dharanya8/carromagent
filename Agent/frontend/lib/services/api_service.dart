import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/chat"),
<<<<<<< HEAD
      // Uri.parse("http://192.168.1.104:8000/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}),
=======
      //Uri.parse("http://192.168.1.104:8000/chat"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "message": message,
      }),
>>>>>>> ea58d5a507b1340a5037d6d902606130c735729d
    );

    print(response.statusCode);
    print(response.body);

    final data = jsonDecode(response.body);

    return data["reply"];
  }
}
