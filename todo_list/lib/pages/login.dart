import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main_model.dart';
import '../models/authentication.dart';
import '../pages/homepage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  final MainModel model;
  LoginPage(this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  // username and password controller to connect with cancel button for clearing text in form
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // accesses the Stateful Widget's attributes
  LoginPage get widget => super.widget;

  // creating a map for the formData
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  // creating a global key of type FormState to validate and track inputted email and password
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // LoginMode enum to switch between signup and login
  LoginMode _loginMode = LoginMode.Login;

  // builds the password form field widget, obscures the
  // text and validates if the String value is empty or less that 6
  Widget _passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: "Password",
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      // saves the value to the form data map
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  // builds password confirmation form field when signing up
  Widget _confirmPasswordFormField() {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: "Confirm Password",
      ),
      obscureText: true,
      // validates whether the text connected to the controller is equal to the inputted String value
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }
      },
    );
  }

  // authenticates the user
  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    // checks login state
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _loginMode);
    if (successInformation['success']) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomePage(widget.model)));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An error has occured!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Okay',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.amber[500],
      body: SafeArea(
        child: Form(
          key: _formKey,
          // ListView wraps around email form field and password form field
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 80.0),
              Column(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.tasks,
                    size: 50.0,
                    color: Colors.indigo[300],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "OnTime",
                    style: TextStyle(fontSize: 32, color: Colors.indigo[300]),
                  ),
                ],
              ),
              SizedBox(
                height: 120.0,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Email",
                ),
                validator: (String value) {
                  if (value.isEmpty ||
                      !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                },
                onSaved: (String value) {
                  _formData['email'] = value;
                },
              ),
              // spacer
              SizedBox(
                height: 12.0,
              ),
              // [Password]
              _passwordFormField(),
              // Confirm Password
              _loginMode == LoginMode.Signup
                  ? _confirmPasswordFormField()
                  : Container(),
              SizedBox(
                height: 10.0,
              ),
              // button switches login modes
              FlatButton(
                child: Text(
                  'Switch to ${_loginMode == LoginMode.Login ? 'Signup' : 'Login'}',
                  style: TextStyle(color: Colors.black),
                ),
                // setState method rebuilds UI after next frame when build is called again
                onPressed: () {
                  setState(
                    () {
                      _loginMode = _loginMode == LoginMode.Login
                          ? LoginMode.Signup
                          : LoginMode.Login;
                    },
                  );
                },
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    // if the flat button is pressed, then the text for the email and password will clear
                    onPressed: () {
                      _usernameController.clear();
                      _passwordController.clear();
                    },
                  ),
                  ScopedModelDescendant<MainModel>(
                    builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return InputChip(
                        backgroundColor: Colors.pink[600],
                        label: Text(
                          'NEXT',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          _submitForm(model.authenticate);
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
