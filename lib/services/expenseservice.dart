import 'dart:async';
import 'dart:convert';
import 'package:fleet_management/models/expensesum.dart';
import 'package:fleet_management/models/result.dart';

import 'package:http/http.dart' as http;

import 'package:fleet_management/models/constants.dart';
import 'package:fleet_management/models/expense.dart';

Future<List<ExpenseModel>> getExpenses(int orgId, int userId) async {
  final String _url = Constants.apiUrl +
      "Expense/GetExpenses/" +
      orgId.toString() +
      "/" +
      userId.toString();
  final response = await http.get(Uri.parse(_url));
  final responseJson = json.decode(response.body);

  List<ExpenseModel> expns = new List<ExpenseModel>();
  for (var expjson in responseJson) {
    expns.add(new ExpenseModel.fromJson(expjson));
  }
  return expns;
}

Future<ResultModel> saveExpense(ExpenseModel exp, String expdate) async {
  final String _url = Constants.apiUrl + "Expense/PostExpense";
  final response = await http.post(Uri.parse(_url), body: {
    "OrgId": exp.orgId.toString(),
    "ExpenseTypeId": exp.expenseTypeId.toString(),
    "DateOfTransaction": expdate,
    "Amount": exp.amount.toString(),
    "Notes": exp.notes,
    "CreatedBy": exp.userId.toString(),
    "VIN": exp.vin != null ? exp.vin : "",
    "Odometer":
        exp.odometerReading != null ? exp.odometerReading.toString() : "",
    "VehicleId": exp.vehicleId != null ? exp.vehicleId.toString() : '',
    "Quantity": exp.quantity != null ? exp.quantity.toString() : "",
  });
  final responseJson = json.decode(response.body);
  return ResultModel.fromJson(responseJson);
}

Future<List<ExpenseSumModel>> getExpenseSums(
    int orgId, int userId, int monthId) async {
  final _url = Constants.apiUrl +
      "expense/getexpensetypesum/" +
      orgId.toString() +
      "/" +
      userId.toString() +
      "/" +
      monthId.toString();
  final response = await http.get(Uri.parse(_url));
  final responseJson = json.decode(response.body);

  List<ExpenseSumModel> expsums = new List<ExpenseSumModel>();
  for (var expjson in responseJson) {
    expsums.add(new ExpenseSumModel.fromJson(expjson));
  }
  return expsums;
}
