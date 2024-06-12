import 'package:eventhub_flutter/screens/add_post_screen.dart';
import 'package:eventhub_flutter/screens/display_registrations_screen.dart';
import 'package:eventhub_flutter/screens/feed_screen.dart';
import 'package:eventhub_flutter/screens/my_certificates_screen.dart';
import 'package:eventhub_flutter/screens/profile_screen.dart';
import 'package:eventhub_flutter/screens/search_screen.dart';
//import 'package:eventhub_flutter/screens/profile_screen.dart';
//import 'package:eventhub_flutter/screens/search_screen.dart';
//import 'package:eventhub_flutter/screens/signout_screen.dart';
import 'package:eventhub_flutter/screens/user_events_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import '../screens/profile.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const DisplayRegistrations(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

List<Widget> userhomeScreenItems = [
  const FeedScreen(),
  const MyEvents(),
  //ProfileScreen(
  //  email: 's@gmail.com',
  //  uid: 'dsdsd',
  //  userType: 'student',
  //  username: 'sameer',
  //  profileImageUrl: 'sadsadsadsa',
  //  followers: [12],
  //  following: [13],
  //),
  const MyCertificatesScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
