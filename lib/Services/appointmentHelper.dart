import 'dart:convert';

import 'package:covac/Services/BASEURL.dart';
import 'package:http/http.dart' as http;

class AppointmentHelper {
  final baseURL = BASEURL().getBasURL();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future postAppointment(String appointDateAndTime, String vaccinationCentreId,
      String userid) async {
    var data = {
      'appointDateAndTime': appointDateAndTime,
      'vaccination': vaccinationCentreId,
      'user': userid,
    };

    try {
      http.Response response = await http.post(
          Uri.parse('${baseURL}appointment/register'),
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

  Future getAppointmentData() async {
    try {
      http.Response response =
          await http.get(Uri.parse('${baseURL}Appointmentl'));
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

  Future getLoggedInUserAppointmentData(String userid) async {
    var data = {
      'user': userid,
    };

    try {
      http.Response response = await http.post(
          Uri.parse('${baseURL}appointment/loggedinuser'),
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

  Future getAppointmentByCenterData(String vaccinationCenterId) async {
    var data = {
      'vaccination': vaccinationCenterId,
    };

    try {
      http.Response response = await http.post(
          Uri.parse('${baseURL}appointment/getAppointmentByCenter'),
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

  Future removeappointment(String appointmentId) async {
    var data = {
      'appointment': appointmentId,
    };

    try {
      http.Response response = await http.delete(
          Uri.parse('${baseURL}appointment/removeappointment'),
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
