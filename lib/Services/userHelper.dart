import 'package:covac/Services/BASEURL.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UserHelper {
  final baseURL = BASEURL().getBasURL();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future registerUser(String fullname, String email, String phonenumber,
      String dob, String password, String usertype) async {
    print('${baseURL}');

    var requestBody = jsonEncode({
      "fullname": fullname,
      "email": email,
      "phonenumber": phonenumber,
      "dob": dob,
      "password": password,
      "usertype": usertype
    });

    try {
      http.Response response = await http.post(Uri.parse('${baseURL}user'),
          body: requestBody, headers: requestHeaders);

      if (response.statusCode == 200) {
        String responseData = response.body;
        var jsonDeocedResponse = jsonDecode(
          responseData,
        );

        return jsonDeocedResponse;
      } else {}
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet ',
        'success': false
      };
      print(e);

      return responseData;
    }
  }

  Future loginUser(String email, String password) async {
    var requestBody = jsonEncode({"email": email, "password": password});

    try {
      http.Response response = await http.post(
          Uri.parse('${baseURL}user/login'),
          body: requestBody,
          headers: requestHeaders);

      if (response.statusCode == 200) {
        String responseData = response.body;
        var jsonDeocedResponse = jsonDecode(responseData);

        return jsonDeocedResponse;
      } else {}
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet ',
        'success': false
      };
      // ignore: avoid_print
      print(e);

      return responseData;
    }
  }
}
