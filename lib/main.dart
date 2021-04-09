import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkforLOgin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('signup'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.yellow,
            child: TextButton(
              onPressed: () {
                signup();
              },
              child: Text('SignUP'),
            ),
          ),
          Container(
            color: Colors.orange,
            child: TextButton(
              onPressed: () {
                signin();
              },
              child: Text('Login'),
            ),
          ),
          Container(
            color: Colors.deepOrange,
            child: TextButton(
              onPressed: () {
                signout();
              },
              child: Text('Sign out'),
            ),
          ),
          Container(
            color: Colors.deepOrange,
            child: TextButton(
              onPressed: () {
                db();
              },
              child: Text('database'),
            ),
          ),
        ],
      ),
    );
  }

  signup() async {
    try {
      final newUser = await _auth
          .createUserWithEmailAndPassword(
              email: 'imsambhavjain13@gmail.com', password: 'password')
          .then((value) => {print('signed up sucess'), storeToDB()})
          .whenComplete(() => {print('sucessfull')});

      if (newUser != null) {
        print('successfull 2');
      }
    } catch (e) {
      print(e);
    }
  }

  checkforLOgin() {
    User userData = FirebaseAuth.instance.currentUser;
    if (userData != null) {
      print('loged in');
    } else {
      print('logged out');
    }
  }

  Future<void> signin() async {
    try {
      final newUser = await _auth
          .signInWithEmailAndPassword(
              email: 'imsambhavjain13@gmail.com', password: 'password')
          .then((value) => {print('signed in')})
          .whenComplete(() => {print('complete')});

      if (newUser != null) {
        print('successfull 2');
        checkforLOgin();
      }
    } catch (e) {
      print(e);
    }
  }

  signout() async {
    try {
      final newUser = await _auth
          .signOut()
          .then((value) => {print('signed out')})
          .whenComplete(() => {print('complete')});

      if (newUser != null) {
        print('successfull 2');
        checkforLOgin();
      }
    } catch (e) {
      print(e);
    }
  }

  storeToDB() {
    FirebaseFirestore.instance
        .collection('one')
        .add({'email': 'imsambhavjain13@gmail.com', 'password': 'password'})
        .then((value) => {print('added')})
        .whenComplete(() => {print('complete')});
  }

  db() {
    FirebaseFirestore.instance.doc('three/someRandomId').set({
      'array': {'email': 'email', 'password': 'password'},
      'three': 'hahaha'
    }).then((value) => {print('added')});
  }
}
