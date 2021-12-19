
import 'package:aday/views/result_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants/constants.dart';


class VotedScreen extends StatefulWidget {
  var data;
  VotedScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<VotedScreen> createState() => _VotedScreenState();
}

class _VotedScreenState extends State<VotedScreen> {
  var ref = FirebaseFirestore.instance.collection('dedicates').snapshots();



  var users = FirebaseFirestore.instance
      .collection('users')
      .doc('${FirebaseAuth.instance.currentUser?.uid}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('$votedScreenString ${widget.data['name']}',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
          ),
          SizedBox(height: 400, child: Image.network(widget.data['imgPath'])),
          SizedBox(
              height: 150, child: Image.network(widget.data['evetImgPath'])),
          FutureBuilder(
            future: users.get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text("");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                
                return Text("${data['name']} ${data['surname']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ));
              }

              return Text("");
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.black),
            onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultScreen()));
          }, child:Text(votedScreenShowResults)),
        ],
      ),
    );
  }
}
