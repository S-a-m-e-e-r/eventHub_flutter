import 'package:eventhub_flutter/resources/auth_method.dart';
import 'package:eventhub_flutter/responsive/mobile_screen_layout2.dart';
import 'package:eventhub_flutter/responsive/responsive_layout_screen.dart';
import 'package:eventhub_flutter/responsive/web_screen_layout.dart';
import 'package:eventhub_flutter/screens/login_screen2.dart';
import 'package:eventhub_flutter/utils/colors.dart';
import 'package:eventhub_flutter/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Branch { DEFAULT, CSE, CIVIL, MEC, IT, AIDS, CSM }

class UserSignupPage extends StatefulWidget {
  final String selectedRole;
  const UserSignupPage({super.key, required this.selectedRole});

  @override
  State<UserSignupPage> createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rollnoController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  Branch _selectedBranch = Branch.DEFAULT;
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rollnoController.dispose();
    _collegeController.dispose();
    _phoneController.dispose();
    _password2Controller.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateRollNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your roll number';
    }
    final RegExp rollNoRegex = RegExp(r'^\d{4}-\d{2}-\d{3}-\d{3}$');
    if (!rollNoRegex.hasMatch(value)) {
      return 'Please enter a valid roll number format (e.g., 1604-20-733-309)';
    }
    return null;
  }

  String? _validateCollege(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your college name';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  void studentDetails(String uid) async {
    String res1 = await AuthMethods().studentDetails(
      uid: uid,
      rollno: _rollnoController.text,
      college: _collegeController.text,
      phone: int.parse(_phoneController.text),
      branch: _selectedBranch.toString(),
    );
    if (res1 == "success") {
      showSnackBar(res1, context);
    } else {
      showSnackBar(res1, context);
    }
  }

  void signUpUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      String res = await AuthMethods().signUpUser(
        usertype: widget.selectedRole,
        email: _emailController.text,
        password: _passwordController.text,
        username: _nameController.text,
      );
      String uid = FirebaseAuth.instance.currentUser!.uid;
      print("uid:$uid");
      studentDetails(uid);
      setState(() {
        _isloading = false;
      });

      if (res == 'success') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      } else {
        showSnackBar(res, context);
      }
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  String branchToString(Branch branch) {
    return branch
        .toString()
        .split('.')
        .last
        .toUpperCase(); // Extracting and converting to uppercase
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 60.0),
                        const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create your account",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              hintText: "Full Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.person)),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _rollnoController,
                          decoration: InputDecoration(
                              hintText: "Roll Number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.person)),
                          validator: _validateRollNo,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<Branch>(
                          decoration: InputDecoration(
                              hintText: "Select..",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.school)),
                          value: _selectedBranch,
                          onChanged: (Branch? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedBranch = newValue;
                              });
                            }
                          },
                          items: Branch.values
                              .map<DropdownMenuItem<Branch>>((Branch role) {
                            return DropdownMenuItem<Branch>(
                              value: role,
                              child: Text(branchToString(role)),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _collegeController,
                          decoration: InputDecoration(
                              hintText: "College Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.account_balance)),
                          validator: _validateCollege,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          autofillHints: const [
                            AutofillHints.telephoneNumber,
                          ],
                          decoration: InputDecoration(
                              hintText: "Phone No",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.phone)),
                          validator: _validatePhone,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.purple.withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.email)),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.purple.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          validator: _validatePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _password2Controller,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.purple.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          validator: _validateConfirmPassword,
                          obscureText: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Signup button
                    Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        child: ElevatedButton(
                          onPressed: signUpUser,
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.purple,
                          ),
                          child: _isloading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : const Text(
                                  "Sign up",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                        )),

                    const SizedBox(height: 20),
                    const Center(child: Text("Or")),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: navigateToLogin,
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.purple),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
