import 'package:chatapp/components/my_settings_list_title.dart';
import 'package:chatapp/pages/blocked_users_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout(BuildContext context) {
    // get auth service
    final _auth = AuthService();
    _auth.singOut();

    //then navigate to initial route (auth gate/login register page)
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  //confirm user wants to delete account

  Future<void> userWanToDeleteAccount(BuildContext context) async {
    bool confirm = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Confirm Delete"),
                content: const Text(
                    "This will delete your account permanently. Are you sure you want to delete ?"),
                actions: [
                  //cancel button
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),

                  //confirm button
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                ],
              );
            }) ??
        false;

    //if the user confirmed ,
    if (confirm) {
      try {
        Navigator.pop(context);
        await AuthService().deleteAccount();
      } catch (e) {
        //handle any errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            //blocked users
            MySettingsListTitle(
              title: "Blocked Users",
              action: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlockedUsersPage(),
                      )),
                  icon: Icon(Icons.arrow_forward_rounded)),
              color: Colors.grey.shade300,
              txtColor: Colors.black,
            ),

            //delete account
            MySettingsListTitle(
              title: "Delete Account",
              action: IconButton(
                  onPressed: () => userWanToDeleteAccount(context),
                  icon: Icon(Icons.arrow_forward_rounded)),
              color: Color.fromARGB(255, 255, 4, 0),
              txtColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
