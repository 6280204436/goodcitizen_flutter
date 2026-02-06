// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/home_controller.dart';
//
// class TokenDebugScreen extends StatelessWidget {
//   const TokenDebugScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final HomeController controller = Get.find<HomeController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Token Debug Screen'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text(
//               'Auth Token Debug Tools',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//
//             // Debug Token Storage Button
//             ElevatedButton(
//               onPressed: () {
//                 controller.debugTokenStorage();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding: const EdgeInsets.all(16),
//               ),
//               child: const Text(
//                 '🔍 Debug Token Storage',
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Test Native iOS Operations Button
//             ElevatedButton(
//               onPressed: () async {
//                 await controller.testNativeIOSOperations();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.all(16),
//               ),
//               child: const Text(
//                 '🧪 Test Native iOS Operations',
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Manual Token Input
//             const Text(
//               'Manual Token Input (for testing):',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//
//             TextField(
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter your auth token',
//                 hintText: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
//               ),
//               onSubmitted: (String token) async {
//                 if (token.isNotEmpty) {
//                   await controller.manuallySetToken(token);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Token set manually!'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 }
//               },
//             ),
//
//             const SizedBox(height: 16),
//
//             // Set Token Button
//             ElevatedButton(
//               onPressed: () async {
//                 // You can add a text controller here for better UX
//                 const String testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
//                 await controller.manuallySetToken(testToken);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Test token set!'),
//                     backgroundColor: Colors.blue,
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.purple,
//                 padding: const EdgeInsets.all(16),
//               ),
//               child: const Text(
//                 '🔧 Set Test Token',
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             const Text(
//               'Instructions:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               '1. Press "Debug Token Storage" to check current token\n'
//               '2. Press "Test Native iOS Operations" to test socket\n'
//               '3. Enter your actual token in the text field\n'
//               '4. Check console logs for detailed information',
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
