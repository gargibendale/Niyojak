import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_planner/login.dart';
import 'package:study_planner/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  signOutUser() async {
    await FirebaseAuth.instance.signOut().then((value) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    });
  }

  Future<UserModel> getUserDetails() async {
    //CollectionReference users = FirebaseFirestore.instance.collection("users");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString("userID") ?? "";
    var userResponse =
        await FirebaseFirestore.instance.collection("users").doc(userID).get();
    UserModel userModel = UserModel.fromDocumentSnapshot(userResponse);
    print(userModel.firstName);
    print(userModel.lastName);
    return userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: kIsWeb ? false : true,
          title: Text("Profile"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            signOutUser();
          },
          child: Icon(Icons.logout_sharp),
        ),
        body: FutureBuilder<UserModel>(
            future: getUserDetails(),
            builder: (context, snapshot1) {
              if (snapshot1.hasData) {
                return ProfileWidget(
                  userData: snapshot1.data!,
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.userData,
  });

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 55,
            child: Center(
              child: Text(userData.firstName![0],
                  style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            userData.firstName! + " " + userData.lastName!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            userData.email!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
