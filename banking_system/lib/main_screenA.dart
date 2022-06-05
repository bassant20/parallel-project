import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer2.dart';
import 'package:flutter/material.dart';
//import 'package:search_page/search_page.dart';
import 'package:banking_system/Model/users.dart';
import 'package:banking_system/client_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreenA extends StatefulWidget {
  @override
  _MainScreenAState createState() => _MainScreenAState();
}

class _MainScreenAState extends State<MainScreenA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
    );
  }
}

var userid;

getData() {
  var data = FirebaseFirestore.instance
      .collection('account')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  return data;
}
// dart support stream of async of data using streams
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var usersref = getData();
    return Scaffold(
        drawer: Drawer2(),
        appBar: AppBar(
          //   title: Apps(),
          backgroundColor: Color(0xff506D84),

          title: Padding(
            padding: const EdgeInsets.only(left: 292, top: 5),
            child: IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search your Clients',
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              }
            ),
          ),
        ),
        body: Container(
            alignment: FractionalOffset.center,
            color: Colors.white,
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: const ListTile(
                    title: Text(
                      "Total amount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Mouse Memoirs',
                        fontSize: 30,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                  elevation: 30,
                  color: Color(0xff506D84),
                  margin:
                      EdgeInsets.only(bottom: 10, top: 20, left: 60, right: 60),
                ),
                
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
                               Padding(padding: EdgeInsets.only(top: 30,left: 50,right:50),
                               child:  Text(
                                  "Total: "+'${data['total']}',
                                   textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Mouse Memoirs',
                        fontSize: 30,
                      ),
                                ),
                               )
                               
                              ],
                            );
                          }

                          return Text("loading");
                        },
                      ),
              ],
            )));
  }
}

 