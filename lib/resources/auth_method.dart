import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventhub_flutter/models/user2.dart' as model;
import 'package:uuid/uuid.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //getting user details from firebase

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //signup studentdetails
  Future<String> studentDetails({
    String? uuid,
    required String uid,
    required String rollno,
    required String college,
    required int phone,
    required String branch,
  }) async {
    String res1 = "Some err occured";
    try {
      if (rollno.isNotEmpty || college.isNotEmpty) {
        String detId = uuid ?? const Uuid().v1();
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('studentDetails')
            .doc(detId)
            .set(
          {
            //'profilePic': profilePic,
            'uid': uid,
            'roll no': rollno,
            'college': college,
            'phone': phone,
            'branch': branch,
          },
        );
        res1 = "success";
      } else {
        print('Text is empty');
      }
    } catch (err) {
      print(err.toString());
    }
    return res1;
  }

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String usertype,
  }) async {
    String res = "Some err occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          usertype.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        //String photoUrl = await StorageMethods()
        //  .uploadImageToStorage('profilePics', false);

        //add user to db
        // model
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          usertype: usertype,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = "success";
      } else //if (file == null)
      {
        print("file error");
      }
    } //remove it later
    on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'This email is badly formatted.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  } //signup

  //login
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signOutScreen() async {
    await _auth.signOut();
  }
}
