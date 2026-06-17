// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'toto_agent.dart';
//
// class DetailsPage extends StatefulWidget {
//   final String phone;
//
//   const DetailsPage({required this.phone, super.key});
//
//   @override
//   State<DetailsPage> createState() => _DetailsPageState();
// }
//
// class _DetailsPageState extends State<DetailsPage> {
//
//   final _formKey = GlobalKey<FormState>();
//   final agent = TotoAgent();
//
//   final nameController = TextEditingController();
//   final dobController = TextEditingController();
//
//   String? tournament;
//   DateTime? selectedDate;
//
//   final List tournaments = [
//     "Toto Cup",
//     "City League",
//     "State Championship",
//     "Pro League"
//   ];
//
//   Future<void> _selectDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now(),
//     );
//
//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//         dobController.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   }
//
//   void submit() {
//     if (_formKey.currentState!.validate()) {
//
//       agent.registerPlayer(
//         nameController.text,
//         widget.phone.isEmpty ? "0000000000" : widget.phone,
//         dobController.text,
//         tournament ?? "",
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Registration Success")),
//       );
//
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text("Registered"),
//           content: Text("Player registered in ${tournament ?? ""}"),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Register")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Name"),
//                 validator: (v) => v!.isEmpty ? "Enter name" : null,
//               ),
//
//               TextFormField(
//                 controller: dobController,
//                 readOnly: true,
//                 onTap: () => _selectDate(context),
//                 decoration: const InputDecoration(labelText: "DOB"),
//               ),
//
//               DropdownButtonFormField(
//                 value: tournament,
//                 items: tournaments.map((e) {
//                   return DropdownMenuItem(
//                     value: e,
//                     child: Text(e),
//                   );
//                 }).toList(),
//                 onChanged: (v) {
//                   setState(() => tournament = v.toString());
//                 },
//                 decoration: const InputDecoration(labelText: "Tournament"),
//               ),
//
//               const SizedBox(height: 20),
//
//               ElevatedButton(
//                 onPressed: submit,
//                 child: const Text("Register"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }