import 'package:covac/Services/bookingHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewOwnedBookingByServiceSeeker extends StatefulWidget {
  const ViewOwnedBookingByServiceSeeker({Key? key}) : super(key: key);

  @override
  State<ViewOwnedBookingByServiceSeeker> createState() =>
      _ViewOwnedBookingByServiceSeeker();
}

class _ViewOwnedBookingByServiceSeeker
    extends State<ViewOwnedBookingByServiceSeeker> {
  List allBookings = [];
  List bookingList = [];

  final searchController = TextEditingController();

  int primaryColor = 0xFF0075E7;

  @override
  void initState() {
    super.initState();
    loadBookingData();
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
              "Browse all your bookings ",
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
                  itemCount: bookingList.length,
                  itemBuilder: (context, int index) => generateCard(index)),
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

  Widget generateCard(int index) {
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
                    bookingList[index]['vaccination']['name'],
                    style: TextStyle(fontSize: 20),
                  ),
                  // Text(bookingList[index]['appointDateAndTime']),
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
                    '${bookingList[index]['vaccination']['postCode'].toString().toUpperCase()}, ${bookingList[index]['vaccination']['streetAddress']}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  // Text(bookingList[index]['appointDateAndTime']),
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
                    bookingList[index]['appointment']['appointDateAndTime']
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
                    bookingList[index]['appointment']['appointDateAndTime']
                        .split(' ')[1],
                    style: const TextStyle(
                        fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                  // Text(bookingList[index]['appointDateAndTime']),
                ],
              ),
            ],
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
    final suggestionsList = allBookings.where((bookings) {
      final wholeAdress =
          bookings['appointment']['appointDateAndTime'].toLowerCase() +
              ' ' +
              bookings['vaccination']['name'];

      return wholeAdress.contains(searchQuery.toLowerCase());
    }).toList();

    setState(() {
      bookingList = suggestionsList;
    });
  }

  void loadBookingData() async {
    final sharedPreferenceUserData = await SharedPreferences.getInstance();

    String? userid = sharedPreferenceUserData.getString("_id");

    BookingHelper helper = BookingHelper();
    var data = await helper.getLoggedInUserBookingData(userid!);
    for (var i = 0; i < data['data'].length; i++) {
      allBookings.add(data['data'][i]);
    }

    if (mounted) {
      setState(() {
        bookingList = allBookings;
      });
    }
  }
}
