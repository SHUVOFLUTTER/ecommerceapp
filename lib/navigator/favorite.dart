import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favoritewidget extends StatefulWidget {
  const Favoritewidget({Key? key}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<Favoritewidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users_Favorite_items")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("items")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something Went Wrong!"),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
                return ListTile(
                  leading: Text(_documentSnapshot["name"]),
                  title: Text(
                    "\৳ ${_documentSnapshot["price"]}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  trailing: GestureDetector(
                    child: CircleAvatar(
                      child: Icon(Icons.remove_circle),
                    ),
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection("users_favorite_items")
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection("items")
                          .doc(_documentSnapshot.id)
                          .delete();
                    },
                  ),
                );
              });
        },
      )),
    );
  }
}
