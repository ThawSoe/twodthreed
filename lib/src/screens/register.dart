import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twodthreed/config/global/phnovalidation.dart';
import 'package:twodthreed/src/screens/groupchat.dart';

class Regsiter extends StatefulWidget {
  const Regsiter({Key? key}) : super(key: key);

  @override
  _RegsiterState createState() => _RegsiterState();
}

class _RegsiterState extends State<Regsiter> {
  final phoneno = TextEditingController();
  final name = TextEditingController();
  final codeno = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future _userRegister(value) async {
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: value.toString(),
        timeout: Duration(minutes: 2),
        verificationCompleted: (AuthCredential credential) {
          firebaseAuth.signInWithCredential(credential).then((result) {
            print(result.user);
          }).catchError((e) {
            print("Error $e");
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String? verificationId, [int? forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Please enter code ",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: codeno,
                        autofocus: true,
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text(
                        "Verify",
                        style: TextStyle(
                            backgroundColor: Colors.black, color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      onPressed: () async {
                        if (codeno.text.toString().isEmpty) {
                        } else {
                          final code = codeno.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId!,
                                  smsCode: code);
                          await firebaseAuth
                              .signInWithCredential(credential)
                              .then((value) {
                            print("Register Successfully !");
                            print(value);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupChat(
                                          username: name.text.toString(),
                                        )));
                          });
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        });
  }

  @override
  Widget build(BuildContext context) {
    Decoration decoration = BoxDecoration(
      gradient: new LinearGradient(
          colors: [Colors.grey, Colors.white],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.mirror),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        flexibleSpace: Container(
          decoration: decoration,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: phoneno,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Please enter your phone number !";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(fontSize: 16),
                    // hintText: "09*********",
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: name,
                  autofocus: true,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Please enter your name !";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(fontSize: 16),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    width: double.infinity,
                    // decoration: decoration,
                    height: 50,
                    child: OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            backgroundColor: Colors.black,
                            fontSize: 19,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          phonenovalidation(phoneno.text.toString())
                              .then((value) {
                            _userRegister(value);
                          });
                        } else {
                          print("please fill form completely");
                        }
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
