import 'dart:async';

import 'package:fleet_management/models/expensesum.dart';
import 'package:fleet_management/services/expenseservice.dart';
import 'package:flutter/material.dart';

import 'addexpense.dart';
import 'expensereport.dart';
import 'login.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage(
      {Key key,
      this.title,
      this.orgId,
      this.userId,
      this.userName,
      this.emailId})
      : super(key: key);
  final String title;
  final int orgId;
  final int userId;
  final String userName;
  final String emailId;
  @override
  DashboardPageState createState() => new DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  bool isLoading = false;
  Future<List<ExpenseSumModel>> _expenseSums;
  
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      _expenseSums = getExpenseSums(
        widget.orgId, widget.userId, DateTime.now().month);
    }

  @override
  Widget build(BuildContext context) {    

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.refresh), onPressed: () {
              setState(() {
              _expenseSums = getExpenseSums(
                widget.orgId, widget.userId, DateTime.now().month);
              });
            }),
          ],
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail:
                    new Text(widget.emailId != null ? widget.emailId : ""),
                accountName: new Text(widget.userName),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.red,
                    child: new Text(widget.userName.toString().substring(0, 1),
                        style: new TextStyle(fontSize: 30.0)),
                  ),
                ),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage('images/drawerbackground.jpg'),
                        fit: BoxFit.fill)),
              ),
              new ListTile(
                title: new Text('Add Expense'),
                trailing: new Icon(Icons.attach_money),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new AddExpensePage(
                            title: "Add Expense",
                            orgId: widget.orgId,
                            userId: widget.userId,
                            userName: widget.userName,
                            emailId: widget.emailId,
                          )));
                },
              ),
              new ListTile(
                  title: new Text("Expense Report"),
                  trailing: new Icon(Icons.alarm),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new ExpenseReport(
                              title: "Expense Report",
                              orgId: widget.orgId,
                              userId: widget.userId,
                              userName: widget.userName,
                              emailId: widget.emailId,
                            )));
                  }),
              new Divider(),
              new ListTile(
                title: new Text("Log Out"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new LoginPage()),
                      (Route<dynamic> route) => false);
                },
              ),
              Container(
                child: Image.asset('images/pf_logo.png'),
              ),
            ],
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              )
            : SafeArea(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: FutureBuilder<List<ExpenseSumModel>>(
                    future: _expenseSums,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: Colors.blueGrey,
                              child: Container(
                                padding: EdgeInsets.all(30.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                          snapshot.data
                                              .elementAt(index)
                                              .expenseType,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent
                                          )),
                                    ),
                                    Expanded(
                                      child: new Text(
                                          snapshot.data
                                              .elementAt(index)
                                              .amount
                                              .toString(),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                          )),
                                    ),
                                  ],
                                ),
                                // Column(
                                //   children: <Widget>[
                                //     Text(snapshot.data.elementAt(index).expenseType),
                                //     Padding(padding: EdgeInsets.only(top: 10.0),),
                                //     Text(snapshot.data.elementAt(index).amount.toString()),
                                //   ],
                                // ),
                              ),
                            );
                          },
                        );
                      } else if(snapshot.hasError) {
                        return Text(snapshot.error);
                      }
                      // By default, show a loading spinner
                      return new Center(
                        child: new CircularProgressIndicator(),
                      );
                    },
                  ),
                ),                
              ));
  }
}
