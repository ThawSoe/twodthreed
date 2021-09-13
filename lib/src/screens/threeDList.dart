import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twodthreed/config/provider/api_provider.dart';

class ThreeDList extends StatefulWidget {
  final List? threeD;
  ThreeDList({Key? key, this.threeD}) : super(key: key);

  @override
  _ThreeDListState createState() => _ThreeDListState();
}

class _ThreeDListState extends State<ThreeDList> {
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
          title: Text("3D Lists"),
          flexibleSpace: Container(
            decoration: decoration,
          ),
        ),
        body: Container(
          decoration: decoration,
          child: Consumer<ApiProvider>(builder: (_, apidata, widget) {
            return listWidget();
          }),
        ));
  }

  Widget listWidget() {
    return ListView.builder(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        itemCount: widget.threeD?.length,
        itemBuilder: (BuildContext context, index) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.10,
                child: Card(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Date",
                            style: Theme.of(context).textTheme.headline2),
                        Text(widget.threeD?[index]['date'],
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
                        Text(widget.threeD?[index]['number'],
                            style: Theme.of(context).textTheme.headline4)
                      ],
                    ),
                  ],
                )),
              )
            ],
          );
        });
  }
}
