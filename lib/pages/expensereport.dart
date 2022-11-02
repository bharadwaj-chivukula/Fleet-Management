import 'package:fleet_management/models/expense.dart';
import 'package:fleet_management/services/expenseservice.dart';
import 'package:fleet_management/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ExpenseReport extends StatefulWidget {
  ExpenseReport(
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
  ExpenseReportState createState() => ExpenseReportState();
}

class ExpenseReportState extends State<ExpenseReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<ExpenseModel>>(
        future: getExpenses(widget.orgId, widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child: new Container(
                    //padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.blueGrey,
                          child: new Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  snapshot.data
                                      .elementAt(index)
                                      .amount
                                      .toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 25.0, color: Colors.white),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data
                                      .elementAt(index)
                                      .expenseType
                                      .toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    toyyyyMMdd(snapshot.data
                                        .elementAt(index)
                                        .expenseDate),
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data.elementAt(index).vin != null
                                        ? snapshot.data
                                            .elementAt(index)
                                            .vin
                                            .toString()
                                        : "",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            snapshot.data.elementAt(index).notes != null
                                ? snapshot.data
                                    .elementAt(index)
                                    .notes
                                    .toString()
                                : "",
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
