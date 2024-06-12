import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub_flutter/screens/student_list_screen.dart';
import 'package:eventhub_flutter/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DisplayRegistrations extends StatefulWidget {
  const DisplayRegistrations({super.key});

  @override
  State<DisplayRegistrations> createState() => _DisplayRegistrationsState();
}

class _DisplayRegistrationsState extends State<DisplayRegistrations> {
  User? user = FirebaseAuth.instance.currentUser;
  String imagelink =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png';

  // List<dynamic> registeredPosts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: Text('Event Registrations'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // if (snapshot.hasData) {
          //   registeredPosts.clear();
          //   for (var doc in snapshot.data!.docs) {
          //     var data = doc.data();
          //     if (data.containsKey('registered')) {
          //       registeredPosts.addAll(data['registered']);
          //     }
          //   }
          // }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // registeredPosts.clear();
                List<dynamic> registeredPosts = [];
                registeredPosts
                    .addAll(snapshot.data!.docs[index].data()['registered']);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                snapshot.data!.docs[index].data()['postUrl'] ??
                                    imagelink,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 50,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(
                              snapshot.data!.docs[index].data()['title'],
                              style: const TextStyle(fontSize: 20),
                            )),
                            IconButton(
                                icon:
                                    const Icon(Icons.arrow_forward_ios_rounded),
                                onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            //ResponsiveLayout(
                                            // mobileScreenLayout:
                                            StudentScreen(
                                          snap: registeredPosts,
                                          snap2:
                                              snapshot.data!.docs[index].data(),
                                        ),
                                        //webScreenLayout: WebScreenLayout(),
                                        //),
                                      ),
                                    ))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
