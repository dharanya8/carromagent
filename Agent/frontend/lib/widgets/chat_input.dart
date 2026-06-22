import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isMobileStep;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.isMobileStep = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,

              keyboardType: isMobileStep
                  ? TextInputType.number
                  : TextInputType.text,

              inputFormatters: isMobileStep
                  ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
                  : [],

              textInputAction: TextInputAction.send,

              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  onSend();
                }
              },

              decoration: InputDecoration(
                hintText: isMobileStep
                    ? "Enter 10-digit mobile number"
                    : "Type message...",
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}