import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_planner/login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  registerUser(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) {
    try {
      final credential = FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        print(value.user?.uid.toString());
        addUserData(
            firstName: firstName,
            lastName: lastName,
            email: email,
            userID: value.user?.uid ?? "");
        Fluttertoast.showToast(msg: "User Registered.");
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: e.toString());
      }
    } catch (e) {}
  }

  addUserData(
      {required String firstName,
      required String lastName,
      required String email,
      required String userID}) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("users").doc(userID).set({
      "first_name": firstName,
      "last_name": lastName,
      "created_at": DateTime.now(),
      "updated_at": DateTime.now(),
      "email": email,
      "user_id": userID,
      "photo": " "
    }).then((value) async {
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', true);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 154, 157, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    hintText: "Enter Your First Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    hintText: "Enter Your Last Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter Your Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    registerUser(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        email: emailController.text,
                        password: passwordController.text);
                  },
                  child: const Text(
                    "Register",
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text("Login"))
            ],
          )
        ],
      ),
    );
  }
}
