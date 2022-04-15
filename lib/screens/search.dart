import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/screens/loader.dart';
import 'package:weather_app/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Map<String, dynamic> data;
  Map<String, dynamic> forecast;
  String city;
  bool showSpinner = false;

  Future getWeatherOfCity() async {
    if (city == "" || city == null) {
      return;
    }
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=36891560b96f6d92de4896361eadc34a&units=metric');
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      forecast = await getForecastOfCity();
      Navigator.pushNamed(context, '/home',
          arguments: ScreenArguments(data, forecast));
      showSpinner = false;
    } else {
      print(response.statusCode);
    }
  }

  Future getForecastOfCity() async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=36891560b96f6d92de4896361eadc34a&units=metric');
    if (response.statusCode == 200) {
      return (jsonDecode(response.body));
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.blue[800],
            Colors.blue[700],
            Colors.blue[600],
            Colors.blue[400],
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Search your city weather",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20.0,
              )),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/weather.png',
                          height: 60.0,
                          width: 60.0,
                          color: Colors.black,
                        ),
                        Text('Weather Forecast', style: kSearchText),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              city = value;
                            },
                            style: kInputText,
                            decoration: InputDecoration(
                              hintText: 'What is your city ?',
                              hintStyle: kInputText,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showSpinner = true;
                            });
                            getWeatherOfCity();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            height: 35.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.teal[300],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              'Search',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu', color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
