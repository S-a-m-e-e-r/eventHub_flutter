import 'package:eventhub_flutter/screens/club_signup_screen.dart';
import 'package:eventhub_flutter/screens/login_screen2.dart';
import 'package:eventhub_flutter/screens/user_signup_screen.dart';
import 'package:flutter/material.dart';

enum UserRole { student, club }

class SelectSignupPage extends StatefulWidget {
  const SelectSignupPage({super.key});

  @override
  State<SelectSignupPage> createState() => _SelectSignupPageState();
}

class _SelectSignupPageState extends State<SelectSignupPage> {
  UserRole _selectedRole = UserRole.student;
  String roleselected = 'student';

  void _signUp() {
    // Implement authentication logic based on selected role
    // You will send data like _emailController.text, _passwordController.text, _selectedRole, etc.
    // to your backend (Django, Firebase, etc.) for registration.
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void navigateToClub() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClubSignupPage(
          selectedRole: branchToString(_selectedRole),
        ),
      ),
    );
  }

  String branchToString(UserRole branch) {
    return branch
        .toString()
        .split('.')
        .last; // Extracting and converting to uppercase
  }

  void navigateToStudent() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserSignupPage(
          selectedRole: branchToString(_selectedRole),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
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
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    DropdownButtonFormField<UserRole>(
                      decoration: InputDecoration(
                          hintText: "Select..",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                      value: _selectedRole,
                      onChanged: (UserRole? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        }
                      },
                      items: UserRole.values
                          .map<DropdownMenuItem<UserRole>>((UserRole role) {
                        return DropdownMenuItem<UserRole>(
                          value: role,
                          child: Text(
                              role == UserRole.student ? 'Student' : 'Club'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(
                      top: 3,
                    ),
                    child: ElevatedButton(
                      onPressed: _selectedRole == UserRole.student
                          ? navigateToStudent
                          : navigateToClub,
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.purple,
                      ),
                      child: Text(
                        _selectedRole == UserRole.student
                            ? 'Student Sign Up'
                            : 'Club Sign Up',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
                const Center(child: Text("Or")),
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
    );
  }
}
