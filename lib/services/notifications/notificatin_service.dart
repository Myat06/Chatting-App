import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  //Request permission: call this in main on start
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User declined or has not accepted permission");
    }
  }

  //SETUP INTERACTIONS
  void setupInteractions() {
    //user received message
    FirebaseMessaging.onMessage.listen((event) {
      print("Got a message whilst in the foreground!");
      print("Message data: ${event.data}");
      _messageStreamController.sink.add(event);
    });

    //user opened message
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Message clicked");
    });
  }

  void dispose() {
    _messageStreamController.close();
  }

  /*
    SETUP TOKEN LISTENERS

    Each device has a token, we will get this token so that we know which device to send a notification to.
  */

  void setupTokenListeners() {
    FirebaseMessaging.instance.getToken().then((token) {
      saveTokenToDatabase(token);
    });

    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  //SAVE DEVICE TOKEN
  void saveTokenToDatabase(String? token) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    //if the current user is logged in & it hase a device token, save it to db
    if (userId != null && token != null) {
      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  /*
  CLEAR DEVICE TOKEN 
  It's important to clear the device token in the case that the user logs out,
  we don't want to be still sending notifications to the device. When any user logs back in,
  the new device token will be saved.
  */

  Future<void> clearTokenOnLogout(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
      print("Token Cleared");
    } catch (e) {
      print("Failed to clear token: $e");
    }
  }
}
