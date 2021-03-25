
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddUserState();
  }

}

class AddUserState extends State<AddUser> {

  final ctrlPrenom = TextEditingController();
  final ctrlNom = TextEditingController();
  final ctrlAge = TextEditingController();

  createUser () {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users.add({
      'nom': ctrlNom.text,
      'prenom': ctrlPrenom.text,
      'age': ctrlAge.text
    })
    .then((value) => Navigator.pop(context))
    .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add User"),
        ),
        body: Center(
            child: Column(
              children: [
                TextField(
                  controller: ctrlNom,
                  decoration: InputDecoration(
                  border: InputBorder.none,
                      hintText: 'Enter nom'
                  ),
                ),
                TextField(
                  controller: ctrlPrenom,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter prenom'
                  ),
                ),
                TextField(
                  controller: ctrlAge,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter age'
                  ),
                ),
                ElevatedButton(
                    onPressed: createUser,
                    child: Text ("Create user")
                )
              ],
            )
        ),
    );
  }

}