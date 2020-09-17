import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fire = FirebaseFirestore.instance.collection("board");
    var queryData = snapshot.docs[index];
    var docId = snapshot.docs[index].id;
    var timeToDate = DateTime.fromMillisecondsSinceEpoch(
        queryData.get("timestamp").seconds * 1000);
    var formattedTime = DateFormat('EEEE, MMM d').format(timeToDate);
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: ListTile(
              title: Text(
                queryData.get('title'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(queryData.get('description')),
              leading: CircleAvatar(
                radius: 40.0,
                child: Text(queryData.get('title').toString()[0]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Written by: ${queryData.get('name')}",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(width: 10),
                Text(formattedTime),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  icon: (Icon(
                    FontAwesome.edit,
                    size: 17,
                    color: Colors.green[900],
                  )),
                  onPressed: () {}),
              SizedBox(width: 19),
              IconButton(
                  icon: (Icon(
                    FontAwesome.trash,
                    size: 17,
                    color: Colors.red[900],
                  )),
                  onPressed: () async {
                    await fire.doc(docId).delete();
                    print(docId);
                  }),
            ],
          )
        ],
      ),
    );
  }
}
