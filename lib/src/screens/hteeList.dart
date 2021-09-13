import 'package:flutter/material.dart';
import 'package:twodthreed/config/global/app_config.dart';

class HteeList extends StatefulWidget {
  final String? title;
  final String? image;
  final String? date;
  HteeList({Key? key, this.title, this.image, this.date}) : super(key: key);

  @override
  _HteeListState createState() => _HteeListState();
}

class _HteeListState extends State<HteeList> {
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
        title: Text(widget.title.toString()),
        flexibleSpace: Container(
          decoration: decoration,
        ),
      ),
      body: Container(
        decoration: decoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                widget.date.toString(),
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Expanded(
                child: Image.network(
                  API.domain + "images/number/" + widget.image.toString(),
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fill,
                  colorBlendMode: BlendMode.darken,
                  loadingBuilder: (BuildContext context, widget, loading) {
                    if (loading == null) return widget;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loading.expectedTotalBytes != null
                            ? loading.cumulativeBytesLoaded /
                                loading.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, widget, _) {
                    return Text('😢');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
