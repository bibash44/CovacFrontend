// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:covac/Components/profile.dart';
import 'package:covac/Services/vaccinationHelper.dart';
import 'package:covac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVaccinationCentre extends StatefulWidget {
  const AddVaccinationCentre({Key? key}) : super(key: key);

  @override
  State<AddVaccinationCentre> createState() => _AddVaccinationCentreState();
}

class _AddVaccinationCentreState extends State<AddVaccinationCentre> {
  final addVaccinationCentreFormKey = GlobalKey<FormState>();
  String? vaccinationCentreName,
      postCode,
      streetAddress,
      markDownDescription = '';

  double latitude = 0;
  double longitude = 0;

  bool isAddVaccinationCentreButtonDisbaled = true;
  bool isLoading = false;
  int primaryColor = 0xFF0075E7;

  TextEditingController markdownTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final appointDateFormat = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Color(primaryColor))),
      home: Scaffold(
        backgroundColor: Color(primaryColor),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Card(
                    elevation: 5,
                    child: Form(
                      key: addVaccinationCentreFormKey,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        child: Column(children: [
                          const Text(
                            "Add vaccination centre",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Vaccination centre name
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Vaccination centre name *";
                              } else if (!RegExp(
                                      r'^([A-Za-z]{1,16})([ ]{0,1})([A-Za-z]{1,16})?([ ]{0,1})?([A-Za-z]{1,16})?([ ]{0,1})?([A-Za-z]{1,16})')
                                  .hasMatch(value)) {
                                return "Please enter a valid name *";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            onSaved: (newValue) =>
                                vaccinationCentreName = newValue,
                            onChanged: (newValue) {
                              addVaccinationCentreFormKey.currentState!.save();
                              if (addVaccinationCentreFormKey.currentState!
                                  .validate()) {
                              } else {}
                            },
                            decoration: const InputDecoration(
                                labelText: "Vaccination centre name",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: Icon(Icons.home),
                                iconColor: Colors.black,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 192, 192, 192))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 230, 230, 230)),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter post code *";
                              } else if (!RegExp(
                                      r'^([A-Za-z][A-Ha-hJ-Yj-y]?[0-9][A-Za-z0-9]? ?[0-9][A-Za-z]{2}|[Gg][Ii][Rr] ?0[Aa]{2})$')
                                  .hasMatch(value)) {
                                return "Please enter a valid postal code *";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            onSaved: (newValue) => postCode = newValue,
                            onChanged: (newValue) {
                              addVaccinationCentreFormKey.currentState!.save();
                              if (addVaccinationCentreFormKey.currentState!
                                  .validate()) {
                              } else {}
                            },
                            decoration: const InputDecoration(
                                labelText: "Post code",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: Icon(Icons.maps_home_work),
                                iconColor: Colors.black,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 192, 192, 192))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 230, 230, 230)),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter full street address *";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            onSaved: (newValue) => streetAddress = newValue,
                            onChanged: (newValue) {
                              addVaccinationCentreFormKey.currentState!.save();
                              if (addVaccinationCentreFormKey.currentState!
                                  .validate()) {
                              } else {}
                            },
                            decoration: const InputDecoration(
                                labelText: "Street Address ",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: Icon(Icons.streetview_rounded),
                                iconColor: Colors.black,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 192, 192, 192))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 230, 230, 230)),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          MarkdownTextInput(
                            (String value) =>
                                setState(() => markDownDescription = value),
                            markDownDescription!,
                            label: 'Description',
                            maxLines: 5,
                            actions: MarkdownType.values,
                            controller: markdownTextController,
                            validators: (value) {
                              if (value == null || value == '') {
                                return 'Please enter description *';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          // AddVaccinationCentre button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(primaryColor),
                                padding: const EdgeInsets.all(15),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              onPressed: () async {
                                if (addVaccinationCentreFormKey.currentState!
                                    .validate()) {
                                  addVaccinationCentreFormKey.currentState!
                                      .save();
                                  var latlon = await getGeoLocation();
                                  addVaccinationCentre(
                                      vaccinationCentreName,
                                      postCode,
                                      streetAddress,
                                      markDownDescription,
                                      latlon['latitude'],
                                      latlon['longitude']);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // Calling user AddVaccinationCentre function to send user datas

                                }
                              },
                              child: isLoading
                                  ? const SpinKitCircle(
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : const Text(
                                      "Add vaccination centre",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // function to a vaccination center
  void addVaccinationCentre(
      name, postCode, street, description, latitude, longitude) async {
    // Calling method go get geolocation

    addVaccinationCentreFormKey.currentState!.save();

    VaccinationHelper vaccinationHelper = VaccinationHelper();
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? userid = sharedPreferenceUserData.getString("_id");

    try {
      var responseData = await vaccinationHelper.postVaccinationCenter(
          name, postCode, street, description, latitude, longitude, userid!);

      Fluttertoast.showToast(
          msg: responseData['msg'],
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      if (!responseData['success']) {
        setState(() {
          isLoading = false;
        });
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(
            context, MaterialPageRoute(builder: (context) => Profile()));
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<Map<String, double>> getGeoLocation() async {
    // convert user provided address to geo location i.e latitude and longitude
    List<Location> locations =
        await locationFromAddress("${streetAddress!} " " ${postCode!}");
    var jsonEncodedLocation = jsonEncode(locations);
    var jsonDecodedLocation = jsonDecode(jsonEncodedLocation);
    // print(jsonDecodedLocation[0]['latitude']);
    // print(jsonDecodedLocation[0]['longitude']);
    latitude = jsonDecodedLocation[0]['latitude'];
    longitude = jsonDecodedLocation[0]['longitude'];
    // setState(() {
    //   latitude = jsonDecodedLocation[0]['latitude'];
    //   longitude = jsonDecodedLocation[0]['longitude'];
    // });
    return {'latitude': latitude, 'longitude': longitude};
  }
}
