import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:twodthreed/config/global/app_config.dart';

class ApiProvider with ChangeNotifier {
  Stream twodLiveData() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      try {
        final response = await http.post(
          Uri.parse(API.livetwod),
          headers: {
            "Accept": "application/json",
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${Token.privateToken}',
          },
        );
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          // notifyListeners();
          yield data;
        } else {
          throw 'Failed to load LiveTwodData';
        }
      } on FormatException catch (e) {
        print("FormatException" + e.toString());
        throw "Service link's name is not correct !";
      } on TimeoutException catch (e) {
        print("TimeOutExecption" + e.toString());
        throw "Can not connect right now !";
      } on SocketException catch (e) {
        print("SocketException" + e.toString());
        throw "Can not connect right now.Please try again later !";
      } catch (e) {
        print("LiveTwoD Error");
        throw e.toString();
      }
    }
  }

  Future apiData(String link) async {
    try {
      final response = await http.post(
        Uri.parse(link),
        headers: {
          "Accept": "application/json",
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${Token.privateToken}',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        notifyListeners();
        return data;
      } else {
        throw 'Failed to load ApiData';
      }
    } on FormatException catch (e) {
      print("FormatException" + e.toString());
      throw "Service link's name is not correct !";
    } on TimeoutException catch (e) {
      print("TimeOutExecption" + e.toString());
      throw "Can not connect right now !";
    } on SocketException catch (e) {
      print("SocketException" + e.toString());
      throw "Can not connect right now.Please try again later !";
    } catch (e) {
      print("Api Error");
      throw e.toString();
    }
  }
}
