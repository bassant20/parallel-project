import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SignIn> {
  getData() {
    CollectionReference usersref =
        FirebaseFirestore.instance.collection("users");
    usersref.get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        print("================================");
      });
    });
  }

  @override
  void initState() {
    //  addData();
    getData();
    super.initState();
  }

  @override
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
  var password, email;

  signIN() async {
    var formdata = _formKey.currentState;
    if (formdata!.validate()) {
      print('valid');
      formdata.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return userCredential;
      } on FirebaseException catch (e) {
        if (e.code == 'user-not-found') {
        } else if (e.code == 'wrong-password') {
          print('re-enter password, the password is wrong');
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(children: [
        Container(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 50, left: 20, right: 20, bottom: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                child: const ListTile(
                  title: Text(
                    "SIGN IN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Mouse Memoirs',
                      fontSize: 20,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                elevation: 30,
                color: Color(0xff506D84),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 35),
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
                      labelText: 'Enter Email',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 20),
              child: Container(
                child: TextFormField(
                  onSaved: (val) {
                    password = val;
                  },
                  obscureText: true,
                  // obscure tkhalih msh bayn el pass
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
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        var user = await signIN();

                        if (user != null) {
                          print("done");
                          CollectionReference usersref =
                              FirebaseFirestore.instance.collection("users");
                          print(email);
                          await usersref
                              .where("email", isEqualTo: email)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              var UT = element['usertype'];

                              if (UT == 2) {
                                Navigator.pushNamed(context, '/Mscreen');
                              } else if (UT == 1) {
                                Navigator.pushNamed(context, '/mainscreenA');
                              }
                            });
                          });

                          //Navigator.of(context).pushNamed("signout");
                        } else {
                          print("Sign in failed");
                        }

                        //   if (_formKey.currentState!.validate()) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //           content: Text('Processing Data')),
                        //     );
                        //     //  Navigator.pushNamed(context, '/third');
                        //   }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff506D84),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Mouse Memoirs',
                          )),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color(0xffffffff),
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                'Do not have an account?',
                style: TextStyle(
                  color: Color(0xff000000),
                  fontFamily: 'Mouse Memoirs',
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 70),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff506D84),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Mouse Memoirs',
                      )),
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: Color(0xffffffff),
                    ),
                  )),
            ),
          ],
        ))
      ]),
    );
  }
}
