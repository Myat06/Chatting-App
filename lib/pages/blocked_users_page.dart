import 'package:chatapp/components/user_title.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  //chat & auth service
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  //show confirm unblock box

  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Unblock User"),
              content: const Text("Are you sure you want to unblock this user"),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),

                //unblock button
                TextButton(
                    onPressed: () {
                      chatService.unblockUser(userId);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User unblocked!")));
                    },
                    child: const Text("UNblock"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //get current users id
    String userId = authService.getCurrentUser()!.uid;

    //UI

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOCKED USERS'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("ERROR loading...."),
            );
          }

          //loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blockedUsers = snapshot.data ?? [];

          //no users
          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text("No blocked users"),
            );
          }
          // load complete

          return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return UserTitle(
                    text: user["email"],
                    onTap: () => _showUnblockBox(context, user['uid']));
              });
        },
      ),
    );
  }
}
