import 'package:flutter/material.dart';
import './category_picker.dart';
import './schedule_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.indigo[400],
          child: TabBar(
            indicatorColor: Colors.pink[600],
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  FontAwesomeIcons.tasks,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SchedulePage(),
            CategoryPicker(),
          ],
        ),
      ),
    );
  }
}
