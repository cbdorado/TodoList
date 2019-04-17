import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main_model.dart';
import '../models/authentication.dart';
import '../pages/homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginMode _loginMode = LoginMode.Login;

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
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _confirmPasswordFormField() {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: "Confirm Password",
      ),
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }
      },
    );
  }

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
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 80.0),
              Column(
                children: <Widget>[
                  Icon(
                    Icons.dashboard,
                    size: 50.0,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "OnTime",
                    style: TextStyle(
                        fontSize: 32, color: Colors.yellowAccent[700]),
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
              FlatButton(
                child: Text(
                  'Switch to ${_loginMode == LoginMode.Login ? 'Signup' : 'Login'}',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    _loginMode = _loginMode == LoginMode.Login
                        ? LoginMode.Signup
                        : LoginMode.Login;
                  });
                },
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _usernameController.clear();
                      _passwordController.clear();
                    },
                  ),
                  ScopedModelDescendant<MainModel>(
                    builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return FlatButton(
                        child: Text(
                          'NEXT',
                          style: TextStyle(
                            color: Colors.yellowAccent[700],
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
    );;
  }
}