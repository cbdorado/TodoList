import 'package:flutter/material.dart';
import './pages/homepage.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import './pages/login.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main_model.dart';
import './pages/todo_create.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.pink[600]);
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'TodoList',
        theme: _kTodoTheme,
        debugShowCheckedModeBanner: false,
        home: LoginPage(_model),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/todoCreate':
              return MaterialPageRoute(builder: (context) => TodoCreate());
              break;
            default:
              return MaterialPageRoute(builder: (context) => LoginPage(_model));
              break;
          }
        },
      ),
    );
  }
}

final ThemeData _kTodoTheme = _buildTodoTheme();

TextTheme _buildTodoTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        fontFamily: 'Nunito',
        displayColor: Colors.black,
        bodyColor: Colors.black,
      );
}

ThemeData _buildTodoTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      accentColor: Colors.pink[500],
      primaryColor: Colors.amber[300],
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: Colors.indigo[400],
        textTheme: ButtonTextTheme.normal,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textSelectionColor: Colors.pink[500],
      errorColor: Colors.red,
      textTheme: _buildTodoTextTheme(base.textTheme),
      primaryTextTheme: _buildTodoTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTodoTextTheme(base.accentTextTheme),
      primaryIconTheme: base.iconTheme.copyWith(
        color: Colors.black,
      ));
}
