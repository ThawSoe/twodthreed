import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twodthreed/config/provider/api_provider.dart';
import 'package:twodthreed/src/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TwoDThreeD());
}

class TwoDThreeD extends StatelessWidget {
  const TwoDThreeD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Hi Guys 
    //Let is start
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ApiProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: ThemeData(
            primaryColor: Colors.yellow,
            textTheme: TextTheme(
                headline1: TextStyle(
                  fontSize: 100,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                headline2: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic),
                headline3: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                headline4: TextStyle(
                    fontSize: 19.5,
                    color: Colors.green,
                    fontWeight: FontWeight.w500),
                headline5: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                    fontWeight: FontWeight.w400),
                headline6: TextStyle(
                    fontSize: 27,
                    color: Colors.green,
                    fontWeight: FontWeight.w500),
                subtitle1: TextStyle(
                    fontSize: 20,
                    color: Colors.yellow[800],
                    fontWeight: FontWeight.w500),
                button: TextStyle(
                    fontSize: 16,
                    backgroundColor: Colors.red,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5),
                bodyText1: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300),
                bodyText2: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400))),
      ),
    );
  }
}
