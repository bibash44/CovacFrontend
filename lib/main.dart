import 'package:covac/Components/browseVaccinationCenter.dart';
import 'package:covac/Components/map.dart';
import 'package:covac/Components/profile.dart';
import 'package:covac/Screens/registration.dart';
import 'package:covac/Screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covac',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int primaryColor = 0xFF0075E7;
  int _index = 1;

  var bottomNavigationPages = [
    const Map(),
    const BrowseVaccinationCenter(),
    const Profile()
  ];

  bool isUserLoggedIn = false;

  // var profile = isUserLoggedIn ? UserProfile() : AdminProfile();
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(primaryColor)),
      home: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: const Text(
            "Covac",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            isUserLoggedIn
                ? IconButton(
                    onPressed: () {
                      openLogoutDialouge();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.powerOff,
                      size: 20,
                      color: Colors.black,
                    ))
                : IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    icon: const Icon(
                      Icons.supervised_user_circle_sharp,
                      size: 20,
                      color: Colors.black,
                    )),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Color(primaryColor),
              hoverColor: Color(0xFF7C7C7C),
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 200),
              tabBackgroundColor: Color(primaryColor),
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.map_rounded,
                  text: 'Map',
                ),
                GButton(
                  icon: Icons.search_outlined,
                  text: 'Browse',
                ),
                GButton(
                  icon: FontAwesomeIcons.userAlt,
                  text: 'Account',
                ),
              ],
              selectedIndex: _index,
              onTabChange: (index) {
                setState(() {
                  _index = index;
                });
              },
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            child: bottomNavigationPages[_index]),
      ),
    );
  }

  openLogoutDialouge() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              logoutUser();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  logoutUser() async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    sharedPreferenceUserData.setString("_id", "");
    sharedPreferenceUserData.setString("_fullname", "");
    sharedPreferenceUserData.setString("_email", "");
    sharedPreferenceUserData.setString("_phone", "");
    sharedPreferenceUserData.setString("_dob", "");
    sharedPreferenceUserData.setBool("_isUserLoggedIn", false);

    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Signin()));
  }

  getUserLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? _isUserLoggedIn = sharedPreferences.getBool("_isUserLoggedIn");

    setState(() {
      isUserLoggedIn = _isUserLoggedIn!;
    });
  }
}
