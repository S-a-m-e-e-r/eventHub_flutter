import 'package:cloud_firestore/cloud_firestore.dart';

class Register {
  final uid;
  final registered_posts;
  Register({
    required this.uid,
    required this.registered_posts,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'registered_posts': registered_posts,
      };

  static Register fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Register(
        uid: snapshot['uid'], registered_posts: snapshot['registered_posts']);
  }
}
