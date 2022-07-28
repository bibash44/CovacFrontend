// ignore_for_file: unnecessary_brace_in_string_interps, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:covac/Screens/registration.dart';
import 'package:covac/Services/userHelper.dart';
import 'package:covac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Signin());
}

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool makePasswordVisible = false;
  final SigninFormKey = GlobalKey<FormState>();
  String? email, password;

  bool isSigninButtonDisbaled = true;
  bool isLoading = false;
  int primaryColor = 0xFF0075E7;

  double setScreenWidth = 0;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

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
                      key: SigninFormKey,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        child: Column(children: [
                          const Text(
                            "Signin",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Email form field for Signin

                          const SizedBox(height: 35),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              } else if (!RegExp(
                                      r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
                                  .hasMatch(value)) {
                                return "Please enter valid email";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) => email = newValue,
                            onChanged: (newValue) {
                              SigninFormKey.currentState!.save();
                              if (SigninFormKey.currentState!.validate()) {
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
                              SigninFormKey.currentState!.save();
                              if (SigninFormKey.currentState!.validate()) {
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
                          // Signin button
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
                                if (SigninFormKey.currentState!.validate()) {
                                  SigninFormKey.currentState!.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // Calling user Signin function to send user datas
                                  loginUser(email, password);
                                }
                              },
                              child: isLoading
                                  ? const SpinKitCircle(
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : const Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          const Text(
                            "Don't have a account ? ",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          InkWell(
                            child: Text(
                              "Click here to register ",
                              style: TextStyle(
                                  color: Color(primaryColor), fontSize: 18),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
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

  loginUser(email, password) async {
    try {
      var responseData = await UserHelper().loginUser(email, password);

      bool responseStatus = responseData['success'];
      if (responseStatus == true) {
        var userData = responseData['data'];
        String _id = userData['_id'];
        String _fullname = userData['fullname'];
        String _email = userData['email'];
        String _phonenumber = userData['phonenumber'];
        String _dob = userData['dob'];
        String usertype = userData['usertype'];

        saveUserData(_id, _fullname, _email, _phonenumber, _dob, usertype);

        setState(() {
          isLoading = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyHomePage()));
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

  saveUserData(_id, _fullname, _email, _phonenumber, _dob, usertype) async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    sharedPreferenceUserData.setString("_id", _id);
    sharedPreferenceUserData.setString("_fullname", _fullname);
    sharedPreferenceUserData.setString("_email", _email);
    sharedPreferenceUserData.setString("_phone", _phonenumber);
    sharedPreferenceUserData.setString("_dob", _dob);
    sharedPreferenceUserData.setString("usertype", usertype);
    sharedPreferenceUserData.setBool("_isUserLoggedIn", true);

    if (usertype == "Provider") {
      sharedPreferenceUserData.setBool("isUserServiceProvider", true);
    } else if (usertype == "Seeker") {
      sharedPreferenceUserData.setBool("isUserServiceProvider", false);
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
