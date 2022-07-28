import 'package:covac/Components/serviceProviderProfile.dart';
import 'package:covac/Components/serviceSeekerProfile.dart';
import 'package:covac/Screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isUserLoggedIn = false;
  bool isUserServiceProvider = true;
  String userId = "";
  String fullname = "";
  String phonenumber = "";
  String email = "";
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return isUserLoggedIn
        ? Column(
            children: [
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'images/profile.png',
                            fit: BoxFit.cover,
                            width: 70,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // user fullname
                        Center(
                          child: Text("Hello $fullname",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(FontAwesomeIcons.user),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              fullname,
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),

                        // User email
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.email_outlined),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              email,
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "+44 $phonenumber",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                child: isUserServiceProvider
                    ? const ServiceProviderProfile()
                    : const ServiceSeekerProfile(),
              ),
            ],
          )
        // ignore: sized_box_for_whitespace
        : Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Center(
                  child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  child: const Text(
                    "Please login to continue",
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Signin()));
                  },
                ),
              )),
            ),
          );
  }

  getUserLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? _isUserLoggedIn = sharedPreferences.getBool("_isUserLoggedIn");
    bool? _isUserServiceProvider =
        sharedPreferences.getBool("isUserServiceProvider");

    String? _userId = sharedPreferences.getString("_id");
    String? _fullname = sharedPreferences.getString("_fullname");
    String? _phonenumber = sharedPreferences.getString("_phone");
    String? _email = sharedPreferences.getString("_email");

    setState(() {
      isUserLoggedIn = _isUserLoggedIn!;
      isUserServiceProvider = _isUserServiceProvider!;
      userId = _userId!;
      fullname = _fullname!;
      phonenumber = _phonenumber!;
      email = _email!;
    });
  }

  getLoggedInUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (this.mounted) {
      setState(() {});
    }
  }
}
