import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_board_app_firebase/widgets/custom_card.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firestoreDb = FirebaseFirestore.instance.collection("board").snapshots();
  TextEditingController nameInputController;
  TextEditingController titleInputController;
  TextEditingController descriptionInputController;

  @override
  void initState() {
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Board'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addDiaglog(context);
        },
        child: Icon(FontAwesome.pencil),
      ),
      body: StreamBuilder(
          stream: firestoreDb,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    return CustomCard(snapshot: snapshot.data, index: index);

                    //return Text(snapshot.data.documents[index].get("title"));
                  });
            }
          }),
    );
  }

  _addDiaglog(BuildContext context) async {
    await showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text('Please fill out the form',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 15.0),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    controller: nameInputController,
                    decoration: InputDecoration(
                        labelText: 'Enter your name *',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.amber)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.amber)),
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.black12),
                  ),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    controller: titleInputController,
                    decoration: InputDecoration(
                        labelText: 'Enter title *',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.amber)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.amber)),
                        prefixIcon: Icon(Icons.title),
                        filled: true,
                        fillColor: Colors.black12),
                  ),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    controller: descriptionInputController,
                    decoration: InputDecoration(
                        labelText: 'Enter description *',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.amber)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.amber)),
                        prefixIcon: Icon(Icons.description),
                        filled: true,
                        fillColor: Colors.black12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  nameInputController.clear();
                  titleInputController.clear();
                  descriptionInputController.clear();
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () {
                  if (titleInputController.text.isNotEmpty &&
                      descriptionInputController.text.isNotEmpty &&
                      nameInputController.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection("board").add({
                      "name": nameInputController.text,
                      "title": titleInputController.text,
                      "description": descriptionInputController.text,
                      "timestamp": DateTime.now()
                    }).then((response) {
                      print(response.id);
                      Navigator.pop(context);

                      nameInputController.clear();
                      titleInputController.clear();
                      descriptionInputController.clear();
                    }).catchError((error) => print(error));
                  }
                },
                child: Text('Save')),
          ],
        ));
  }
}
