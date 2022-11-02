import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:fleet_management/models/constants.dart';
import 'package:fleet_management/models/expensetype.dart';
import 'package:fleet_management/models/vehicleddmodel.dart';

List<ExpenseTypeModel> getStaticExpenseTypes() {
  List<ExpenseTypeModel> exptps = new List<ExpenseTypeModel>();
  exptps.add(
      new ExpenseTypeModel(id: 3, expenseType: 'Hamali', description: 'Fuel'));
  exptps.add(
      new ExpenseTypeModel(id: 4, expenseType: 'Fuel', description: 'Hamali'));
  exptps.add(new ExpenseTypeModel(
      id: 5, expenseType: 'Driver Batta', description: 'Driver Batta'));
  return exptps;
}

Future<List<ExpenseTypeModel>> getExpenseTypes(int orgId) async {
  final String _url =
      Constants.apiUrl + "Expense/GetExpenseTypes/" + orgId.toString();
  final response = await http.get(Uri.parse(_url));
  final responseJson = json.decode(response.body);

  List<ExpenseTypeModel> extps = new List<ExpenseTypeModel>();
  for (var extpjson in responseJson) {
    extps.add(new ExpenseTypeModel.fromJson(extpjson));
  }
  return extps;
}

Future<List<VehicleDdModel>> getVehicles(int orgId) async {
  final String _url =
      Constants.apiUrl + "Vehicle/GetVehicles/" + orgId.toString();
  print(_url);
  final response = await http.get(Uri.parse(_url));
  print(response.body);
  final responseJson = json.decode(response.body);

  List<VehicleDdModel> vehis = new List<VehicleDdModel>();
  for (var vejson in responseJson) {
    vehis.add(new VehicleDdModel.fromJson(vejson));
  }

  return vehis;
}
