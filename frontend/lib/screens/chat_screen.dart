import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  List<Message> messages = [];

  void sendMessage() async {
    String text = controller.text;
    controller.clear();

    setState(() {
      messages.add(Message(text: text, isUser: true));
    });

    // call backend AI agent
    String reply = await ApiService.sendMessage(text);

    setState(() {
      messages.add(Message(text: reply, isUser: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI WhatsApp Agent"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[index].text,
                  isUser: messages[index].isUser,
                );
              },
            ),
          ),

          ChatInput(
            controller: controller,
            onSend: sendMessage,
          )
        ],
      ),
    );
  }
}