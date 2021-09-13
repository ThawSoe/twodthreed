import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupChat extends StatefulWidget {
  final doc;
  final String? username;
  GroupChat({Key? key, this.doc, this.username}) : super(key: key);

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  String groupChatId = '2D3DGroupChats';
  String userId = '';
  User user = FirebaseAuth.instance.currentUser!;
  TextEditingController mychat = TextEditingController();
  ScrollController scrollController = ScrollController();
  Decoration decoration = BoxDecoration(
    gradient: new LinearGradient(
        colors: [Colors.grey, Colors.white],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.mirror),
  );

  @override
  void initState() {
    super.initState();
    // getGroupChatId();
  }

  getGroupChatId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('id')!;

    // String anotherUserId = widget.doc['id'];

    // if (userId.compareTo(anotherUserId) > 0) {
    //   groupChatId = '$userId - $anotherUserId';
    // } else {
    //   groupChatId = '$anotherUserId - $userId';
    // }
    // groupChatId = '$userId - $anotherUserId';

    setState(() {});
  }

  sendMessage() async {
    String msg = mychat.text.trim();

    if (msg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          // .collection('messages')
          // .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().microsecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref, {
          "senderId": user.uid,
          "anotherUserId": "random",
          "sendername": widget.username,
          "timestamp": DateTime.now().microsecondsSinceEpoch.toString(),
          "content": msg,
          "type": "text"
        });
      });
      setState(() {
        mychat.text = "";
      });
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print("Please enter something to send");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Chat"),
        flexibleSpace: Container(
          decoration: decoration,
        ),
      ),
      body: Container(
        decoration: decoration,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                // .collection('messages')
                // .doc(groupChatId)
                .collection(groupChatId)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return groupChatWidget(
                                context, snapshot.data.docs[index]);
                          }),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400),
                            controller: mychat,
                            decoration: InputDecoration(
                                hintText: "Message",
                                hintStyle: TextStyle(
                                    fontSize: 17, color: Colors.grey[700])),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              sendMessage();
                            },
                            icon: Icon(Icons.send))
                      ],
                    )
                  ],
                );
              } else {
                print("Your data is nothing");
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Widget groupChatWidget(BuildContext context, data) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0, left: 10, right: 10
              // left: data['senderId'] == user.uid
              //     ? MediaQuery.of(context).size.width * 0.45
              //     : 10,
              // right: data['senderId'] == user.uid
              //     ? 10
              //     : MediaQuery.of(context).size.width * 0.45
              ), //userId
          child: Row(
            mainAxisAlignment: data['senderId'] == user.uid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: data['senderId'] == user.uid
                          ? Colors.grey[350]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: data['type'] == 'text'
                      ? Text(
                          data['content'].toString(),
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: data['senderId'] == user.uid
                                  ? Colors.black54
                                  : Colors.black),
                        )
                      : Image.network(data['content'])),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: data['senderId'] == user.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
              child: Text(
                data['sendername'].toString(),
                style: TextStyle(
                    color: data['senderId'] == user.uid
                        ? Colors.grey[350]
                        : Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }
}
