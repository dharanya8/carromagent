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
  final ScrollController scrollController = ScrollController();

  List<Message> messages = [];

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage() async {
    String text = controller.text.trim();

    if (text.isEmpty) return;

    // Mobile number validation
    bool isMobileStep = false;

    if (messages.isNotEmpty) {
      String lastMessage = messages.last.text.toLowerCase();

      if (lastMessage.contains("mobile") ||
          lastMessage.contains("phone")) {
        isMobileStep = true;
      }
    }

    if (isMobileStep) {
      if (!RegExp(r'^\d{10}$').hasMatch(text)) {
        setState(() {
          messages.add(
            Message(
              text: "Please enter a valid 10-digit mobile number.",
              isUser: false,
            ),
          );
        });

        scrollToBottom();
        return;
      }
    }

    controller.clear();

    // User Message
    setState(() {
      messages.add(
        Message(
          text: text,
          isUser: true,
        ),
      );
    });

    scrollToBottom();

    try {
      String reply = await ApiService.sendMessage(text);

      setState(() {
        messages.add(
          Message(
            text: reply,
            isUser: false,
          ),
        );
      });

      scrollToBottom();
    } catch (e) {
      setState(() {
        messages.add(
          Message(
            text: "Server connection error.",
            isUser: false,
          ),
        );
      });

      scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toto Carrom Agent"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
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
          ),
        ],
      ),
    );
  }
}