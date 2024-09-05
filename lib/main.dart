import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/services/auth/auth_gate.dart';
import 'package:chatapp/services/notifications/notificatin_service.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  //setup firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //setup notification background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  //request notification permission
  final noti = NotificationService();
  await noti.requestPermission();
  noti.setupInteractions();

  //run app
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

//NOTIFICATION BACKGROUND HANDLER
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print("Message data: ${message.data}");
  print("Message notification: ${message.notification?.title}");
  print("Message notification: ${message.notification?.body}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
      },
    );
  }
}
