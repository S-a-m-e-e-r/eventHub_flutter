import 'dart:typed_data';

import 'package:eventhub_flutter/resources/auth_method.dart';
import 'package:eventhub_flutter/resources/firestore_methods.dart';
import 'package:eventhub_flutter/utils/colors.dart';
import 'package:eventhub_flutter/utils/utils.dart';
import 'package:eventhub_flutter/widgets/textfield_validators.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final data1;
  final data2;
  final String docId;
  const EditProfile(
      {super.key,
      required this.data1,
      required this.data2,
      required this.docId});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _branchController = TextEditingController();
  late TextEditingController _rollNoController = TextEditingController();
  late TextEditingController _bioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? _image;
  bool _isloading = false;
  String imagelink =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/2048px-Windows_10_Default_Profile_Picture.svg.png';

  bool isObscurePassword = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController(text: widget.data1['username']);
    _phoneController = TextEditingController(
        text: widget.data2['phone'].toString() ?? '7569498241');
    _branchController =
        TextEditingController(text: widget.data2['branch'] ?? 'Branch');
    _rollNoController = TextEditingController(
        text: widget.data2['roll no'] ?? '1604-20-733-309');
    _bioController = TextEditingController(text: widget.data1['bio'] ?? 'bio');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _branchController.dispose();
    _rollNoController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Edit profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              widget.data1['photoUrl'] ?? imagelink,
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField(
                "Username",
                // widget.data1['username'],
                _usernameController,
                Validators().validateName,
              ),
              if (widget.data1['userType'] != 'club')
                buildTextField(
                  "Phone",
                  //"1234567",
                  _phoneController,
                  Validators().validatePhone,
                ),
              if (widget.data1['userType'] != 'club')
                buildTextField(
                  "Branch",
                  //"*sdw",
                  _branchController,
                  Validators().validateName,
                ),
              if (widget.data1['userType'] != 'club')
                buildTextField(
                  "Roll no",
                  // "patencheru",
                  _rollNoController,
                  Validators().validateRollNo,
                ),
              buildTextField('Bio', _bioController, null),
              SizedBox(height: 30),
              InkWell(
                onTap: _saveProfile,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Colors.purple),
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    //String placeholder,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          //hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      // Perform save operation if form is valid
      // You can access the values using _usernameController.text, _phoneController.text, etc.
      String res = 'Some err occure beginning..';
      try {
        if (widget.data1['userType'] == 'club') {
          res = await FirestoreMethods().updateUserDetails(
            widget.data1['uid'],
            _usernameController.text,
            _bioController.text,
            _image!,
          );
        } else {
          String res1 = await FirestoreMethods().updateUserDetails(
            widget.data1['uid'],
            _usernameController.text,
            _bioController.text,
            _image!,
          );
          if (res1 == "success") {
            showSnackBar(res1, context);
          }
          res = await AuthMethods().studentDetails(
            uuid: widget.docId,
            uid: widget.data1['uid'],
            rollno: _rollNoController.text,
            college: "mjcet",
            phone: int.parse(_phoneController.text),
            branch: _branchController.text,
          );
        }

        if (res == "success") {
          setState(() {
            _isloading = false;
          });
          showSnackBar(res, context);
        } else {
          setState(() {
            _isloading = false;
          });
        }
      } catch (e) {
        showSnackBar(res, context);
        setState(() {
          _isloading = false;
        });
      }
    }
  }
}
