import 'package:chat_app_example/extentions/build_context_extention.dart';
import 'package:chat_app_example/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Chat Room"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  context.navigateToScreen(loginScreen(), isReplace: true);
                }).catchError((e) {});
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Stack(children: [
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to fetch messages'),
                );
              } else if (snapshot.hasData) {
                final messages = snapshot.data!.docs;
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 120,
                  child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(messages[index]['message']),
                          subtitle: Text(messages[index]['senderEmail']),
                        );
                      }),
                );
              } else {
                return const Center(
                  child: Text('No message'),
                );
              }
            }),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 12),
              child: Row(children: [
                SizedBox(
                    width: context.getwidth(percentage: 0.85),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          fillColor: Colors.white, filled: true),
                    )),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    sendMessage();
                  },
                )
              ]),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      final message = {
        'message': messageController.text,
        'sendUid': FirebaseAuth.instance.currentUser!.uid,
        'senderEmail': FirebaseAuth.instance.currentUser!.email,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      FirebaseFirestore.instance
          .collection('messages')
          .add(message)
          .then((value) {
        messageController.clear();
      });
    }
  }

  void getMessaged() {
    FirebaseFirestore.instance
        .collection('messages')
        .snapshots()
        .listen((event) {});
  }
}
