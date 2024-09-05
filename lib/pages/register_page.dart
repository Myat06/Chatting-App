import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void register() async {
    //get auth service
    final _authService = AuthService();

    // check if passwords match -> create user
    if (passwordController.text == confirmpasswordController.text) {
      //try creating user
      try {
        await _authService.signUpWithEmailPassword(emailController.text,
            passwordController.text, nameController.text, phoneController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }

    //if passwords dont match -> show error
    else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Passswords don't match!"),
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
              const SizedBox(
                height: 100,
              ),
              // login
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), // Border radius
                  image: const DecorationImage(
                    image: AssetImage(
                        'lib/images/logo/chatapp.webp'), // Your asset image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // message , app slogan
              Text(
                "Let's an account for you",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              const SizedBox(height: 25),
              // name textfield
              MyTextfield(
                controller: nameController,
                hintText: "Enter your name",
                obscureText: false,
                icon: Icons.person,
              ),
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

              // confirm password textfield
              MyTextfield(
                controller: confirmpasswordController,
                hintText: "Confirm Password",
                obscureText: true,
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 25),
              // phone textfield
              MyTextfield(
                controller: phoneController,
                hintText: "Enter phone no",
                obscureText: false,
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 25),

              //sign up
              //button
              MyButton(
                  text: "Sing up",
                  onTap: () {
                    register();
                  }),
              const SizedBox(height: 25),

              //already have an account login here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "already have an account",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      " login now",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}
