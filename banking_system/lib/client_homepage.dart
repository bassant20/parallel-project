import 'drawer2.dart';
import 'package:flutter/material.dart';
//import 'package:search_page/search_page.dart';
import 'package:banking_system/Model/users.dart';
import 'package:banking_system/API.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientH extends StatefulWidget {
  const ClientH(
      {Key? key,
      required this.fname,
      required this.lname,
      required this.email,
      required this.ut})
      : super(key: key);

  final String fname;
  final String lname;
  final String email;
  final dynamic ut;

  @override
  State<ClientH> createState() => _ClientHState();
}

getData() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  var data = FirebaseFirestore.instance.collection('account').doc(uid);
  return data;
}

getData1(ut) {
  var data = FirebaseFirestore.instance.collection('account').doc(ut);
  return data;
}

class _ClientHState extends State<ClientH> {
  final _formKey = GlobalKey<FormState>();
  var value;
  // String fname, lname, email;
  // var ut;

  // Costructor to get the data from the previous page.
  dynamic url,url1;
  var enteredA;
  var Data,Data1;
  @override
  Widget build(BuildContext context) {
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
              }),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text(
                  "Client",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Mouse Memoirs',
                    fontSize: 25,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
              elevation: 30,
              color: Color(0xff506D84),
              margin: EdgeInsets.only(bottom: 35, top: 30, left: 20, right: 20),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                widget.fname + " " + widget.lname,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Mouse Memoirs',
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                widget.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Mouse Memoirs',
                  fontSize: 20,
                ),
              ),
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
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> datauser1 =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      // Text(
                      //   "Amount: " + '${data['total']}',
                      //   style: TextStyle(
                      //     fontSize: 25,
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                        child: TextFormField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter input';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              enteredA = value;
                            },
                            cursorColor: Color(0XFFFFCCFF),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                labelText: 'Enter amount',
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5)))),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: getData1(widget.ut).get(),
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
                            Map<String, dynamic> data1 =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Column(
                              children: [
                                Text(
                                  widget.fname+"'s total amount: "+'${data1['total']} ',
                                  style: TextStyle(
                                      fontSize: 20,),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (int.parse(enteredA) <= int.parse(datauser1["total"])) {
                                        print(enteredA);
                                        var num = 1000;
                                        print(widget.ut);
                                        url =
                                            'http://10.0.2.2:5000/User2?input1=' +
                                                datauser1['total'].toString() +
                                                '&input2=' +
                                                data1['total'].toString() +
                                                '&input3=' +
                                                enteredA.toString();

                                        Data = await Getdata(url);
                                        print(Data);
                                        url1 =
                                            'http://10.0.2.2:5000/User1?input1=' +
                                                datauser1['total'].toString() +
                                                '&input2=' +
                                                data1['total'].toString() +
                                                '&input3=' +
                                                enteredA.toString();

                                        Data1 = await Getdata(url1);
                                        print(Data1);
                                        
                                        await FirebaseFirestore.instance
                                            .collection("account")
                                            .doc(widget.ut)
                                            .set({
                                          "total": Data,
                                        });
                                        await FirebaseFirestore.instance
                                            .collection("account")
                                            .doc(FirebaseAuth.instance.currentUser?.uid)
                                            .set({
                                          "total": Data1,
                                        });
                                        Navigator.of(context).push(
                                MaterialPageRoute(
                                    // Builder for the nextpage
                                    // class's constructor.
                                    builder: (context) => ClientH(
                                          fname: widget.fname,
                                          lname: widget.lname,
                                          email: widget.email,
                                          ut: widget.ut,
                                        )),
                              );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Can not transfer you have reached your limit')),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xff506D84),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: TextStyle(
                                          fontSize: 25,
                                          fontFamily: 'Mouse Memoirs',
                                        )),
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    )),
                              ],
                            );
                          }

                          return Text("loading");
                        },
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
    );
  }
}
