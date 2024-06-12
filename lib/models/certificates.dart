import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate {
  final String date;
  final String event;
  final String name;
  final String postId;
  final String url;
  final String clubName;

  Certificate({
    required this.date,
    required this.event,
    required this.name,
    required this.postId,
    required this.url,
    required this.clubName,
  });

  factory Certificate.fromMap(Map<String, dynamic> data) {
    return Certificate(
      date: data['date'],
      event: data['event'],
      name: data['name'],
      postId: data['postId'],
      url: data['url'],
      clubName: data['clubName'],
    );
  }
}
