import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
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

              keyboardType: TextInputType.text,

              // Max 10 characters only
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],

              textInputAction: TextInputAction.send,

              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  onSend();
                }
              },

              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
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