// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'detail_screen.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final phoneController = TextEditingController();
//   final otpController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   bool _isLoading = false;
//   bool _otpSent = false;
//   bool _isResending = false;
//   int _timerSeconds = 30;
//   String _generatedOTP = '';
//   String _displayOTP = '';
//
//   @override
//   void dispose() {
//     phoneController.dispose();
//     otpController.dispose();
//     super.dispose();
//   }
//
//   String? validatePhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your phone number';
//     }
//
//     String cleanedNumber = value.replaceAll(RegExp(r'\D'), '');
//
//     if (cleanedNumber.length != 10) {
//       return 'Please enter a valid 10-digit mobile number';
//     }
//
//     if (!RegExp(r'^[6-9]').hasMatch(cleanedNumber[0])) {
//       return 'Mobile number must start with 6, 7, 8, or 9';
//     }
//
//     return null;
//   }
//
//   String? validateOTP(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter OTP';
//     }
//
//     if (value.length != 6) {
//       return 'OTP must be 6 digits';
//     }
//
//     if (!RegExp(r'^\d+$').hasMatch(value)) {
//       return 'Enter valid numeric OTP';
//     }
//
//     return null;
//   }
//
//   Future<void> sendOTP() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       // Generate a random 6-digit OTP
//       _generatedOTP = (100000 + (Random().nextInt(900000))).toString();
//       _displayOTP = _generatedOTP;
//
//       // Simulate API call delay
//       await Future.delayed(const Duration(seconds: 2));
//
//       setState(() {
//         _isLoading = false;
//         _otpSent = true;
//         _timerSeconds = 30;
//         _startTimer();
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.white, size: 20),
//               const SizedBox(width: 10),
//               Text('OTP sent to ${phoneController.text.trim()}'),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }
//
//   void _startTimer() {
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted && _timerSeconds > 0) {
//         setState(() {
//           _timerSeconds--;
//           _startTimer();
//         });
//       }
//     });
//   }
//
//   Future<void> resendOTP() async {
//     if (_timerSeconds == 0) {
//       setState(() {
//         _isResending = true;
//       });
//
//       // Generate new OTP
//       _generatedOTP = (100000 + (Random().nextInt(900000))).toString();
//       _displayOTP = _generatedOTP;
//
//       await Future.delayed(const Duration(seconds: 1));
//
//       setState(() {
//         _isResending = false;
//         _timerSeconds = 30;
//         _startTimer();
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('OTP resent successfully'),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
//
//   void verifyOTP() {
//     // Clear any previous errors
//     FocusScope.of(context).unfocus();
//
//     if (otpController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.error, color: Colors.white),
//               SizedBox(width: 10),
//               Text('Please enter OTP'),
//             ],
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }
//
//     if (otpController.text.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.error, color: Colors.white),
//               SizedBox(width: 10),
//               Text('OTP must be 6 digits'),
//             ],
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }
//
//     if (otpController.text == _generatedOTP) {
//       // OTP verified successfully
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.verified_user, color: Colors.white),
//               SizedBox(width: 10),
//               Text('OTP Verified Successfully!'),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           duration: Duration(seconds: 1),
//         ),
//       );
//
//       // Navigate to DetailsPage
//       Future.delayed(const Duration(milliseconds: 500), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => DetailsPage(phone: phoneController.text.trim())),
//         );
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.error, color: Colors.white),
//               SizedBox(width: 10),
//               Text('Invalid OTP! Please try again.'),
//             ],
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       // Clear OTP field for retry
//       otpController.clear();
//     }
//   }
//
//   void resetLogin() {
//     setState(() {
//       _otpSent = false;
//       otpController.clear();
//       _generatedOTP = '';
//       _displayOTP = '';
//       _timerSeconds = 30;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(), // Enables scrolling always
//           child: Container(
//             constraints: BoxConstraints(
//               minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
//             ),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.blue.shade50, Colors.white, Colors.blue.shade50],
//               ),
//             ),
//             child: Column(
//               children: [
//                 // Header section
//                 Container(
//                   padding: const EdgeInsets.only(top: 40, bottom: 20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.blue.shade400, Colors.blue.shade700],
//                           ),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(color: Colors.blue.shade200, blurRadius: 20, spreadRadius: 5),
//                           ],
//                         ),
//                         child: const Icon(Icons.sports_soccer, size: 70, color: Colors.white),
//                       ),
//                       const SizedBox(height: 24),
//                       Text(
//                         "Toto Sports",
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue.shade800,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         _otpSent ? "Verify OTP" : "Login to continue",
//                         style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Login/OTP form section
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Card(
//                     elevation: 15,
//                     shadowColor: Colors.blue.shade200,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             if (!_otpSent) ...[
//                               // Phone number input
//                               const SizedBox(height: 20),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(color: Colors.grey.shade300, width: 1),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 16,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade100,
//                                         borderRadius: const BorderRadius.only(
//                                           topLeft: Radius.circular(16),
//                                           bottomLeft: Radius.circular(16),
//                                         ),
//                                       ),
//                                       child: const Row(
//                                         children: [
//                                           Icon(Icons.flag, size: 20, color: Colors.blue),
//                                           SizedBox(width: 4),
//                                           Text(
//                                             "+91",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: TextFormField(
//                                         controller: phoneController,
//                                         keyboardType: TextInputType.phone,
//                                         validator: validatePhone,
//                                         maxLength: 10,
//                                         enabled: !_isLoading,
//                                         decoration: const InputDecoration(
//                                           hintText: "98765 43210",
//                                           labelText: "Mobile Number",
//                                           border: InputBorder.none,
//                                           contentPadding: EdgeInsets.symmetric(
//                                             horizontal: 16,
//                                             vertical: 16,
//                                           ),
//                                           counterText: "",
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               const SizedBox(height: 32),
//
//                               // Send OTP button
//                               AnimatedContainer(
//                                 duration: const Duration(milliseconds: 300),
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: _isLoading ? null : sendOTP,
//                                   style: ElevatedButton.styleFrom(
//                                     padding: const EdgeInsets.symmetric(vertical: 16),
//                                     backgroundColor: Colors.blue.shade700,
//                                     foregroundColor: Colors.white,
//                                     elevation: 5,
//                                     shadowColor: Colors.blue.shade400,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     disabledBackgroundColor: Colors.grey.shade400,
//                                   ),
//                                   child: _isLoading
//                                       ? const SizedBox(
//                                           height: 24,
//                                           width: 24,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                           ),
//                                         )
//                                       : Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: const [
//                                             Icon(Icons.send, size: 20),
//                                             SizedBox(width: 12),
//                                             Text(
//                                               "Send OTP",
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                 ),
//                               ),
//
//                               const SizedBox(height: 24),
//
//                               // Divider
//                               Row(
//                                 children: [
//                                   Expanded(child: Divider(color: Colors.grey.shade300)),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                                     child: Text(
//                                       "New User?",
//                                       style: TextStyle(color: Colors.grey.shade500),
//                                     ),
//                                   ),
//                                   Expanded(child: Divider(color: Colors.grey.shade300)),
//                                 ],
//                               ),
//
//                               const SizedBox(height: 20),
//
//                               // Register button
//                               OutlinedButton(
//                                 onPressed: () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text("Registration coming soon!"),
//                                       duration: Duration(seconds: 2),
//                                     ),
//                                   );
//                                 },
//                                 style: OutlinedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(vertical: 14),
//                                   side: BorderSide(color: Colors.blue.shade300, width: 2),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.person_add, color: Colors.blue.shade700),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       "Create New Account",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.blue.shade700,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ] else ...[
//                               // OTP Display Section
//                               Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [Colors.orange.shade50, Colors.orange.shade100],
//                                   ),
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(color: Colors.orange.shade300, width: 2),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.orange.shade200,
//                                       blurRadius: 10,
//                                       spreadRadius: 2,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.security, color: Colors.orange, size: 24),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           'Your OTP',
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.orange,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 12),
//                                     Container(
//                                       padding: const EdgeInsets.all(16),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(12),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.shade300,
//                                             blurRadius: 5,
//                                             offset: const Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Center(
//                                         child: SelectableText(
//                                           _displayOTP,
//                                           style: TextStyle(
//                                             fontSize: 32,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.blue.shade700,
//                                             letterSpacing: 8,
//                                             fontFamily: 'monospace',
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     const Text(
//                                       'This OTP is valid for 30 seconds',
//                                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         const Icon(
//                                           Icons.info_outline,
//                                           size: 14,
//                                           color: Colors.grey,
//                                         ),
//                                         const SizedBox(width: 4),
//                                         const Text(
//                                           'In production, OTP will be sent via SMS',
//                                           style: TextStyle(fontSize: 10, color: Colors.grey),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               const SizedBox(height: 20),
//
//                               // Phone number display with edit option
//                               Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.shade50,
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(color: Colors.blue.shade200),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Icon(Icons.phone_android, color: Colors.blue, size: 20),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       phoneController.text.trim(),
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     GestureDetector(
//                                       onTap: resetLogin,
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey.shade300,
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         child: const Text('Change', style: TextStyle(fontSize: 12)),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               const SizedBox(height: 20),
//
//                               // OTP input field
//                               TextFormField(
//                                 controller: otpController,
//                                 validator: validateOTP,
//                                 keyboardType: TextInputType.number,
//                                 maxLength: 6,
//                                 textAlign: TextAlign.center,
//                                 autofocus: true,
//                                 style: const TextStyle(
//                                   fontSize: 24,
//                                   letterSpacing: 8,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 decoration: InputDecoration(
//                                   labelText: "Enter OTP",
//                                   hintText: "000000",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   prefixIcon: const Icon(Icons.security),
//                                   counterText: "",
//                                   contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                                 ),
//                               ),
//
//                               const SizedBox(height: 16),
//
//                               // Resend OTP with timer
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Didn't receive OTP? ",
//                                     style: TextStyle(color: Colors.grey.shade600),
//                                   ),
//                                   GestureDetector(
//                                     onTap: _timerSeconds == 0 ? resendOTP : null,
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: _timerSeconds == 0
//                                             ? Colors.blue.shade100
//                                             : Colors.transparent,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Text(
//                                         _timerSeconds > 0
//                                             ? "Resend in ${_timerSeconds}s"
//                                             : "Resend OTP",
//                                         style: TextStyle(
//                                           color: _timerSeconds == 0
//                                               ? Colors.blue.shade700
//                                               : Colors.grey.shade400,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   if (_isResending)
//                                     const Padding(
//                                       padding: EdgeInsets.only(left: 8),
//                                       child: SizedBox(
//                                         height: 16,
//                                         width: 16,
//                                         child: CircularProgressIndicator(strokeWidth: 2),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//
//                               const SizedBox(height: 24),
//
//                               // Verify OTP Button - Fixed with proper Row layout
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: OutlinedButton(
//                                       onPressed: resetLogin,
//                                       style: OutlinedButton.styleFrom(
//                                         padding: const EdgeInsets.symmetric(vertical: 14),
//                                         side: BorderSide(color: Colors.grey.shade400),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                       ),
//                                       child: const Text('Back'),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     flex: 2,
//                                     child: ElevatedButton(
//                                       onPressed: verifyOTP,
//                                       style: ElevatedButton.styleFrom(
//                                         padding: const EdgeInsets.symmetric(vertical: 14),
//                                         backgroundColor: Colors.green,
//                                         foregroundColor: Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         elevation: 3,
//                                       ),
//                                       child: const Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Icon(Icons.verified, size: 20),
//                                           SizedBox(width: 8),
//                                           Text('Verify & Login'),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//
//                             const SizedBox(height: 16),
//
//                             // Terms & conditions
//                             Text(
//                               "By continuing, you agree to our Terms & Conditions",
//                               style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
//                               textAlign: TextAlign.center,
//                             ),
//
//                             const SizedBox(height: 20), // Extra bottom padding for scroll
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
