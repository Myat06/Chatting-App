import 'package:chatapp/components/user_title.dart';
import 'package:chatapp/pages/message_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getUsersStreamExcludingBlocked(),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Text("ERROR");
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("LOADINGGG ....");
          }

          //return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //dislay all users except current user
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTitle(
        text: userData['email'],
        onTap: () async {
          //mark all messages in this cart page as read
          await _chatService.markMessagesAsRead(userData["uid"]);
          //tapped on a user -> go to chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagePage(
                  receiverEmail: userData['email'],
                  receiverID: userData["uid"],
                ),
              ));
        },
        unreadMessageCount: userData['unreadCount'],
      );
    } else {
      return Container();
    }
  }
}
