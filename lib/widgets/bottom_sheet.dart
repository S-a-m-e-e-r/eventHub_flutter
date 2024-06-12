import 'package:eventhub_flutter/resources/firestore_methods.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet {
  static void showCustomBottomSheet(
      BuildContext context, Map postData, String postId, String uid, userDoc) {
    String message = '';
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // backgroundColor: Colors.transparent,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: 2,
                  width: 80,
                  color: Colors.white, // Color of the line
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Text(
                      '${postData['username']} Presents...',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.cyan),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${postData['title']}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: Colors.purple),
                        ),
                        const Text(
                          'Muffakham Jah College Of Engineering And Technology',
                          style:
                              TextStyle(fontSize: 12, color: Colors.lightGreen),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'About This Event',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: Colors.purple),
                        ),
                        Text(
                          'Date: ${postData['Date']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Time: ${postData['time']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Location: ${postData['location']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 350,
                          child: Text(
                            '${postData['description']}',
                            style: const TextStyle(fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              postData['uid'] != uid
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              //final CollectionReference reg =
                              //FirebaseFirestore.instance
                              //  .collection('registration');

                              try {
                                //Get the document snapshot for the user
                                // Check if the user is registered for this post
                                if ((userDoc.exists &&
                                        userDoc['registered_posts']
                                            .contains(postId)) &&
                                    (postData['registered'].contains(uid))) {
                                  // User is registered, so cancel registration
                                  await FirestoreMethods()
                                      .cancelEventRegistration(
                                    postId,
                                    uid,
                                    userDoc['registered_posts'],
                                    postData['registered'],
                                  );
                                  message =
                                      'You have successfully cancelled your registration.';
                                } else {
                                  // User is not registered, so register for the event
                                  await FirestoreMethods().registerEvent(
                                    postId,
                                    uid,
                                    userDoc['registered_posts'],
                                    postData['registered'],
                                  );
                                  message =
                                      'You have successfully registered for the event.';
                                }
                              } catch (e) {
                                print("Error: $e");
                                // Handle error
                                message = 'An error occurred.';
                              }

                              // Show dialog to display feedback to the user
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Event Registration'),
                                    content: Text(message),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // Close the dialog
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  return userDoc['registered_posts']
                                          .contains(postData['postId'])
                                      ? Colors.red
                                      : Colors.green;
                                },
                              ),
                            ),
                            child: Text(
                              userDoc['registered_posts']
                                      .contains(postData['postId'])
                                  ? 'Cancel Event'
                                  : 'Participate Now',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(),
            ],
          );
        });
  }
}
