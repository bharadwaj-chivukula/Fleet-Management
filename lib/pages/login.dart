import 'package:flutter/material.dart';

import 'dart:async';
import 'package:http/http.dart';
import '../services/loginservice.dart';
import '../pages/dashboard.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  TextEditingController _usernamectrl = new TextEditingController();
  TextEditingController _passwordctrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: isLoading
            ? Center(
                child: new CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              )
            : new ListView(
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Image(
                          image: new AssetImage('images/pf_logo.png'),
                        ),
                        new Theme(
                          data: new ThemeData(
                            brightness: Brightness.light,
                          ),
                          // isMaterialAppTheme: true,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                              ),
                              new Form(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: new Column(
                                  children: <Widget>[
                                    new TextFormField(
                                      decoration: new InputDecoration(
                                          labelText: 'Enter UserId',
                                          fillColor: Colors.white),
                                      keyboardType: TextInputType.text,
                                      controller: _usernamectrl,
                                    ),
                                    new TextFormField(
                                      decoration: new InputDecoration(
                                          labelText: 'Enter Password',
                                          fillColor: Colors.white),
                                      obscureText: true,
                                      keyboardType: TextInputType.text,
                                      controller: _passwordctrl,
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                    ),
                                    new MaterialButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      splashColor: Colors.black,
                                      height: 40.0,
                                      minWidth: 150.0,
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Icon(Icons.forward),
                                          new Text('Login',
                                              style:
                                                  new TextStyle(fontSize: 20.0))
                                        ],
                                      ),
                                      onPressed: onLoginClick,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
  }

  Future<Null> _usernotFound() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) => new AlertDialog(
              title: new Text('Message'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text('Please verify username and password'),
                  ],
                ),
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void onLoginClick() {
    setState(() {
      isLoading = true;
    });

    getUser(_usernamectrl.text, _passwordctrl.text).then((loginuser) {
      isLoading = false;
      loginuser.emailId;
      loginuser.userName;
      loginuser.userId;
      if (loginuser != null &&
          loginuser.userId != null &&
          loginuser.userId > 0) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new DashboardPage(
                      title: "Dashboard",
                      userId: loginuser.userId,
                      orgId: loginuser.orgId,
                      userName: loginuser.userName,
                      emailId: loginuser.emailId,
                    )));
      } else {
        Future<Null> userinput = _usernotFound();
        userinput.then((temp) {
          setState(() {
            isLoading = false;
          });
        });
      }
    });
  }
}
