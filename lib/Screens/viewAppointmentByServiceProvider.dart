import 'package:covac/Services/appointmentHelper.dart';
import 'package:covac/Services/bookingHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewOwnedAppointmentByServiceProvider extends StatefulWidget {
  const ViewOwnedAppointmentByServiceProvider({Key? key}) : super(key: key);

  @override
  State<ViewOwnedAppointmentByServiceProvider> createState() =>
      _ViewOwnedAppointmentByServiceProvider();
}

class _ViewOwnedAppointmentByServiceProvider
    extends State<ViewOwnedAppointmentByServiceProvider> {
  List allAppointments = [];
  List appointmentList = [];

  final searchController = TextEditingController();

  int primaryColor = 0xFF0075E7;

  @override
  void initState() {
    super.initState();
    loadAppointmentData();
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
        body: Container(
          child: Column(children: [
            const SizedBox(height: 5),
            const Text(
              "Browse all your appointments ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextFormField(
                onChanged: searchVaccinationCentre,
                controller: searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    hintText: 'Search . . . ',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 128, 128, 128)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search_outlined),
                      onPressed: () {},
                    ),
                    iconColor: Colors.black,
                    filled: true,
                    fillColor: const Color.fromARGB(255, 230, 230, 230)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: appointmentList.length,
                  itemBuilder: (context, int index) => appointmentList[index]
                          ['booked']
                      ? generateBookedCard(index)
                      : generateNonBookedCard(index)),
            ),
          ]),
        ));
  }

  String getInitialName(String name) {
    final splitted = name.split(' ');
    String initials = '';
    int counter = 0;
    int requiredChar = 2;
    for (var element in splitted) {
      if (counter < requiredChar) {
        initials = initials + element[0].toUpperCase();
      }
      counter++;
    }
    return initials;
  }

  Widget generateBookedCard(int index) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.maps_home_work_outlined,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    appointmentList[index]['vaccination']['name'],
                    style: TextStyle(fontSize: 20),
                  ),
                  // Text(appointmentList[index]['appointDateAndTime']),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.map_fill,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${appointmentList[index]['vaccination']['postCode'].toString().toUpperCase()}, ${appointmentList[index]['vaccination']['streetAddress']}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  // Text(appointmentList[index]['appointDateAndTime']),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.calendar,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    appointmentList[index]['appointDateAndTime'].split(' ')[0],
                    style: const TextStyle(
                        fontSize: 15, fontStyle: FontStyle.italic),
                  ),

                  const SizedBox(width: 25),

                  const Icon(
                    CupertinoIcons.clock,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    appointmentList[index]['appointDateAndTime'].split(' ')[1],
                    style: const TextStyle(
                        fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                  // Text(appointmentList[index]['appointDateAndTime']),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'This appointment has been boooked already',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget generateNonBookedCard(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 5),
      child: Card(
        color: Colors.amber[50],
        child: Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),

          // startActionPane: ActionPane(
          //   // A motion is a widget used to control how the pane animates.
          //   motion: ScrollMotion(),
          //   // A pane can dismiss the Slidable.
          //   dismissible: DismissiblePane(onDismissed: () {}),
          //   // All actions are defined in the children parameter.
          //   children: [
          //     // A SlidableAction can have an icon and/or a label.
          //     SlidableAction(
          //       onPressed: doNothing,
          //       backgroundColor: Color(0xFFFE4A49),
          //       foregroundColor: Colors.white,
          //       icon: Icons.delete,
          //       label: 'Delete',
          //     ),
          //     SlidableAction(
          //       onPressed: doNothing,
          //       backgroundColor: Color(0xFF21B7CA),
          //       foregroundColor: Colors.white,
          //       icon: Icons.share,
          //       label: 'Share',
          //     ),
          //   ],
          // ),

          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  deleteAppointMentData(appointmentList[index]['_id']);
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                // label: 'Delete',,
              ),
            ],
          ),

          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.maps_home_work_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        appointmentList[index]['vaccination']['name'],
                        style: TextStyle(fontSize: 20),
                      ),
                      // Text(appointmentList[index]['appointDateAndTime']),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.map_fill,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${appointmentList[index]['vaccination']['postCode'].toString().toUpperCase()}, ${appointmentList[index]['vaccination']['streetAddress']}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      // Text(appointmentList[index]['appointDateAndTime']),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.calendar,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        appointmentList[index]['appointDateAndTime']
                            .split(' ')[0],
                        style: const TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),

                      const SizedBox(width: 25),

                      const Icon(
                        CupertinoIcons.clock,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        appointmentList[index]['appointDateAndTime']
                            .split(' ')[1],
                        style: const TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      // Text(appointmentList[index]['appointDateAndTime']),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  openActionDialouge() async {
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
              // Navigator.of(context, rootNavigator: true).pop();
              // logoutUser();
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

  void searchVaccinationCentre(String searchQuery) {
    final suggestionsList = allAppointments.where((appointments) {
      final wholeAdress = appointments['appointDateAndTime'].toLowerCase() +
          ' ' +
          appointments['vaccination']['name'];

      return wholeAdress.contains(searchQuery.toLowerCase());
    }).toList();

    setState(() {
      appointmentList = suggestionsList;
    });
  }

  void loadAppointmentData() async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? userid = sharedPreferenceUserData.getString("_id");

    AppointmentHelper helper = AppointmentHelper();
    var data = await helper.getLoggedInUserAppointmentData(userid!);
    for (var i = 0; i < data['data'].length; i++) {
      allAppointments.add(data['data'][i]);
    }

    if (mounted) {
      setState(() {
        appointmentList = allAppointments;
      });
    }
  }

  deleteAppointMentData(appointmenId) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));

    AppointmentHelper appointmentHelper = AppointmentHelper();
    try {
      var responseData =
          await appointmentHelper.removeappointment(appointmenId);

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
