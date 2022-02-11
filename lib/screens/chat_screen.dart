import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yummy_chat/chatting/message.dart';
import 'package:yummy_chat/chatting/new_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat screen'),
        actions: [
          IconButton(
            onPressed: () {
              _authentication.signOut();
              // Navigator.pop(context);
            },
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('chats/aC24TUr8spnIh4PuvjRi/message')
      //       .snapshots(),
      //   builder: (BuildContext context,
      //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //     if(snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     final docs = snapshot.data!.docs;
      //     return ListView.builder(
      //         itemCount: docs.length,
      //         itemBuilder:(context, index) {
      //           return Container(
      //             padding: EdgeInsets.all(8),
      //             child: Text(docs[index]['text']),
      //           );
      //         },
      //     );
      //   },
      // ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
