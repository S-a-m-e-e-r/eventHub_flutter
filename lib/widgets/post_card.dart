import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub_flutter/models/user2.dart';
import 'package:eventhub_flutter/screens/comment_screen.dart';
import 'package:eventhub_flutter/widgets/bottom_sheet.dart';
//import 'package:eventhub_flutter/screens/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventhub_flutter/models/user2.dart' as model;
import 'package:eventhub_flutter/providers/user_provider2.dart';
import 'package:eventhub_flutter/resources/firestore_methods.dart';
//import 'package:eventhub_flutter/screens/comment_screen.dart';
import 'package:eventhub_flutter/utils/colors.dart';
import 'package:eventhub_flutter/utils/global_variables.dart';
import 'package:eventhub_flutter/utils/utils.dart';
import 'package:eventhub_flutter/widgets/like_animation.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  //late DocumentSnapshot userDoc;
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final User user; // Declare user as an instance variable
  int commentLen = 0;

  bool isLikeAnimating = false;
  String imagelink =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png';

  @override
  void initState() {
    super.initState();
    fetchCommentLen();

    // fetchUserDocument(user.uid);
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletPost(postId);
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    // fetchUserDocument(user.uid);

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        children: [
          // extra ----------

          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                              onTap: () {
                                                deletePost(
                                                  widget.snap['postId']
                                                      .toString(),
                                                );
                                                // remove the dialog box
                                                Navigator.of(context).pop();
                                              }),
                                        )
                                        .toList()),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          // const Divider(),
//
          // ////-------------------
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 16,
          //   ).copyWith(right: 0),
          //   child: Row(
          //     children: <Widget>[
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //             left: 8,
          //           ),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: <Widget>[
          //               Text(
          //                 'Date: ${widget.snap['date']}',
          //                 style: TextStyle(fontSize: 14),
          //               ),
          //               Text(
          //                 'Time: ${widget.snap['time']}',
          //                 style: TextStyle(fontSize: 14),
          //               ),
          //               Text(
          //                 'Location: ${widget.snap['location']}',
          //                 style: TextStyle(fontSize: 14),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
//
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              FirestoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //--------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} Likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w800),
                      child: Text(
                        '${widget.snap['registered'].length} Registered',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                ),
              ),
            ],
          ),

          const Divider(),
          // LIKE, COMMENT SECTION OF THE POST
          widget.snap['uid'].toString() != user.uid
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: [
                        LikeAnimation(
                          isAnimating: widget.snap['likes'].contains(user.uid),
                          smallLike: true,
                          child: IconButton(
                            icon: widget.snap['likes'].contains(user.uid)
                                ? const Icon(
                                    Icons.thumb_up,
                                    color: Colors.blue,
                                  )
                                : const Icon(
                                    Icons.thumb_up_alt_outlined,
                                  ),
                            onPressed: () => FirestoreMethods().likePost(
                              widget.snap['postId'].toString(),
                              user.uid,
                              widget.snap['likes'],
                            ),
                          ),
                        ),
                        // Text(
                        //   'Like',
                        //   style: Theme.of(context).textTheme.bodyMedium,
                        // ),
                      ],
                    ),
                    // ElevatedButton(
                    //   child: Text('Register (${'s'})'),
                    //   onPressed: () => Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       //add comment screen
                    //       builder: (context) => const FeedScreen(),
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      child: Text(
                          'Register (${widget.snap['registered'].length})'),
                      onPressed: () async {
                        String message = '';
                        String uid = user.uid;
                        String postId = widget.snap['postId'].toString();
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
                            context, widget.snap, postId, uid, userDoc);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          ),
                        ),
                      ),
                    ),

                    //DefaultTextStyle(
                    //    style: Theme.of(context)
                    //        .textTheme
                    //        .titleSmall!
                    //        .copyWith(fontWeight: FontWeight.w800),
                    //    child: Text(
                    //      '${widget.snap['likes'].length} Likes',
                    //      style: Theme.of(context).textTheme.bodyMedium,
                    //    )),
                  ],
                )
              : Row(
                  children: [
                    ElevatedButton(
                      child: Text('Details'),
                      onPressed: () async {
                        String message = '';
                        String uid = user.uid;
                        String postId = widget.snap['postId'].toString();
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
                            context, widget.snap, postId, uid, userDoc);
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}


 //setState(() {
 //                                       if (widget.snap['registered']
 //                                           .contains(user.uid)) {
 //                                         // User is registered, so cancel registration
 //                                         FirestoreMethods()
 //                                             .cancelEventRegistration(
 //                                           widget.snap['postId'].toString(),
 //                                           user.uid,
 //                                           widget.snap['registered'],
 //                                         );
 //                                         message =
 //                                             'You have successfully cancelled your registration.';
 //                                       } else {
 //                                         // User is not registered, so register for the event
 //                                         FirestoreMethods().registerEvent(
 //                                           widget.snap['postId'].toString(),
 //                                           user.uid,
 //                                           widget.snap['registered'],
 //                                         );
 //                                         message =
 //                                             'You have successfully registered for the event.';
 //                                       }
 //                                     });