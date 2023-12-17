import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? userID;
  String? photo;

  UserModel(
      {this.firstName, this.lastName, this.email, this.userID, this.photo});

  UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : firstName = doc["first_name"],
        lastName = doc["last_name"],
        email = doc["email"],
        userID = doc["user_id"],
        photo = doc["photo"];

  Map<String, dynamic> toMap() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "user_id": userID,
      "photo": photo
    };
  }
}
