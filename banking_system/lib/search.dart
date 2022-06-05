import 'package:flutter/material.dart';
//import 'package:search_page/search_page.dart';
import 'package:banking_system/Model/users.dart';
import 'package:banking_system/client_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_search/firestore_search.dart';

//This package helps developers in implementation of search on Cloud FireStore. This package comes with the implementation of widgets essential
// for performing search on a database.
class SearchBar extends StatefulWidget {
  const SearchBar({ Key? key }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
      firestoreCollectionName: 'users',
      searchBy: 'email',
    appBarBackgroundColor: Color(0xff506D84),
      
      scaffoldBody: Center(),
      //This function converts QuerySnapshot to A List of required data
      dataListFromSnapshot: user().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<user>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
          //to show search results.
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final user data = dataList[index];
                return ListTile(
                            title: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${data.fname}'+' '+'${data.lname}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 8.0, right: 8.0),
                      child: Text('${data.email}',
                          style: Theme.of(context).textTheme.bodyText1),
                    )
                  ],
                ),
                 onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ClientH(
                                          fname: '${data.fname}',
                                          lname:'${data.lname}',
                                          email:'${data.email}',
                                          ut:'${data.ut}',
                                        )),
                              );
                            },
                          );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}