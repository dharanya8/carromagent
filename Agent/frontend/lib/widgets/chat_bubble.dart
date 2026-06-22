import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final Function(String)? onButtonPressed;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool showMenuButtons =
        !isUser &&
            message.contains("Register for a Tournament") &&
            message.contains("Check Registration Details");

    bool showCategoryButtons =
        !isUser &&
            message.contains("Select Category");

    bool showYesNoButtons =
        !isUser &&
            message.contains("Type Yes or No");

    return Align(
      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              message,
              style: TextStyle(
                color: isUser
                    ? Colors.white
                    : Colors.black,
              ),
            ),

            // Main Menu Buttons
            if (showMenuButtons) ...[
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  onButtonPressed?.call("1");
                },
                child: const Text(
                  "🏆 Register",
                ),
              ),

              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: () {
                  onButtonPressed?.call("2");
                },
                child: const Text(
                  "📋 Registration Details",
                ),
              ),
            ],

            // Category Buttons
            if (showCategoryButtons) ...[
              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        onButtonPressed?.call("1"),
                    child: const Text("Singles"),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        onButtonPressed?.call("2"),
                    child: const Text("Doubles"),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        onButtonPressed?.call("3"),
                    child: const Text("Knockout"),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        onButtonPressed?.call("4"),
                    child: const Text("Robin"),
                  ),
                ],
              ),
            ],

            // Yes / No Buttons
            if (showYesNoButtons) ...[
              const SizedBox(height: 10),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        onButtonPressed?.call("yes"),
                    child: const Text("Yes"),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () =>
                        onButtonPressed?.call("no"),
                    child: const Text("No"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}