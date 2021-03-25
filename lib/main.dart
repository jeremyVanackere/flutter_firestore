import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/AddUser.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void handleFloatingBtn() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddUser())
    );
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    removeUser(final String id) {
      users
          .doc(id)
          .delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Dismissible(
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: Key(document.id),
                  // Provide a function that tells the app
                  // what to do after an item has been swiped away.
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    removeUser(document.id);

                    // Show a snackbar. This snackbar could also contain "Undo" actions.
                    ScaffoldMessenger
                        .of(context)
                        .showSnackBar(SnackBar(content: Text("Supprimé")));
                  },
                  child: new ListTile(
                    title: new Text(document.data()['nom'] + " " + document.data()['prenom']),
                    subtitle: new Text(document.data()['age']),
                  )
                );
              }).toList(),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleFloatingBtn,
        tooltip: 'Ajouter user',
        child: Icon(Icons.add),
      ),
    );
  }
}
