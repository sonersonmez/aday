import 'package:aday/views/result_screen.dart';
import 'package:aday/views/voted_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:aday/constants/constants.dart';
import 'package:aday/widgets/widget_constants.dart';

import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Stream<QuerySnapshot> _candidatesStream =
      FirebaseFirestore.instance.collection('candidates').snapshots();

  var users = FirebaseFirestore.instance
      .collection('users')
      .doc('${FirebaseAuth.instance.currentUser?.uid}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainScreenAppBar(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: _candidatesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(errorString);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                   topSpacing, //ÜST BOŞLUK
                  candidatesImages(data: data),
                  sizedBoxheight15,// ARA BOŞLUK
                  candidatesNames(data: data), // ADAY İSİMLERİ
                  sizedBoxheight15, // ARA BOŞLUK
                  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc('${FirebaseAuth.instance.currentUser?.uid}')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.data?['isVoted'] == true) {
                          return basarisizAwesomeDialog(context);
                         
                        } else {
                          return basariliAwesomeDialog(context, document, data);
                        }
                      }),
                  // EVET BUTONU
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  AppBar mainScreenAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ))
      ],
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'Adaylar',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  GestureDetector basarisizAwesomeDialog(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          headerAnimationLoop: false,
          animType: AnimType.BOTTOMSLIDE,
          body: Center(
            child: Text(
              forbiddenVoteString,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
            ),
          ),
          btnOkColor: Colors.green,
          desc: votedErrorMsg,
          buttonsTextStyle: const TextStyle(color: Colors.white),
          showCloseIcon: true,
          btnOkText: votedScreenShowResults,
          btnOkOnPress: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResultScreen()));
          },
          btnCancelOnPress: () {},
          btnCancelText: refuseString,
        ).show();
      },
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 65,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(evetImgPath),
          radius: 60,
        ),
      ),
    );
  }

  GestureDetector basariliAwesomeDialog(BuildContext context,
      DocumentSnapshot<Object?> document, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO_REVERSED,
          headerAnimationLoop: false,
          animType: AnimType.BOTTOMSLIDE,
          body: Center(
            child: Text(
              awesomeDialogString,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
            ),
          ),
          btnOkColor: Colors.green,
          desc: awesomeDialogSubtitle,
          buttonsTextStyle: const TextStyle(color: Colors.white),
          showCloseIcon: true,
          btnOkText: 'Kabul',
          btnOkOnPress: () {
            FirebaseFirestore.instance
                .collection('candidates')
                .doc(document.id)
                .update({'voteCount': FieldValue.increment(1)});
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VotedScreen(
                          data: data,
                        )));
            FirebaseFirestore.instance
                .collection('users')
                .doc('${FirebaseAuth.instance.currentUser?.uid}')
                .update({'isVoted': true});
          },
          btnCancelOnPress: () {},
          btnCancelText: 'Reddet',
        ).show();
      },
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(evetImgPath),
        radius: 60,
      ),
    );
  }
}

class candidatesNames extends StatelessWidget {
  const candidatesNames({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Text(data['name'],
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold));
  }
}

class candidatesImages extends StatelessWidget {
  const candidatesImages({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(
          radius: 125,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(data['imgPath']

              // height: MediaQuery.of(context).size.height * 0.5,
              ),
        ) //ADAY FOTOĞRAFLARI
        );
  }
}
