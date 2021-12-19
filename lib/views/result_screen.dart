import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aday/constants/constants.dart';
import 'package:aday/widgets/widget_constants.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Stream<QuerySnapshot> candidatesResultStream =
      FirebaseFirestore.instance.collection('candidates').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: candidatesResultStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(errorString);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(loadingString);
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                margin: all10,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    foregroundImage: NetworkImage(data['imgPath']),
                    foregroundColor: Colors.white,
                    //  child: Image.network(data['imgPath'])
                  ),
                  title: Text(
                    data['name'].toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    voteCount + data['voteCount'].toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  // subtitle: Text(data['company']),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
