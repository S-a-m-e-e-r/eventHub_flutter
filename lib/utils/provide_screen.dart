import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub_flutter/responsive/mobile_clubscreen_layout.dart';
import 'package:eventhub_flutter/responsive/mobile_screen_layout2.dart';
import 'package:eventhub_flutter/screens/login_screen2.dart';
import 'package:eventhub_flutter/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProvideScreen {
  static Future<Widget> provideScreenType() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Retrieve user type from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        // Check user type
        String userType = userDoc.get('userType');

        if (userType == 'student') {
          return const MobileScreenLayout();
        } else {
          return const MobileClubScreenLayout();
        }
      } catch (e) {
        print('Error retrieving user data: $e');
        // Handle error case by returning a default layout or showing an error message
        return LoginPage(); // Or any other appropriate action
      }
    } else {
      // Handle case where user is not logged in
      return LoginPage(); // Or any other appropriate action
    }
  }
}
