import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

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
  AssetsAudioPlayer _assetsAudioPlayer;

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];

  Future<void> getSongs() async {
    songs = await audioQuery.getSongs();

    setState(() {
      songs = songs;
    });

    for (int i = 0; i < songs.length; i++) {
      print(songs[i].title);
      print(songs[i].albumArtwork);
    }
    // print(songs);
  }

  bool isplaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkforLOgin();
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('signup'),
        ),
        body: Column(children: [
          InkWell(
            onTap: () {
              signup();
            },
            child: Icon(
              !isplaying ? Icons.play_circle_fill : Icons.pause_circle_filled,
              size: 42,
            ),
          ),
          songs.length == 0
              ? Container()
              : Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: songs.length,
                itemBuilder: (context, index) =>
                    ListTile(
                      leading: songs[index].albumArtwork == null
                          ? Icon(Icons.music_note)
                          : CircleAvatar(
                        backgroundImage: FileImage(
                            File(songs[index].albumArtwork)),
                      ),
                      title: Text(songs[index].title),
                      subtitle: Text(songs[index].artist),
                    )),
          )
        ]));
  }

  signup() async {
    if (_assetsAudioPlayer == null) {
      _assetsAudioPlayer = AssetsAudioPlayer.withId('music');
      _assetsAudioPlayer.open(
          Audio.network(
              'https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Music_for_Video/springtide/Sounds_strange_weird_but_unmistakably_romantic_Vol1/springtide_-_03_-_We_Are_Heading_to_the_East.mp3',
              metas: Metas(
                  id: 'Online',
                  title: 'Online',
                  artist: 'Florent Champigny',
                  album: 'OnlineAlbum',
                  image: MetasImage.network(
                      'https://image.shutterstock.com/image-vector/pop-music-text-art-colorful-600w-515538502.jpg'))),
          autoStart: true,
          showNotification: true);

      setState(() {
        isplaying = true;
      });
    } else {
      if (isplaying) {
        setState(() {
          _assetsAudioPlayer.pause();
          isplaying = !isplaying;
        });
      } else {
        setState(() {
          _assetsAudioPlayer.play();
          isplaying = !isplaying;
        });
      }
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
    // try {
    //   final newUser = await _auth
    //       .signInWithEmailAndPassword(
    //           email: 'imsambhavjain13@gmail.com', password: 'password')
    //       .then((value) => {print('signed in')})
    //       .whenComplete(() => {print('complete')});
    //
    //   if (newUser != null) {
    //     print('successfull 2');
    //     checkforLOgin();
    //   }
    // } catch (e) {
    //   print(e);
    // }
    _assetsAudioPlayer.pause();
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
