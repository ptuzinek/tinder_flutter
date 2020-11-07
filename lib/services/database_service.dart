import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  //collection reference
  final CollectionReference detailsCollection =
      FirebaseFirestore.instance.collection('details');

  DatabaseService({this.uid});

  // Function to add data into firestore
  Future setUserData(String name, String age, String email) async {
    return await detailsCollection.doc(uid)
      ..set({
        'name': name,
        'age': age,
        'email': email,
      });
  }

  // Future updateUserData(String name, String age, String email) async {
  //   return await detailsCollection.doc(uid)..set({
  //     'name': name,
  //     'age': age,
  //     'email': email,
  //   });
  // }
}
