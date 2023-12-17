import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_planner/colors.dart';
import 'package:study_planner/firebase_options.dart';
import 'package:study_planner/home_screen.dart';
import 'package:study_planner/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => print(value.options.projectId));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool?> checkIfUserIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter study planner',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      home: FutureBuilder<bool?>(
        future: checkIfUserIsLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data ?? false) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
          return HomeScreen();
        },
      ),
    );
  }
}
