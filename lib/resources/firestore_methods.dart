import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub_flutter/models/certificates.dart';
import 'package:eventhub_flutter/models/post2.dart';
import 'package:eventhub_flutter/models/register.dart';
import 'package:eventhub_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload
  Future<String> uploadPost(
      String title,
      String date,
      String time,
      String location,
      String fee,
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage) async {
    String res = 'Some err occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      Post post = Post(
        title: title,
        date: date,
        time: time,
        location: location,
        fee: fee,
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        registered: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  //update details
  Future<String> updateUserDetails(
    String uid,
    String username,
    String bio,
    Uint8List file,
  ) async {
    String res = 'Some err occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('profiles', file, false);
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'username': username, 'bio': bio, 'photoUrl': photoUrl});
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //upload
  Future<String> registerPost(
    String uid,
  ) async {
    String res = 'Some err occurred';
    try {
      Register post = Register(
        uid: uid,
        registered_posts: [],
      );

      _firestore.collection('registration').doc(uid).set(
            post.toJson(),
          );
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //Future<String> registerPost(String uid) async {
  //  String res = 'some error';
  //  try {
  //    Register reg = Register(uid: uid, postId: []);
  //    _firestore.collection('registration').doc(uid).set(req.toJson());
  //  } catch (e) {
  //    res = e.toString();
  //  }
  //}

  //register event
  Future<void> registerEvent(
      String postId, String uid, List registered, List registered2) async {
    try {
      // Check if the user is already registered for the event
      if (!registered.contains(postId)) {
        await _firestore.collection('registration').doc(uid).set(
          {
            'registered_posts': FieldValue.arrayUnion([postId]),
          },
          SetOptions(merge: true),
        );
      }
      if (!registered2.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'registered': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  Future<void> cancelEventRegistration(
      String postId, String uid, List registered, List registered2) async {
    try {
      // Check if the user is registered for the event before attempting to cancel
      if (registered.contains(postId)) {
        await _firestore.collection('registration').doc(uid).update({
          'registered_posts': FieldValue.arrayRemove([postId]),
        });
      }
      if (registered2.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'registered': FieldValue.arrayRemove([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'profilePic': profilePic,
            'name': name,
            'uid': uid,
            'text': text,
            'commentId': commentId,
            'datePublished': DateTime.now(),
          },
        );
      } else {
        print('Text is empty');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  //delete posts
  Future<void> deletPost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}

Future<DocumentSnapshot> getDocumentSnapshot(String documentId) async {
  try {
    // Get the document snapshot from Firestore
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('registration')
        .doc(documentId)
        .get();

    return documentSnapshot;
  } catch (e) {
    print("Error getting document snapshot: $e");
    // Handle error
    throw e;
  }
}

Stream<List<Certificate>> fetchCertificates(String uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map((snapshot) {
    final List<Certificate> certificates = [];
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = snapshot.docs.first;
      if (userDoc.data() != null && userDoc['certificates'] != null) {
        for (var certData in userDoc['certificates']) {
          certificates
              .add(Certificate.fromMap(certData as Map<String, dynamic>));
        }
      }
    }
    return certificates;
  });
}
