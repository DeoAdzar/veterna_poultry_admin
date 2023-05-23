import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference userCollection =
    FirebaseFirestore.instance.collection("users");

class DatabaseMethod {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addUserInfoToDB(String? user, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .set(userInfoMap);
  }

  Future<DocumentSnapshot> getUserFromDB(String? user) async {
    return userCollection.doc(user).get();
  }
}
