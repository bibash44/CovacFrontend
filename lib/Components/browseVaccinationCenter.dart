import 'dart:math';

import 'package:covac/Models/vaccinationCentre.dart';
import 'package:covac/Screens/bookAppointmentBySeeker.dart';
import 'package:covac/Services/vaccinationHelper.dart';
import 'package:flutter/material.dart';

class BrowseVaccinationCenter extends StatefulWidget {
  const BrowseVaccinationCenter({Key? key}) : super(key: key);

  @override
  State<BrowseVaccinationCenter> createState() =>
      _BrowseVaccinationCenterState();
}

class _BrowseVaccinationCenterState extends State<BrowseVaccinationCenter> {
  List<VaccinationCentre> allVaccinationCentre = [];

  List<VaccinationCentre> vaccinationCentreList = [];

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadVaccinationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(children: [
        const SizedBox(height: 20),
        const Text(
          "Browse vaccination centre",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(15),
          child: TextFormField(
            onChanged: searchVaccinationCentre,
            controller: searchController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                hintText: 'Enter your post code or street address . . .',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 128, 128, 128)),
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
              itemCount: vaccinationCentreList.length,
              itemBuilder: (context, int index) =>
                  generateCard(context, index)),
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

  Widget generateCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // print(vaccinationCentreList[index].id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BookAppointmentBySeeker(vaccinationCentreList[index])));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.5, horizontal: 8.0),
        width: double.infinity,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)]),
                    child: Text(
                      getInitialName(vaccinationCentreList[index].name!),
                      style: const TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vaccinationCentreList[index].name!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          "${vaccinationCentreList[index].postCode!}, ${vaccinationCentreList[index].streetAddress!}",
                          style: const TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchVaccinationCentre(String searchQuery) {
    final suggestionsList = allVaccinationCentre.where((vacCentre) {
      final wholeAdress =
          "${vacCentre.postCode!}${vacCentre.streetAddress!}".toLowerCase();

      return wholeAdress.contains(searchQuery.toLowerCase());
    }).toList();

    setState(() {
      vaccinationCentreList = suggestionsList;
    });
  }

  void loadVaccinationData() async {
    VaccinationHelper helper = VaccinationHelper();
    var data = await helper.getVaccinationCenterData();
    for (var i = 0; i < data['data'].length; i++) {
      allVaccinationCentre.add(VaccinationCentre(
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
        vaccinationCentreList = allVaccinationCentre;
      });
    }
  }
}
