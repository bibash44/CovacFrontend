import 'package:covac/Models/appointment.dart';
import 'package:covac/Screens/signin.dart';
import 'package:covac/Screens/viewBookingsByServiceSeeker.dart';
import 'package:covac/Services/appointmentHelper.dart';
import 'package:covac/Services/bookingHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointmentBySeeker extends StatefulWidget {
  var vaccinationCentreList;

  BookAppointmentBySeeker(this.vaccinationCentreList, {Key? key})
      : super(key: key);
  // const BookAppointmentBySeeker({Key? key}) : super(key: key);

  @override
  State<BookAppointmentBySeeker> createState() =>
      _BookAppointmentBySeekerState();
}

class _BookAppointmentBySeekerState extends State<BookAppointmentBySeeker> {
  int primaryColor = 0xFF0075E7;
  List allAppointments = [];
  List vaccinationCenter = [];
  bool isLoaded = false;

  bool isUserLoggedIn = false;
  bool isUserServiceProvider = false;
  String userId = "";
  String fullname = "";
  String phonenumber = "";
  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Color(primaryColor),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.home_outlined),
                                const SizedBox(
                                  width: 7.5,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    widget.vaccinationCentreList.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.blue),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(
                              width: 7.5,
                            ),
                            Text(
                              "${widget.vaccinationCentreList.postCode.toString().toUpperCase()}, ${widget.vaccinationCentreList.streetAddress}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Color.fromARGB(255, 147, 147, 147)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About vaccination center',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.vaccinationCentreList.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            isUserLoggedIn
                ? Container(
                    child: isUserServiceProvider
                        ? const SizedBox(
                            child: Text(
                              'OOPS SOORY , Service provider cannot make booking',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey),
                            ),
                          )
                        : Container(
                            child: allAppointments.isNotEmpty
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Available appointments',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: allAppointments.length,
                                              itemBuilder: (context,
                                                      int index) =>
                                                  generateCard(context, index),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    child: Text('No data available'),
                                  ),
                          ))
                : Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Center(
                          child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
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
                  )
          ],
        )
        // : const Center(child: SpinKitCircle(size: 50, color: Colors.blue))
        );
  }

  Widget generateCard(BuildContext context, int index) {
    final appointmentData = allAppointments[index];
    var parts = appointmentData['appointDateAndTime'].split(" ");
    String date = parts[0];
    var initTime = parts[1].split(":00");
    String time = initTime[0];

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 234, 234, 234),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.calendar,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 7.5,
                            ),
                            Text(date)
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.clock,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 7.5,
                            ),
                            Text(time)
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  appointmentData['booked']
                      ? Column(children: [
                          const Text('Already booked '),
                          InkWell(
                            child: Text(
                              "See your bookings",
                              style: TextStyle(color: Color(primaryColor)),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewOwnedBookingByServiceSeeker(),
                                  ));
                            },
                          )
                        ])
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () =>
                                  makeBooking(appointmentData['_id']),
                              child: const Text('Book')),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
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

    AppointmentHelper helper = AppointmentHelper();
    var data = await helper
        .getAppointmentByCenterData(widget.vaccinationCentreList.id);

    // print(data);

    try {
      for (var i = 0; i < data['data'].length; i++) {
        allAppointments.add(data['data'][i]);
      }
    } catch (e) {}

    if (mounted) {
      setState(() {
        allAppointments = allAppointments;
        vaccinationCenter = vaccinationCenter;
        isLoaded = true;
      });
    }
  }

  makeBooking(appointmentId) async {
    BookingHelper bookingHelper = BookingHelper();
    try {
      var responseData = await bookingHelper.postBooking(
          appointmentId, widget.vaccinationCentreList.id, userId);

      if (responseData['success']) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      }
      Fluttertoast.showToast(
          msg: responseData['msg'],
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER_LEFT,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
