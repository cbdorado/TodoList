import 'package:flutter/material.dart';
import './category_picker.dart';
import './schedule_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../scoped-models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatelessWidget {
  // model instance variable passed through constructor
  final MainModel _model;
  HomePage(this._model);

  @override
  Widget build(BuildContext context) {
    // return Scoped Model Descendant to pass down data from model
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            // creates bottomappbar for tabs
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
            // tab bar view to hold 2 pages, the schedule page and category picker page
            body: TabBarView(
              children: <Widget>[
                SchedulePage(_model),
                CategoryPicker(),
              ],
            ),
          ),
        );
      },
    );
  }
}
