import 'package:cloud_firestore/cloud_firestore.dart';

class PlannerModel {
  String? userID;
  String? date;
  String? day;
  String? schedule;
  String? note;
  String? progress;
  String? deadline;
  String? documentID;

  PlannerModel({
    this.userID,
    this.date,
    this.day,
    this.schedule,
    this.note,
    this.progress,
    this.deadline,
    this.documentID,
  });

  PlannerModel.fromDocumentSnapshot(Map<String, dynamic> doc)
      : userID = doc["user_id"],
        date = doc["date"],
        day = doc["day"],
        schedule = doc["schedule"],
        note = doc["note"],
        progress = doc["progress"],
        deadline = doc["deadline"],
        documentID = doc["document_id"];

  Map<String, dynamic> toMap() {
    return {
      "user_id": userID,
      "date": date,
      "day": day,
      "schedule": schedule,
      "note": note,
      "progress": progress,
      "deadline": deadline,
      "document_id": documentID
    };
  }
}
