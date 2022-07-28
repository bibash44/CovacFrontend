// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'package:covac/Screens/signin.dart';
import 'package:covac/Services/userHelper.dart';
import 'package:covac/main.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Register());
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool makePasswordVisible = false;
  final registerFormKey = GlobalKey<FormState>();
  String? fullname,
      phonenumber,
      email,
      dob,
      password,
      cpassword,
      usertype = 'Seeker';

  bool isRegisterButtonDisbaled = true;
  bool isLoading = false;
  int primaryColor = 0xFF0075E7;

  double setScreenWidth = 0;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  final dobFormat = DateFormat("yyyy-MM-dd");

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
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
                      key: registerFormKey,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        child: Column(children: [
                          const Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Full name text field
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your name *";
                              } else if (!RegExp(
                                      r'^([A-Za-z]{1,16})([ ]{0,1})([A-Za-z]{1,16})?([ ]{0,1})?([A-Za-z]{1,16})?([ ]{0,1})?([A-Za-z]{1,16})')
                                  .hasMatch(value)) {
                                return "Please enter a valid name *";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            onSaved: (newValue) => fullname = newValue,
                            onChanged: (newValue) {
                              registerFormKey.currentState!.save();
                              if (registerFormKey.currentState!.validate()) {
                              } else {}
                            },
                            decoration: const InputDecoration(
                                labelText: "Fullname",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: Icon(Icons.person),
                                iconColor: Colors.black,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 192, 192, 192))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 230, 230, 230)),
                          ),

                          // Email form field for Register

                          const SizedBox(height: 35),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email *";
                              } else if (!RegExp(
                                      r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
                                  .hasMatch(value)) {
                                return "Please enter a valid email *";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) => email = newValue,
                            onChanged: (newValue) {
                              registerFormKey.currentState!.save();
                              if (registerFormKey.currentState!.validate()) {
                              } else {}
                            },
                            decoration: const InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: Icon(Icons.email_outlined),
                                iconColor: Colors.black,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 192, 192, 192))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 230, 230, 230)),
                          ),

                          // Phone number text field
                          const SizedBox(height: 35),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your phone number *";
                              } else if (!RegExp(r'^[0-9]{10}$')
                                  .hasMatch(value)) {
                                return "Please enter a valid phone number *";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            onSaved: (newValue) => phonenumber = newValue,
                            onChanged: (newValue) {
                              registerFormKey.currentState!.save();
                              if (registerFormKey.currentState!.validate()) {
                              } else {}
                            },
                            decoration: const InputDecoration(
                                labelText: "Phone number",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: Icon(Icons.phone),
                                iconColor: Colors.black,
                                prefixText: '+44',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 192, 192, 192))),
                                filled: true,
                                fillColor: Color.fromARGB(255, 230, 230, 230)),
                          ),

                          const SizedBox(height: 35),
                          DateTimeField(
                            format: dobFormat,
                            onSaved: (value) => setState(() {
                              dob = value.toString();
                            }),
                            validator: (value) {
                              if (value == null ||
                                  value == '' ||
                                  value == ' ') {
                                return 'Please enter DOB *';
                              }
                            },
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1990),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime.now());
                            },
                            decoration: const InputDecoration(
                                labelText: "Date of birth ",
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

                          // Input form passowrd field

                          const SizedBox(height: 35),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your password *";
                              } else if (!RegExp(r'^[A-Za-z0-9]+$')
                                  .hasMatch(value)) {
                                return " Please enter only number and letters *";
                              }
                              return null;
                            },
                            obscureText: !makePasswordVisible,
                            onSaved: (newValue) => password = newValue,
                            onChanged: (newValue) {
                              registerFormKey.currentState!.save();
                              if (registerFormKey.currentState!.validate()) {
                              } else {}
                            },
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                prefixIcon: const Icon(Icons.lock_open_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    makePasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      makePasswordVisible =
                                          !makePasswordVisible;
                                    });
                                  },
                                ),
                                iconColor: Colors.black,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 192, 192, 192),
                                  ),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 230, 230, 230)),
                          ),

                          const SizedBox(height: 35),
                          // Vaccination service provider or vaccination service seeker
                          const Text(
                            "Are you vaccine service provider or seeker ? ",
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                          const SizedBox(height: 5),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton<String>(
                                hint: const Text("Select usertype"),
                                value: usertype,
                                isExpanded: true,
                                iconSize: 30,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    usertype = newValue;
                                  });
                                },
                                items: <String>[
                                  'Seeker',
                                  'Provider',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )),

                          const SizedBox(height: 35),
                          // Register button
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
                              onPressed: () {
                                if (registerFormKey.currentState!.validate()) {
                                  registerFormKey.currentState!.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // Calling user register function to send user datas
                                  registerUser(fullname, email, phonenumber,
                                      dob, password, usertype);
                                }
                              },
                              child: isLoading
                                  ? const SpinKitCircle(
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : const Text(
                                      "Create account",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          const Text(
                            "Already a member ? ",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          InkWell(
                            child: Text(
                              "Click here to login ",
                              style: TextStyle(
                                  color: Color(primaryColor), fontSize: 18),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Signin()));
                            },
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

  registerUser(fullname, email, phonenumber, dob, password, usertype) async {
    try {
      var responseData = await UserHelper()
          .registerUser(fullname, email, phonenumber, dob, password, usertype);

      bool responseStatus = responseData['success'];
      if (responseStatus == true) {
        setState(() {
          isLoading = false;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Signin()));
        });
      } else if (responseStatus == false) {
        setState(() {
          isLoading = false;
        });
      }

      Fluttertoast.showToast(
          msg: responseData['msg'],
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  getUserLoggedInStatus() async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    bool? isUserLoggedIn = sharedPreferenceUserData.getBool("_isUserLoggedIn");

    if (isUserLoggedIn == true) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ));
    }
  }
}
