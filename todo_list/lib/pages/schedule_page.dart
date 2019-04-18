import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.amber[300],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'SCHEDULE',
            style: TextStyle(fontSize: 25.0),
          ),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.amber[300],
          
        ),
      ),
    );
  }
}
