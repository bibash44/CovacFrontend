// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_new

import 'dart:convert';

import 'package:covac/Components/profile.dart';
import 'package:covac/Models/vaccinationCentre.dart';
import 'package:covac/Services/appointmentHelper.dart';
import 'package:covac/Services/vaccinationHelper.dart';
import 'package:covac/main.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment({Key? key}) : super(key: key);

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final addAppointmentFormKey = GlobalKey<FormState>();

  bool isAddAppointmentButtonDisbaled = true;
  bool isLoading = false;
  int primaryColor = 0xFF0075E7;

  TextEditingController markdownTextController = TextEditingController();

  List<VaccinationCentre> loggedInUserVaccinationCentreList = [];
  List<VaccinationCentre> vaccinationCentreList = [];

  VaccinationCentre? selectedVaccinationCentre;
  String? selectedVaccinationCentreName, selectedVaccinationCentreId;

  @override
  void initState() {
    super.initState();
    getLoggedInUserVaccinaationCentre();
  }

  final appointDateFormat = DateFormat("yyyy-MM-dd HH:mm");
  String? appointDateAndTime;

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
                      key: addAppointmentFormKey,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        child: Column(children: [
                          const Text(
                            "Add appointments ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Select your vaccination centre ",
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton<VaccinationCentre>(
                                hint: const Text(
                                    "Select your vaccination centre"),
                                value: selectedVaccinationCentre,
                                isExpanded: true,
                                iconSize: 30,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                onChanged:
                                    (VaccinationCentre? vaccinationCentre) {
                                  setState(() {
                                    selectedVaccinationCentre =
                                        vaccinationCentre;

                                    selectedVaccinationCentreName =
                                        selectedVaccinationCentre!.name;

                                    selectedVaccinationCentreId =
                                        selectedVaccinationCentre!.id;
                                  });
                                },
                                items: loggedInUserVaccinationCentreList
                                    .map((VaccinationCentre vaccinationCentre) {
                                  return DropdownMenuItem<VaccinationCentre>(
                                    value: vaccinationCentre,
                                    child:
                                        Text(vaccinationCentre.name.toString()),
                                  );
                                }).toList(),
                              )),

                          const SizedBox(
                            height: 20,
                          ),

                          DateTimeField(
                            format: appointDateFormat,
                            onSaved: (value) => setState(() {
                              appointDateAndTime = value.toString();
                            }),
                            validator: (value) {
                              if (value == null ||
                                  value == '' ||
                                  value == ' ') {
                                return 'Please select appointment date and time *';
                              }
                            },
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: DateTime.now(),
                                  lastDate: new DateTime(
                                      new DateTime.now().year + 1));

                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                            decoration: const InputDecoration(
                                labelText: "Appointment date and time ",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: Icon(Icons.date_range_outlined),
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

                          // AddAppointment button
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
                                if (addAppointmentFormKey.currentState!
                                    .validate()) {
                                  addAppointmentFormKey.currentState!.save();
                                  addAppointment();
                                }
                              },
                              child: isLoading
                                  ? const SpinKitCircle(
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : const Text(
                                      "Add appointment",
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

  // function to get logged in user vaccination center

  void getLoggedInUserVaccinaationCentre() async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? userid = sharedPreferenceUserData.getString("_id");
    VaccinationHelper helper = VaccinationHelper();

    var data = await helper.getLoggedInUserLoggedInData(userid!);
    for (var i = 0; i < data['data'].length; i++) {
      vaccinationCentreList.add(VaccinationCentre(
          data['data'][i]['_id'],
          data['data'][i]['name'],
          data['data'][i]['postCode'],
          data['data'][i]['streetAddress'],
          data['data'][i]['description'],
          data['data'][i]['latitude'],
          data['data'][i]['longitude']));
    }

    if (mounted) {
      setState(() {
        loggedInUserVaccinationCentreList = vaccinationCentreList;
        selectedVaccinationCentre = vaccinationCentreList[0];
        selectedVaccinationCentreName = vaccinationCentreList[0].name;
        selectedVaccinationCentreId = vaccinationCentreList[0].id;
      });
    }
  }

  // add appointment
  void addAppointment() async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();
    String? userid = sharedPreferenceUserData.getString("_id");

    AppointmentHelper appointmentHelper = AppointmentHelper();
    try {
      var responseData = await appointmentHelper.postAppointment(
          appointDateAndTime!, selectedVaccinationCentreId!, userid!);

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
}
