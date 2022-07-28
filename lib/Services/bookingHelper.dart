import 'dart:convert';

import 'package:covac/Services/BASEURL.dart';
import 'package:http/http.dart' as http;

class BookingHelper {
  final baseURL = BASEURL().getBasURL();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future postBooking(
      String appointmentId, String vaccinationCentreId, String userid) async {
    var data = {
      'bookingDateAndTime': DateTime.now().toString(),
      'appointment': appointmentId,
      'vaccination': vaccinationCentreId,
      'user': userid,
    };

    try {
      http.Response response = await http.post(
          Uri.parse('${baseURL}booking/register'),
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

  Future getBookingData() async {
    try {
      http.Response response = await http.get(Uri.parse('${baseURL}Bookingl'));
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

  Future getLoggedInUserBookingData(String userid) async {
    var data = {
      'user': userid,
    };

    try {
      http.Response response = await http.post(
          Uri.parse('${baseURL}booking/loggedinuser'),
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
