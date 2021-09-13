import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twodthreed/src/screens/groupchat.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String? userData;

  final googlesignin = GoogleSignIn();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  checkUserLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString('id'));
    print(sharedPreferences.getString('name'));
    print(sharedPreferences.getString('profie_pic'));
    setState(() {});
    userData = sharedPreferences.getString('id');
    // bool userLogin = (sharedPreferences.getString('id') ?? '').isNotEmpty;
  }

  handleSignIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final res = await googlesignin.signIn();
    final auth = await res?.authentication;
    final credentials = GoogleAuthProvider.credential(
        idToken: auth?.idToken, accessToken: auth?.accessToken);
    final firebaseUser =
        (await firebaseAuth.signInWithCredential(credentials)).user;

    if (firebaseUser != null) {
      final result = (await FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: firebaseUser.uid)
              .get())
          .docs;

      if (result.length == 0) {
        //new user
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          "id": firebaseUser.uid,
          "name": firebaseUser.displayName,
          "profie_pic": firebaseUser.photoURL,
          "created_at": DateTime.now().microsecondsSinceEpoch,
        });

        sharedPreferences.setString('id', firebaseUser.uid);
        sharedPreferences.setString('name', firebaseUser.displayName!);
        sharedPreferences.setString('profie_pic', firebaseUser.photoURL!);
        print("This is new user");
      } else {
        //old user
        sharedPreferences.setString('id', result[0]['id']);
        sharedPreferences.setString('name', result[0]['name']);
        sharedPreferences.setString('profie_pic', result[0]['profie_pic']);
        print("This is old user");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: userData != null
            ? Center(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return allData(snapshot.data.docs[index]);
                            });
                      }
                      return Container();
                    }))
            : Center(
                child: TextButton(
                    onPressed: () {
                      handleSignIn();
                    },
                    child: Text("Sign In"))));
  }

  Widget allData(docs) {
    return Center(
        child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupChat(
                            doc: docs,
                          )));
            },
            child: Text(docs['name'])));
  }
}
