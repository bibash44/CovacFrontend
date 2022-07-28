import 'dart:convert';

import 'package:covac/Services/BASEURL.dart';
import 'package:http/http.dart' as http;

class VaccinationHelper {
  final baseURL = BASEURL().getBasURL();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future postVaccinationCenter(
      String name,
      String postCode,
      String street,
      String description,
      double latitude,
      double longitude,
      String userid) async {
    var data = {
      'name': name,
      'postCode': postCode,
      'streetAddress': street,
      'description': description,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'user': userid,
    };

    try {
      http.Response response = await http.post(
          Uri.parse('${baseURL}vaccination/register'),
          body: jsonEncode(data),
          headers: requestHeaders);
      String responseData = response.body;
      var jsonDeocedResponse = jsonDecode(responseData);
      return jsonDeocedResponse;
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet.',
        'success': false
      };
      print(e);
      return responseData;
    }
  }

  Future getVaccinationCenterData() async {
    try {
      http.Response response =
          await http.get(Uri.parse('${baseURL}vaccination/getall'));
      String data = response.body;
      var jsonDeocedResponse = jsonDecode(data);
      return jsonDeocedResponse;
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet.',
        'success': false
      };
      print(e);
      return responseData;
    }
  }

  Future getLoggedInUserLoggedInData(String userid) async {
    var data = {
      'user': userid,
    };

    try {
      http.Response response = await http.post(
          Uri.parse('${baseURL}vaccination/loggedinuser'),
          body: jsonEncode(data),
          headers: requestHeaders);
      String responseData = response.body;
      var jsonDeocedResponse = jsonDecode(responseData);
      return jsonDeocedResponse;
    } catch (e) {
      var responseData = {
        'msg': '$e Error connecting to internet.',
        'success': false
      };
      print(e);
      return responseData;
    }
  }
}
