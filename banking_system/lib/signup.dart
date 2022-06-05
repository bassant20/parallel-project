// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUp extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<SignUp> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  late var firstname, lastname, password, email;

signUp() async {
    var formdata = _formKey.currentState;
    if (formdata!.validate()) {
      print('valid');
      formdata.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        DocumentReference r = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);

        FirebaseFirestore.instance.runTransaction(
          (transaction) async {
            DocumentSnapshot snapShot = await transaction.get(r);

            if (!snapShot.exists) {
              r.set({
                "firstname": firstname,
                "lastname": lastname,
                "email": email,
                "usertype": 2,
              });
            }
          },

          // CollectionReference usersref =
          //     FirebaseFirestore.instance.collection("users");
          // UserCredential userCredential = await FirebaseAuth.instance
          //     .createUserWithEmailAndPassword(email: email, password: password);
          // var currentUser = FirebaseAuth.instance.currentUser;
          // var uid = currentUser!.uid;

          // usersref.add({
          //   "firstname": firstname,
          //   "lastname": lastname,
          //   "email": email,
          //   "password": password,
          //   "usertype": 3,
          // });

          // return userCredential;
        );
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          // Alert(
          //         context: context,
          //         title: "Password Issue",
          //         desc: "It's a weak password please enter stronger one.")
          //     .show();
          // print('the password is too weak');
        } else if (e.code == 'email-already-in-use') {
          // Alert(
          //         context: context,
          //         title: "Email Issue",
          //         desc: "The account already exists.")
          //     .show();
          print('the account already exists');
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('not valid');
    }
    return 'ok';
  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          //decoration: new BoxDecoration(
          //    image: new DecorationImage(
          //      image: new AssetImage('assets/3.PNG'), fit: BoxFit.cover)),
          child: ListView(
            children: [
              SizedBox(height: 100),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                child: const ListTile(
                  title: Text(
                    "SIGN UP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                elevation: 30,
                color: Color(0xff506D84),
                margin: EdgeInsets.only(bottom: 10, left: 95, right: 90),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Container(
                  child: TextFormField(
                   onSaved: (val) {
                      firstname = val;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length <= 2) {
                        return 'Please text should be greater than 2';
                      }
                      return null;
                    },
                    cursorColor: Color(0XFFFFCCFF),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Enter Your First Name',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Container(
                  child: TextFormField(
                   onSaved: (val) {
                      lastname = val;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length <= 2) {
                        return 'Please text should be greater than 2';
                      }
                      return null;
                    },
                    cursorColor: Color(0XFFFFCCFF),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Enter Your Last Name',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Container(
                  child: TextFormField(
                   onSaved: (val) {
                      email = val;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return 'Please Enter a valid Email';
                      }
                      return null;
                    },
                    cursorColor: Color(0XFFFFCCFF),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Enter your Email',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Container(
                  child: TextFormField(
                   onSaved: (val) {
                      password = val;
                    },
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    cursorColor: Color(0XFFFFCCFF),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Enter Password',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Container(
                  child: TextFormField(
                    onSaved: (val) {
                      password = val;
                    },
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    cursorColor: Color(0XFFFFCCFF),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Re-enter Password',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 130),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff506D84),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            textStyle: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Mouse Memoirs',
                            )),
                        child: Text(
                          'BACK',
                          style: TextStyle(
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async{
                          if (await signUp() == 'ok') {
                            print(
                                "object....................................................................................................................................");
                                FirebaseFirestore.instance.collection("account").doc(FirebaseAuth.instance.currentUser?.uid).set({"total":"2000"});
                            Navigator.pop(context);
                          } else {
                            print("Sign up failed");
                          }
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff506D84),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            textStyle: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Mouse Memoirs',
                            )),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: Color(0xffffffff),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
