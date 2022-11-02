import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/usermodel.dart';
import '../models/constants.dart';

Future<UserModel> getUser(String userName, String password) async {
  final String _url = Constants.apiUrl +
      "Authentication/GetUser?UserName=" +
      userName +
      "&Password=" +
      password;
  final response = await http.get(Uri.parse(_url));
  final responseJson = json.decode(response.body);

  return new UserModel.fromJson(responseJson);
}
