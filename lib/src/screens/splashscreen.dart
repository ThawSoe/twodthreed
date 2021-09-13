import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twodthreed/config/global/app_config.dart';
import 'package:twodthreed/config/provider/api_provider.dart';
import 'package:twodthreed/src/screens/home.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    checkupdateApi();
  }

  checkupdateApi() async {
    Provider.of<ApiProvider>(context, listen: false)
        .apiData(API.update)
        .then((value) {
      setState(() {
        if (VersionContol.versioncode < value["version_code"]) {
          showAlertDialog(context, value["update_message"],
              value["force_update"].toString(), value["link"].toString());
        } else {
          // Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
          // });
        }
      });
    });
  }

  showAlertDialog(
      BuildContext context, String msg, String forceupdate, String updatelink) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style:
            TextStyle(backgroundColor: Colors.transparent, color: Colors.black),
      ),
      onPressed: () {
        forceupdate == "true"
            ? print("")
            : Future.delayed(Duration(seconds: 3), () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              });
      },
    );
    Widget continueButton = TextButton(
      child: Text("Update",
          style: TextStyle(
              backgroundColor: Colors.transparent, color: Colors.black)),
      onPressed: () {
        _launchInBrowser(updatelink);
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Warning !",
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content:
          Text(msg.toString(), style: Theme.of(context).textTheme.headline3),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      // barrierDismissible: forceupdate == "true" ? false : true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
          decoration: decoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Version " + VersionContol.versionname.toString()),
            ],
          ),
        ),
        body: Container(
          decoration: decoration,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 160.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://media.gettyimages.com/vectors/myanmar-3d-map-on-gray-background-vector-id1171663076")),
                        borderRadius: BorderRadius.all(Radius.circular(90.0)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Welcome From 2D & 3D",
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
                Image.asset(
                  'assets/images/loading.gif',
                  width: 120,
                  height: 120,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ));
  }
}
