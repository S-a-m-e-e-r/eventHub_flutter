//import 'package:eventhub_flutter/screens/login_screen.dart';
import 'package:eventhub_flutter/screens/login_screen2.dart';
import 'package:flutter/material.dart';

import '../resources/auth_method.dart';

class ProfileSignOut extends StatefulWidget {
  const ProfileSignOut({super.key});

  @override
  State<ProfileSignOut> createState() => _ProfileSignOutState();
}

class _ProfileSignOutState extends State<ProfileSignOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ElevatedButton(
          child: const Center(child: Text('signout')),
          onPressed: () async {
            await AuthMethods().signOutScreen();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
