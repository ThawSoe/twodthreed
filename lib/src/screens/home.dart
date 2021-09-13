import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:twodthreed/config/global/app_config.dart';
import 'package:twodthreed/config/provider/api_provider.dart';
import 'package:twodthreed/src/screens/groupchat.dart';
import 'package:twodthreed/src/screens/hteeList.dart';
import 'package:twodthreed/src/screens/register.dart';
import 'package:twodthreed/src/screens/threeDList.dart';
import 'package:twodthreed/src/screens/twoDList.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var myanmarhtee = {};
  var thaihtee = {};
  var luckynumber = {};
  String twodDate = "";
  String marqueetext = "Minglabar Myanmar";
  List? twodList;
  List? threedList;

  @override
  void initState() {
    super.initState();
    apiCollection();
  }

  apiCollection() async {
    twodApi();
    threedApi();
    myanmarhteeApi();
    thaihteeApi();
    luckynumberApi();
  }

  twodApi() async {
    Provider.of<ApiProvider>(context, listen: false)
        .apiData(API.twod)
        .then((value) {
      setState(() {
        twodList = value;
      });
      twodDate = value[0]['date'];
    });
  }

  threedApi() async {
    Provider.of<ApiProvider>(context, listen: false)
        .apiData(API.threed)
        .then((value) {
      setState(() {
        threedList = value;
      });
    });
  }

  myanmarhteeApi() async {
    Provider.of<ApiProvider>(context, listen: false)
        .apiData(API.myanmarhtee)
        .then((value) {
      setState(() {
        myanmarhtee = value;
      });
    });
  }

  thaihteeApi() async {
    Provider.of<ApiProvider>(context, listen: false)
        .apiData(API.thaihtee)
        .then((value) {
      setState(() {
        thaihtee = value;
      });
    });
  }

  luckynumberApi() async {
    Provider.of<ApiProvider>(context, listen: false)
        .apiData(API.luckynumber)
        .then((value) {
      setState(() {
        marqueetext = value['marquee'];
        luckynumber = value;
      });
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
        title: Text("2D & 3D"),
        flexibleSpace: Container(
          decoration: decoration,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                // FirebaseAuth.instance.signOut();
                FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                var currentUser = firebaseAuth.currentUser;
                if (currentUser == null) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Regsiter()));
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => GroupChat()));
                }
              },
              icon: Icon(Icons.chat_bubble_outline_outlined)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Container(
        decoration: decoration,
        child: ListView(
          children: [
            liveTwoDWidget(),
            Consumer<ApiProvider>(builder: (_, twod, widget) {
              return Center(child: Text(twodDate));
            }),
            Container(
              margin: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.20,
              child: Card(
                child: FutureBuilder(
                    future: Provider.of<ApiProvider>(context, listen: false)
                        .apiData(API.twod),
                    builder: (_, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset(
                            'assets/images/loading.gif',
                            width: 70,
                            height: 70,
                            color: Colors.green,
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(""),
                              Text("Morning",
                                  style: Theme.of(context).textTheme.headline2),
                              Text("Evening",
                                  style: Theme.of(context).textTheme.headline2)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Modern",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              Text(snapshot.data[0]['morningmodern'],
                                  style: Theme.of(context).textTheme.headline3),
                              Text(snapshot.data[0]['eveningmodern'],
                                  style: Theme.of(context).textTheme.headline3)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Internet",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              Text(snapshot.data[0]['morninginternet'],
                                  style: Theme.of(context).textTheme.headline3),
                              Text(snapshot.data[0]['eveninginternet'],
                                  style: Theme.of(context).textTheme.headline3)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Result",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              Text(snapshot.data[0]['morningresult'],
                                  style: Theme.of(context).textTheme.headline4),
                              Text(snapshot.data[0]['eveningresult'],
                                  style: Theme.of(context).textTheme.headline4)
                            ],
                          )
                        ],
                      );
                    }),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                height: MediaQuery.of(context).size.height * 0.05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TwoDListPage(
                                  twoD: twodList,
                                )));
                  },
                  child: Card(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "2D Result Lists",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(">>>", style: Theme.of(context).textTheme.headline5)
                    ],
                  )),
                )),
            Container(
              height: 30,
              child: Marquee(
                text: marqueetext.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 20.0,
                velocity: 100.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              height: MediaQuery.of(context).size.height * 0.10,
              child: Card(
                child: FutureBuilder(
                    future: Provider.of<ApiProvider>(context, listen: false)
                        .apiData(API.threed),
                    builder: (_, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset(
                            'assets/images/loading.gif',
                            width: 70,
                            height: 70,
                            color: Colors.green,
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Date",
                                  style: Theme.of(context).textTheme.headline2),
                              Text(snapshot.data[0]['date'],
                                  style: Theme.of(context).textTheme.headline3)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "3D Result",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              Text(snapshot.data[0]['number'],
                                  style: Theme.of(context).textTheme.headline4)
                            ],
                          ),
                        ],
                      );
                    }),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                height: MediaQuery.of(context).size.height * 0.05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThreeDList(
                                  threeD: threedList,
                                )));
                  },
                  child: Card(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "3D Result Lists",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(">>>", style: Theme.of(context).textTheme.headline5)
                    ],
                  )),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HteeList(
                                  title: "တစ်ရက်စာ",
                                  image: luckynumber['image'],
                                  date: luckynumber['date'],
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Card(
                      child: Center(
                          child: Text(
                        "တစ်ရက်စာ",
                        style: Theme.of(context).textTheme.headline5,
                      )),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HteeList(
                                  title: "တစ်ပတ်စာ",
                                  image: luckynumber['number'],
                                  date: luckynumber['date'],
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Card(
                        child: Center(
                            child: Text(
                      "တစ်ပတ်စာ",
                      style: Theme.of(context).textTheme.headline5,
                    ))),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget liveTwoDWidget() {
    return Container(
      margin: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.25,
      child: Card(
        child: Center(
            child: StreamBuilder(
                stream: ApiProvider().twodLiveData(),
                builder: (_, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            animatedText(
                                "* LIVE", Theme.of(context).textTheme.button)
                          ],
                        ),
                        Expanded(
                          child: animatedText(snapshot.data['result'],
                              Theme.of(context).textTheme.headline1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            animatedText(
                                "Sett", Theme.of(context).textTheme.bodyText1),
                            animatedText(
                                "Value", Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            animatedText(snapshot.data['sett'],
                                Theme.of(context).textTheme.bodyText2),
                            animatedText(snapshot.data['value'],
                                Theme.of(context).textTheme.bodyText2),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Image.asset(
                    'assets/images/loading.gif',
                    width: 70,
                    height: 70,
                    color: Colors.green,
                  );
                })),
      ),
    );
  }

  AnimatedTextKit animatedText(String text, TextStyle? textStyle) {
    return AnimatedTextKit(
      repeatForever: true,
      animatedTexts: [
        FlickerAnimatedText(text.toString(),
            entryEnd: 0.0, speed: Duration(seconds: 1), textStyle: textStyle),
      ],
      onTap: () {
        print("Click Event");
      },
    );
  }
}
