import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub_flutter/resources/firestore_methods.dart';
import 'package:eventhub_flutter/utils/colors.dart';
import 'package:eventhub_flutter/widgets/bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  late List<String> registeredPosts = [];
  String imagelink =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png';

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: Text("My Registrations"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('registration')
            .doc(currentUser!.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic> data = snapshot.data!.data()!;
            List<dynamic> registeredPosts = data['registered_posts'];

            // Fetch post information from 'posts' collection
            return FutureBuilder(
              future: _fetchPostData(registeredPosts),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> postSnapshot) {
                if (postSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (postSnapshot.hasData) {
                  List<Map<String, dynamic>> postsData = postSnapshot.data!;
                  // Display information for each post
                  return ListView.builder(
                      itemCount: postsData.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> postData = postsData[index];
                        // return Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     //Text('Document ID: ${snapshot.data!.id}'),
                        //     Container(
                        //       color: Colors.white,
                        //       child: ListTile(
                        //         title: Text(postData['title']),
                        //         subtitle: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text('Time: ${postData['time']}'),
                        //             Text('Date: ${postData['date']}'),
                        //             Text('Location: ${postData['location']}'),
                        //             // Add more fields as needed
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // );
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 4,
                          child: InkWell(
                            splashColor: Colors.purple,
                            onTap: () async {
                              String uid = currentUser.uid;
                              String postId = postData['postId'].toString();
                              // try {
                              //   // Check if the document exists before fetching it
                              //   bool userExists = await FirebaseFirestore.instance
                              //       .collection('registration')
                              //       .doc(uid)
                              //       .get()
                              //       .then((doc) => doc.exists);
                              //
                              //   if (!userExists) {
                              //     //userDoc = await getDocumentSnapshot(uid);
                              //     String res = await FirestoreMethods().registerPost(uid);
                              //   }
                              // } catch (e) {
                              //   print("Error fetching user document: $e");
                              // }

                              DocumentSnapshot userDoc =
                                  await getDocumentSnapshot(uid);
                              //Map<String, dynamic>? userData =
                              //    userDoc.data() as Map<String, dynamic>?;
                              //if (userData != null &&
                              //    userData.containsKey('registered_posts')) {
                              //  // The field 'registered_posts' exist
                              //} else {
                              //  String res = await FirestoreMethods().registerPost(uid);
                              //  // The field 'registered_posts' does not exist or is null
                              //  // Handle the case where the field is missing or null
                              //}
//
                              //BuildContext? modalContext;

                              // Displaying showModalBottomSheet
                              CustomBottomSheet.showCustomBottomSheet(
                                  context, postData, postId, uid, userDoc);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            postData['profImage'] ?? imagelink),
                                        radius: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              postData['username'],
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  postData['title'] + " |",
                                                  style: const TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Text(
                                                  ' EventHub',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  postData['date'] + " | ",
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  postData['location'],
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const Text('No data');
                }
              },
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchPostData(
      List<dynamic> postIds) async {
    List<Map<String, dynamic>> postsData = [];

    for (var postId in postIds) {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();
      if (postSnapshot.exists) {
        postsData.add(postSnapshot.data() as Map<String, dynamic>);
      }
    }

    return postsData;
  }
}
