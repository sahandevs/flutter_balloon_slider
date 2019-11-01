import 'package:flutter/material.dart';

import 'balloon_slider.dart';

void main() => runApp(MyApp());

const Color kBackgroundColor = Color.fromARGB(255, 243, 247, 252);
const Color kInactiveColor = Color.fromARGB(255, 200, 209, 233);
const Color kActiveColor = Color.fromARGB(255, 74, 15, 226);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: BalloonSlider(
          onChanged: (_value) => setState(() => value = _value),
          value: value,
          activeColor: kActiveColor,
          inactiveColor: kInactiveColor,
        ),
      ),
    );
  }
}
