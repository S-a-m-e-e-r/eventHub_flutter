import 'package:eventhub_flutter/widgets/post_card.dart';
import 'package:flutter/material.dart';

class SeePostScreen extends StatefulWidget {
  final snap;
  const SeePostScreen({super.key, required this.snap});

  @override
  State<SeePostScreen> createState() => _SeePostScreenState();
}

class _SeePostScreenState extends State<SeePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Post'),
      ),
      body: SingleChildScrollView(
        child: PostCard(
          snap: widget.snap,
        ),
      ),
    );
  }
}
