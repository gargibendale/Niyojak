import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_planner/login.dart';
import 'package:study_planner/planner_model.dart';
import 'package:study_planner/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TextEditingController dateController = TextEditingController();
TextEditingController dayController = TextEditingController();
TextEditingController scheduleController = TextEditingController();
TextEditingController noteController = TextEditingController();
TextEditingController progressController = TextEditingController();
TextEditingController deadlineController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
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

  uploadPlan(
      {required String date,
      required String day,
      required String schedule,
      required String note,
      required String progress,
      required String deadline}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString("userID") ?? "";
    await FirebaseFirestore.instance.collection("plans").add({
      "user_id": userID,
      "date": date,
      "day": day,
      "schedule": schedule,
      "note": note,
      "progress": progress,
      "deadline": deadline,
      "created_at": DateTime.now(),
      "updated_at": DateTime.now()
    }).then((value) {
      Navigator.pop(context);
    });
  }

  clearText() {
    dateController.clear();
    dayController.clear();
    scheduleController.clear();
    progressController.clear();
    noteController.clear();
    deadlineController.clear();
  }

  addPlanDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return ScreenUtilInit(
            useInheritedMediaQuery: true,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 12.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text("Study Planner",
                              style: GoogleFonts.tenorSans(
                                textStyle: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w500),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Date: ", style: GoogleFonts.tenorSans()),
                              SizedBox(
                                height: 20,
                                width: 100,
                                child: TextField(
                                  controller: dateController,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 15)),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text("Day: ", style: GoogleFonts.tenorSans()),
                              SizedBox(
                                height: 20,
                                width: 100,
                                child: TextField(
                                  controller: dayController,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 15)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Text("Today's Schedule",
                                  style: GoogleFonts.tenorSans()),
                              TextField(
                                  controller: scheduleController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                      hintText: "8:00 AM - History revision",
                                      hintStyle: GoogleFonts.tenorSans())),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              Text("Notes", style: GoogleFonts.tenorSans()),
                              TextField(
                                  controller: noteController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                      hintText: "Reminder!! Quiz at 8",
                                      hintStyle: GoogleFonts.tenorSans())),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              Text("Study Progress",
                                  style: GoogleFonts.tenorSans()),
                              TextField(
                                  controller: progressController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                      hintText: "Science revision done!",
                                      hintStyle: GoogleFonts.tenorSans())),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              Text("Deadlines", style: GoogleFonts.tenorSans()),
                              TextField(
                                  controller: deadlineController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                      hintText: "Assignment due at Wednesday",
                                      hintStyle: GoogleFonts.tenorSans())),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton(
                                    onPressed: () {
                                      clearText();
                                    },
                                    child: Text("Reset",
                                        style: GoogleFonts.tenorSans())),
                                SizedBox(
                                  width: 30,
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    uploadPlan(
                                        date: dateController.text,
                                        day: dayController.text,
                                        schedule: scheduleController.text,
                                        note: noteController.text,
                                        progress: progressController.text,
                                        deadline: deadlineController.text);
                                  },
                                  child: Icon(Icons.save),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Stream<QuerySnapshot> getPlans() {
    Stream<QuerySnapshot> plansStream =
        FirebaseFirestore.instance.collection("plans").snapshots();
    return plansStream;
  }

  String userID = "";
  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("userID") ?? " ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 255, 236, 236),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 124, 0, 0),
        foregroundColor: Color.fromARGB(255, 255, 237, 237),
        title: Text("Home",
            style: GoogleFonts.tenorSans(
                textStyle: TextStyle(fontWeight: FontWeight.bold))),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                child: Icon(Icons.person_2_outlined),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addPlanDialog();
        },
        child: Icon(Icons.add_box),
      ),
      body: StreamBuilder(
          stream: getPlans(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                List<PlannerModel> plansList = [];
                for (var element in snapshot.data!.docs) {
                  Map<String, dynamic> data =
                      element.data() as Map<String, dynamic>;
                  data["document_id"] = element.id;
                  if (data["user_id"] == userID) {
                    plansList.add(PlannerModel.fromDocumentSnapshot(data));
                  }
                }
                return PlanListWidget(
                  plans: plansList,
                );
              } else {
                return Center(
                  child: Text("Empty Planner (^-^)",
                      style: GoogleFonts.tenorSans()),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class PlanListWidget extends StatelessWidget {
  const PlanListWidget({
    super.key,
    required this.plans,
  });

  final List<PlannerModel> plans;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: ((context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return SingleChildScrollView(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "STUDY PLANNER",
                              style: GoogleFonts.tenorSans(
                                  color: Color.fromARGB(182, 59, 0, 0),
                                  textStyle: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                                height: 40,
                                width: 100,
                                child: Image.asset("assets/divider2.png",
                                    fit: BoxFit.fitWidth)),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Date: " + plans[index].date!,
                                    style: GoogleFonts.tenorSans(
                                        color: Color.fromARGB(182, 59, 0, 0),
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text("Day: " + plans[index].day!,
                                      style: GoogleFonts.tenorSans(
                                          color: Color.fromARGB(182, 59, 0, 0),
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.bold)))
                                ],
                              ),
                            ),
                            SizedBox(
                                height: 40,
                                width: 150,
                                child: Image.asset("assets/divider.png",
                                    fit: BoxFit.fitWidth)),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 4.0, 0, 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text("TODAY'S SCHEDULE",
                                            style: GoogleFonts.tenorSans(
                                                color: Color.fromARGB(
                                                    182, 59, 0, 0),
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        SizedBox(height: 10),
                                        Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            elevation: 20,
                                            shadowColor: Colors.transparent,
                                            child: Container(
                                                width: 190,
                                                margin:
                                                    const EdgeInsets.all(15.0),
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(),
                                                child: Text(
                                                    plans[index].schedule!,
                                                    style: GoogleFonts
                                                        .tenorSans()))),
                                        SizedBox(
                                            height: 40,
                                            width: 150,
                                            child: Image.asset(
                                                "assets/divider.png",
                                                fit: BoxFit.fitWidth)),
                                        Text("NOTES",
                                            style: GoogleFonts.tenorSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        182, 59, 0, 0),
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          elevation: 20,
                                          shadowColor: Colors.transparent,
                                          child: Container(
                                              width: 190,
                                              margin:
                                                  const EdgeInsets.all(10.0),
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              decoration: BoxDecoration(),
                                              child: Text(plans[index].note!,
                                                  style:
                                                      GoogleFonts.tenorSans())),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text("STUDY PROGRESS",
                                            style: GoogleFonts.tenorSans(
                                                color: Color.fromARGB(
                                                    182, 59, 0, 0),
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        SizedBox(height: 10),
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          elevation: 20,
                                          shadowColor: Colors.transparent,
                                          child: Container(
                                              width: 190,
                                              margin:
                                                  const EdgeInsets.all(10.0),
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              decoration: BoxDecoration(),
                                              child: Text(
                                                plans[index].progress!,
                                                style: GoogleFonts.tenorSans(),
                                              )),
                                        ),
                                        SizedBox(
                                            height: 40,
                                            width: 150,
                                            child: Image.asset(
                                                "assets/divider.png",
                                                fit: BoxFit.fitWidth)),
                                        Text("DEADLINES",
                                            style: GoogleFonts.tenorSans(
                                                color: Color.fromARGB(
                                                    182, 59, 0, 0),
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Container(
                                            width: 190,
                                            margin: const EdgeInsets.all(10.0),
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(),
                                            child: Text(plans[index].deadline!,
                                                style:
                                                    GoogleFonts.tenorSans())),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(plans[index].date!, style: GoogleFonts.tenorSans()),
              tileColor: const Color.fromARGB(247, 255, 255, 255),
              trailing: IconButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("plans")
                        .doc(plans[index].documentID)
                        .delete();
                  },
                  icon: Icon(Icons.delete_outline_rounded)),
            ),
          ),
        );
      }),
    );
  }
}
