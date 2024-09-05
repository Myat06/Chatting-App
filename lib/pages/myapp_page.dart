import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyappPage extends StatefulWidget {
  const MyappPage({super.key});

  @override
  State<MyappPage> createState() => _HomePageState();
}

class _HomePageState extends State<MyappPage> {
  int _selectedIndex = 1;

  // List of pages for navigation
  final List<Widget> _pages = [
    HomePage(),
    ChatPage(),
    Center(child: Text('Calls Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            selectedIndex: 1,
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(16),
            gap: 8,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index; // Update the selected index
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.chat,
                text: 'Chats',
              ),
              GButton(
                icon: Icons.call,
                text: 'Calls',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
