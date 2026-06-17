// import 'package:flutter/material.dart';
// import 'toto_agent.dart';
//
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//
//   final agent = TotoAgent();
//
//   String result = "";
//
//   void search() {
//     final data = agent.findPlayer(
//       nameController.text,
//       phoneController.text,
//     );
//
//     setState(() {
//       if (data == null) {
//         result = "❌ No player found";
//       } else {
//         result = """
// ✅ Player Found
// Name: ${data["name"]}
// Phone: ${data["phone"]}
// Tournament: ${data["tournament"]}
// """;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Search Player")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: phoneController,
//               decoration: const InputDecoration(labelText: "Phone"),
//             ),
//
//             const SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: search,
//               child: const Text("Search"),
//             ),
//
//             const SizedBox(height: 20),
//
//             Text(result),
//           ],
//         ),
//       ),
//     );
//   }
// }