import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class user {
  final String? fname;
  final String? lname;
  final String? email;
  var ut;

  user({this.fname, this.lname, this.email,this.ut});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<user> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;
var ut=snapshot.id;
      return user(
          fname: dataMap['firstname'],
          lname: dataMap['lastname'],
          email: dataMap['email'],
          ut: ut,
          );
    }).toList();
  }
}
