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

  bool isMobileStep = false;

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

  void updateStep() {
    if (messages.isNotEmpty) {
      String last = messages.last.text.toLowerCase();

      isMobileStep =
          last.contains("mobile") || last.contains("phone");
    } else {
      isMobileStep = false;
    }
  }

  void sendMessage() async {
    String text = controller.text.trim();

    if (text.isEmpty) return;

    controller.clear();

    setState(() {
      messages.add(Message(text: text, isUser: true));
    });

    scrollToBottom();

    try {
      String reply = await ApiService.sendMessage(text);

      setState(() {
        messages.add(Message(text: reply, isUser: false));
        updateStep();
      });

      scrollToBottom();
    } catch (e) {
      setState(() {
        messages.add(
          Message(text: "Server connection error.", isUser: false),
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
                final msg = messages[index];

                return ChatBubble(
                  message: msg.text,
                  isUser: msg.isUser,
                  onButtonPressed: (value) {
                    controller.text = value;
                    sendMessage();
                  },
                );
              },
            ),
          ),

          ChatInput(
            controller: controller,
            onSend: sendMessage,
            isMobileStep: isMobileStep,
          ),
        ],
      ),
    );
  }
}