import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String date;
  final String time;
  final String location;
  final String fee;
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  final registered;

  const Post({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.fee,
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.registered,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'time': time,
        'location': location,
        'fee': fee,
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
        'registered': registered,
      };

  //converting snap
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        title: snapshot['title'],
        date: snapshot['date'],
        time: snapshot['time'],
        location: snapshot['location'],
        fee: snapshot['fee'],
        description: snapshot['description'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        likes: snapshot['likes'],
        registered: snapshot['registered']);
  }
}
