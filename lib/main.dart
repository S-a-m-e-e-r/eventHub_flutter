import 'package:eventhub_flutter/providers/user_provider2.dart';
//import 'package:eventhub_flutter/responsive/mobile_screen_layout.dart';
//import 'package:eventhub_flutter/responsive/mobile_screen_layout2.dart';
import 'package:eventhub_flutter/responsive/responsive_layout_screen.dart';
import 'package:eventhub_flutter/responsive/web_screen_layout.dart';
//import 'package:eventhub_flutter/screens/login_screen.dart';
import 'package:eventhub_flutter/screens/login_screen2.dart';
//import 'package:eventhub_flutter/screens/signup_screen.dart';
import 'package:eventhub_flutter/utils/colors.dart';
import 'package:eventhub_flutter/utils/provide_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCSTGhU2UnbrLDIu7-imPS9yI1IboB7G1w",
              appId: "1:418008245290:web:bac476d928c03aa91d0f53",
              messagingSenderId: "418008245290",
              projectId: "eventhub-27aac",
              storageBucket: "eventhub-27aac.appspot.com",
              authDomain: "eventhub-27aac.firebaseapp.com"));
    } else {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyClwMu1YW84g7Ds7oGch4nTWiBJdNmTqMI",
              appId: "1:418008245290:android:7559bd422ca831e81d0f53",
              messagingSenderId: '418008245290',
              projectId: "eventhub-27aac",
              storageBucket: 'eventhub-27aac.appspot.com'));
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event_Hub',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //home:
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return FutureBuilder(
                  future: ProvideScreen.provideScreenType(),
                  builder: (context, AsyncSnapshot<Widget> screenSnapshot) {
                    if (screenSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    } else if (screenSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${screenSnapshot.error}'),
                      );
                    } else {
                      return ResponsiveLayout(
                        mobileScreenLayout: screenSnapshot.data!,
                        webScreenLayout: const WebScreenLayout(),
                      );
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
