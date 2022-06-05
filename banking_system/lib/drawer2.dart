import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Drawer2 extends StatefulWidget {
  @override
  _Drawer2State createState() => _Drawer2State();
}

getData() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  var data = FirebaseFirestore.instance.collection('users').doc(uid);
  return data;
}

class _Drawer2State extends State<Drawer2> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, top: 30, left: 60, right: 60),
                  child: Column(
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: getData().get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }
//checks the state of the future by using connection state
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Column(
                              children: [
                                Text(
                                  '${data['firstname']} ${data['lastname']}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${data['email']}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }

                          return Text("loading");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 10,
            thickness: 1.2,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Color(0xff506D84),
            ),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/Mscreen');
            },
          ),
          Divider(
            height: 1,
            thickness: 1.2,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app_rounded, color: Color(0xff506D84)),
            title: Text('Sign out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/signout');
            },
          ),
        ],
      ),
    );
  }
}
