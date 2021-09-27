import 'package:fanpage_app/widgets/message_design.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var fanMessage = '';
  var userDocument;
  var userId;
  var format = DateFormat('h:mm a');
  @override
  void initState() {
    super.initState();
    _getId();
  }

  TextEditingController messageController = TextEditingController();
  void _messageSubmit() {
    Firestore.instance
        .collection('messages/ne6MUaXi2wup9WOcZq85/alerts')
        .add({'text': messageController.text, 'createdAt': DateTime.now()});
    messageController.clear;
    Navigator.of(context).pop();
  }

  Future _getId() async {
    var test = await FirebaseAuth.instance.currentUser();

    userId = test.uid;
    print(userId);
    Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        userDocument = documentSnapshot.data['role'];
      });
    });
  }

  // Widget _getId() {
  //   return FutureBuilder(future: Firestore.instance.collection('users'),child: Text());
  // }

  @override
  Widget build(BuildContext context) {
    print('User ID: ${userId}');

    print('User Role: ${userDocument}');
    if (userDocument == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              title: Row(
                children: [
                  Text('Fan',
                      style: TextStyle(fontFamily: 'Raleway', fontSize: 22)),
                  Text('Page',
                      style:
                          TextStyle(fontFamily: 'Raleway-Bold', fontSize: 22))
                ],
              ),
              actions: [
                DropdownButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                  items: [
                    DropdownMenuItem(
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Logout')
                            ],
                          ),
                        ),
                        value: 'logout')
                  ],
                  onChanged: (itemIdentifier) {
                    if (itemIdentifier == 'logout') {
                      FirebaseAuth.instance.signOut();
                    }
                  },
                )
              ],
            ),
          ),
          body: StreamBuilder(
            stream: Firestore.instance
                .collection('messages/ne6MUaXi2wup9WOcZq85/alerts')
                .snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = streamSnapshot.data.documents;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (ctx, index) => MessageDesign(
                        documents[index]['text'],
                        format
                                .format(documents[index]['createdAt'].toDate())
                                .toString() ??
                            '',
                      )
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   child: Card(
                  //     elevation: 10,

                  //     // decoration:
                  //     // BoxDecoration(border: Border.all(color: Colors.black)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
                  //       child: Container(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.stretch,
                  //           mainAxisAlignment: MainAxisAlignment.end,
                  //           children: [
                  //             Text(
                  //               documents[index]['text'],
                  //               textAlign: TextAlign.center,
                  //               style: const TextStyle(
                  //                   fontWeight: FontWeight.w400, fontSize: 25),
                  //             ),
                  //             Text(
                  // format
                  //         .format(documents[index]['createdAt']
                  //             .toDate())
                  //         .toString() ??
                  //     '',
                  //                 textAlign: TextAlign.end,
                  //                 style: const TextStyle(
                  //                     fontWeight: FontWeight.w300, fontSize: 10)),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  );
            },
          ),
          floatingActionButton: Visibility(
            visible: checkIfAdmin(),
            child: Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 70),
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context),
                      );
                    },
                  ),
                ),
              ),
            ),
          ));
    }
  }

  bool checkIfAdmin() {
    // getData();
    // print(userDocument['role']);
    if (userDocument == 'admin') {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Write a message!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: messageController,
            minLines: 6,
            maxLines: 12,
            keyboardType: TextInputType.emailAddress,
            // textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText: 'Message for your fans',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(25.0)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: _messageSubmit,
          child: const Text('Post Message'),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
