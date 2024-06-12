import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String email;
  final List<dynamic> followers;
  final List<dynamic> following;
  final String uid;
  final String userType;
  final String username;
  final String profileImageUrl; // Assuming you have a profile image URL

  ProfileScreen({
    required this.email,
    required this.followers,
    required this.following,
    required this.uid,
    required this.userType,
    required this.username,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 120, // Adjust the height according to your design
          width: 120, // Adjust the width according to your design
          child: CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl),
            radius: 60,
          ),
        ),
        SizedBox(height: 20),
        Text(
          username,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          email,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'User Type: $userType',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Followers: ${followers.length}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Following: ${following.length}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
