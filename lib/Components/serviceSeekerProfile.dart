import 'package:covac/Screens/bookAppointmentBySeeker.dart';
import 'package:covac/Screens/registration.dart';
import 'package:covac/Screens/signin.dart';
import 'package:covac/Screens/viewBookingsByServiceSeeker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceSeekerProfile extends StatefulWidget {
  const ServiceSeekerProfile({Key? key}) : super(key: key);

  @override
  _ServiceSeekerProfileState createState() => _ServiceSeekerProfileState();
}

class _ServiceSeekerProfileState extends State<ServiceSeekerProfile> {
  bool isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    child: const Text(
                      "View my bookings",
                      style: TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ViewOwnedBookingByServiceSeeker()));
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    child: const Text(
                      "Make booking ",
                      style: TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                    },
                  ),
                ),

                // view restaurant
                const SizedBox(height: 10),
              ],
            )),
      ),
    );
  }
}
