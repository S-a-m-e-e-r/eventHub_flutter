import 'dart:typed_data';
import 'package:eventhub_flutter/models/user2.dart';
import 'package:eventhub_flutter/providers/user_provider2.dart';
import 'package:eventhub_flutter/resources/firestore_methods.dart';
import 'package:eventhub_flutter/utils/colors.dart';
import 'package:eventhub_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _timecontroller = TextEditingController();
  final TextEditingController _locationcontroller = TextEditingController();
  final TextEditingController _feecontroller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isloading = false;
  String imagelink =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png';

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isloading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _titlecontroller.text,
          _datecontroller.text,
          _timecontroller.text,
          _locationcontroller.text,
          _feecontroller.text,
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage);

      if (res == 'success') {
        setState(() {
          _isloading = false;
        });
        showSnackBar('posted', context);
        clearImage();
      } else {
        setState(() {
          _isloading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose From  Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _datecontroller.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _timecontroller.text = pickedTime.format(context);
      });
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void initState() {
    super.initState();
    // Clear controller values when the screen is initialized
    _titlecontroller.text = '';
    _datecontroller.text = '';
    _timecontroller.text = '';
    _locationcontroller.text = '';
    _feecontroller.text = '';
    _descriptionController.text = '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
    _titlecontroller.dispose();
    _datecontroller.dispose();
    _timecontroller.dispose();
    _feecontroller.dispose();
    _locationcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                      user.uid, user.username, user.photoUrl ?? imagelink),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isloading
                      ? const LinearProgressIndicator()
                      : const Padding(
                          padding: EdgeInsets.only(top: 0),
                        ),
                  const Divider(),
                  Container(
                    alignment: Alignment.center,
                    child:
                        //const CircleAvatar(
                        //  backgroundImage: NetworkImage(
                        //      'https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg'),
                        //),

                        SizedBox(
                      height: 250,
                      width: 200,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //------------------------------------------------------
                        //Muzammil you should work on this code
                        //-------------------------------------------
                        TextField(
                          controller: _titlecontroller,
                          decoration: const InputDecoration(
                            hintText: 'Title...',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          onTap: () => _selectDate(context),
                          controller: _datecontroller,
                          decoration: const InputDecoration(
                            hintText: 'Date...',
                            border: UnderlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                            //onPressed: () => _selectDate(context),
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          onTap: () => _selectTime(context),
                          controller: _timecontroller,
                          decoration: const InputDecoration(
                            hintText: 'Time...',
                            border: UnderlineInputBorder(),
                            suffixIcon: Icon(Icons.access_time),
                          ),
                          readOnly: true,
                        ),
                        TextField(
                          controller: _locationcontroller,
                          decoration: const InputDecoration(
                            hintText: 'Location...',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        TextField(
                          controller: _feecontroller,
                          decoration: const InputDecoration(
                            hintText: 'Fee...',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Description...',
                            border: UnderlineInputBorder(),
                          ),
                          maxLines: null,
                          // and this
                          keyboardType: TextInputType.multiline,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
