import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:twodthreed/config/global/app_config.dart';
import 'package:twodthreed/config/provider/api_provider.dart';

class TwoDListPage extends StatefulWidget {
  final List? twoD;
  TwoDListPage({Key? key, this.twoD}) : super(key: key);

  @override
  _TwoDListPageState createState() => _TwoDListPageState();
}

class _TwoDListPageState extends State<TwoDListPage> {
  List twoDList = [];
  List twoDDisplyList = [];
  filterByDate(String date) async {
    Provider.of<ApiProvider>(context, listen: false)
        .apiData(API.domain + "api/twoddate/$date")
        .then((value) {
      print("This is my filterByDate");
      print(value);
      setState(() {
        // widget.twoD = widget.twoD?[0];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    twoDList = widget.twoD!;
    twoDDisplyList = widget.twoD!;
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
          title: Text("2D Lists"),
          flexibleSpace: Container(
            decoration: decoration,
          ),
        ),
        body: Container(
          decoration: decoration,
          child: Consumer<ApiProvider>(builder: (_, apidata, widget) {
            return Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'dd-MM-yyyy',
                    // initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.search),
                    dateHintText: "Search",
                    // dateLabelText: 'Date',
                    // timeLabelText: "Hour",
                    selectableDayPredicate: (date) {
                      // Disable weekend days to select from the calendar
                      if (date.weekday == 6 || date.weekday == 7) {
                        return false;
                      }
                      return true;
                    },
                    onChanged: (val) {
                      print("I got it");
                      final DateTime now = DateTime.parse(val);
                      final DateFormat formatter = DateFormat('dd.MM.yyyy');
                      final String formatted = formatter.format(now);
                      print(formatted);
                      setState(() {});
                      twoDDisplyList = [];
                      for (int i = 0; i < twoDList.length; i++) {
                        if (formatted == twoDList[i]['date']) {
                          print(twoDList[i]);
                          twoDDisplyList.add(twoDList[i]);
                        } else {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text(
                          //     "This date can not avaliable now !",
                          //   ),
                          //   backgroundColor: Colors.blueGrey,
                          //   elevation: 10,
                          //   behavior: SnackBarBehavior.floating,
                          // ));
                        }
                      }
                      // filterByDate(formatted);
                    },
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) {
                      print(val);
                    },
                  ),
                ),
                Expanded(child: listWidget()),
              ],
            );
          }),
        ));
  }

  Widget listWidget() {
    return ListView.builder(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        itemCount: twoDDisplyList.length,
        itemBuilder: (BuildContext context, index) {
          return Column(
            children: [
              Text(twoDDisplyList[index]['date']),
              Container(
                margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.20,
                child: Card(
                  child: Row(
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
                          Text(twoDDisplyList[index]['morningmodern'],
                              style: Theme.of(context).textTheme.headline3),
                          Text(twoDDisplyList[index]['eveningmodern'],
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
                          Text(twoDDisplyList[index]['morninginternet'],
                              style: Theme.of(context).textTheme.headline3),
                          Text(twoDDisplyList[index]['eveninginternet'],
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
                          Text(twoDDisplyList[index]['morningresult'],
                              style: Theme.of(context).textTheme.headline4),
                          Text(twoDDisplyList[index]['eveningresult'],
                              style: Theme.of(context).textTheme.headline4)
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
