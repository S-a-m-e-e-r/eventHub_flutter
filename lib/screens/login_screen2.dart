import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub_flutter/resources/auth_method.dart';
import 'package:eventhub_flutter/resources/firestore_methods.dart';
import 'package:eventhub_flutter/responsive/mobile_clubscreen_layout.dart';
import 'package:eventhub_flutter/responsive/mobile_screen_layout2.dart';
import 'package:eventhub_flutter/responsive/responsive_layout_screen.dart';
import 'package:eventhub_flutter/responsive/web_screen_layout.dart';
import 'package:eventhub_flutter/screens/select_screen.dart';
import 'package:eventhub_flutter/utils/colors.dart';
import 'package:eventhub_flutter/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

//--------validations--------------
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
    return null;
  }

//login-------
  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      String res = await AuthMethods().loginUser(
          email: _emailController.text, password: _passwordController.text);

      if (res == "success") {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          // Retrieve user type from Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

          // Check user type
          String userType = userDoc.get('userType');

          if (userType == 'student') {
            try {
              // Check if the document exists before fetching it
              bool userExists = await FirebaseFirestore.instance
                  .collection('registration')
                  .doc(currentUser.uid)
                  .get()
                  .then((doc) => doc.exists);
              if (!userExists) {
                //userDoc = await getDocumentSnapshot(uid);
                String res =
                    await FirestoreMethods().registerPost(currentUser.uid);
              }
            } catch (e) {
              print("Error fetching user document: $e");
            }

            // Navigate to MobileScreenLayout for regular users
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const
                    //ResponsiveLayout(
                    MobileScreenLayout(),
                //webScreenLayout: WebScreenLayout(),
                //),
              ),
            );
          } else if (userType == 'club') {
            // Navigate to AdminScreenLayout for admins
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const //ResponsiveLayout(
                    // mobileScreenLayout:
                    MobileClubScreenLayout(),
                //webScreenLayout: WebScreenLayout(),
                //),
              ),
            );
          }
        }
      } else {
        showSnackBar(res, context);
      }
      setState(() {
        _isloading = false;
      });
    }
  }

  void navigateToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SelectSignupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                _inputField(context),
                _forgotPassword(context),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header Widget
  Widget _header(context) {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  // Input Fields Widget
  Widget _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
          validator: _validateEmail,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
          validator: _validatePassword,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: loginUser,
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
                  "Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
        )
      ],
    );
  }

  // Forgot Password Widget
  Widget _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.purple),
      ),
    );
  }

  // Sign Up Widget
  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: navigateToSignup,
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
    );
  }
}
