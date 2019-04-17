import 'package:flutter/material.dart';
import './category_picker.dart';
import './schedule_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.amber[300],
          child: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.edit,
                  color: Colors.indigo[400],
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.schedule,
                  color: Colors.indigo[400],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CategoryPicker(),
            SchedulePage(),
          ],
        ),
      ),
    );
  }
}
