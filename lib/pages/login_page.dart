import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void Login() async {
    //get instance of auth service
    final _authService = AuthService();

    //try sign in
    try {
      await _authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // login
              SizedBox(
                height: 100,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), // Border radius
                  image: DecorationImage(
                    image: AssetImage(
                        'lib/images/logo/chatapp.webp'), // Your asset image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              const SizedBox(height: 25),
              //email textfield
              MyTextfield(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 25),

              // password textfield
              MyTextfield(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 25),
              //sign in button
              MyButton(
                text: "Log in",
                onTap: Login,
              ),
              const SizedBox(height: 25),

              //register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member ?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
