import 'package:chat_app_example/screens/chat_screen.dart';
import 'package:chat_app_example/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async
{
 WidgetsFlutterBinding.ensureInitialized();

// ...

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp( ChatApp());
}
class ChatApp extends StatelessWidget {
   ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null ? ChatScreen():loginScreen(),
    );
  }
}