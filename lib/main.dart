import 'package:fleet_management/pages/login.dart';
import 'package:flutter/material.dart';

//import 'pages/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Expense Management',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
        accentColor: Colors.pink,
        backgroundColor: Colors.red,        

      ),
      // home: new DashboardPage(                
      //   orgId: 1,
      //   userId: 1,
      //   userName: "Ramesh",
      //   emailId: "ramesh.kaamarthi@perennialcode.com",
      // ),      
      home: new LoginPage(title: "Login Page",),      
    );
  }
}
  