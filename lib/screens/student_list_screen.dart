import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  final List<dynamic> snap;

  final snap2;

  const StudentScreen({
    super.key,
    required this.snap,
    required this.snap2,
  });

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String imagelink =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Event Registrations'),
        actions: [
          IconButton(
            onPressed: () => _showAddCertificateDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: widget.snap.isEmpty
          ? const Center(
              child: Text('No registrations found.'),
            )
          : StreamBuilder(
              stream: _fetchUserData(widget.snap),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (userSnapshot.hasData) {
                  List<Map<String, dynamic>> postsData = userSnapshot.data!;
                  return postsData.isEmpty
                      ? const Center(
                          child:
                              Text('No user data found for the provided IDs.'),
                        )
                      : ListView.builder(
                          itemCount: postsData.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> postData = postsData[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              elevation: 4,
                              child: InkWell(
                                splashColor: Colors.purple,
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                postData['photoUrl'] ??
                                                    imagelink),
                                            radius: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  postData['username'],
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                          },
                        );
                } else {
                  return const Center(
                    child: Text('No data'),
                  );
                }
              },
            ),
    );
  }

  Stream<List<Map<String, dynamic>>> _fetchUserData(List<dynamic> userIds) {
    return FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  void _showAddCertificateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Certificate'),
          content: const Text(
              'Are you sure you want to add a certificate to all users?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                _addCertificateToUsers();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCertificateToUsers() async {
    try {
      for (var userId in widget.snap) {
        var userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data()!;

          // Check if 'certificates' field exists and is a list
          if (userData['certificates'] is List) {
            List certificates = userData['certificates'];

            // Check if the user already has a certificate for the current postId
            bool hasCertificate = certificates.any((certificate) =>
                certificate is Map<String, dynamic> &&
                certificate['postId'] == widget.snap2['postId']);

            if (!hasCertificate) {
              // Add new certificate
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({
                'certificates': FieldValue.arrayUnion([
                  {
                    'event': widget.snap2['title'],
                    'postId': widget.snap2['postId'],
                    'url':
                        'https://example.com/default-certificate.pdf', // Default certificate URL
                    'name': userData['username'],
                    'date': widget.snap2['date'],
                    'clubName': widget.snap2['username'],
                    // Add other fields if needed
                  }
                ]),
              });
            }
          } else {
            // 'certificates' field does not exist or is not a list, create it
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({
              'certificates': FieldValue.arrayUnion([
                {
                  'event': widget.snap2['title'],
                  'postId': widget.snap2['postId'],
                  'url':
                      'https://example.com/default-certificate.pdf', // Default certificate URL
                  'name': userData['username'],
                  'date': widget.snap2['date'],
                  'clubName': widget.snap2['username'],
                  // Add other fields if needed
                }
              ]),
            });
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificates added to all users.')),
      );
    } catch (e) {
      print('Error adding certificates: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding certificates: $e')),
      );
    }
  }
}
