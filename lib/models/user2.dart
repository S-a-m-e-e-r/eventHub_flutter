import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String usertype;
  final List followers;
  final List following;
  final String? bio;

  final String? photoUrl;

  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.usertype,
    required this.followers,
    required this.following,
    this.bio,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'userType': usertype,
        'followers': followers,
        'following': following,
        'bio': bio,
        'photoUrl': photoUrl,
      };

  //converting snap
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        username: snapshot['username'],
        uid: snapshot['uid'],
        email: snapshot['email'],
        usertype: snapshot['userType'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        bio: snapshot['bio'],
        photoUrl: snapshot['photoUrl']);
  }
}
