import 'package:covac/Models/vaccinationCentre.dart';
import 'package:covac/Screens/bookAppointmentBySeeker.dart';
import 'package:covac/Services/vaccinationHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Set<Marker> _marker = {};

  List<LatLng> latLong = [];
  List locationData = [];
  late BitmapDescriptor customMapMarker;

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  void setCustomMarker() async {
    customMapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/covac_logo2.png");
  }

  void _onGoogleMapCreated(GoogleMapController controller) async {
    await fetchVaccinationCenters();
    setState(() {
      for (var i = 0; i < locationData.length; i++) {
        _marker.add(Marker(
            markerId: MarkerId(i.toString()),
            position: LatLng(double.parse(locationData[i].latitude),
                double.parse(locationData[i].longitude)),
            icon: customMapMarker,
            infoWindow: InfoWindow(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BookAppointmentBySeeker(locationData[i])));
                },
                title: locationData[i].name,
                // ignore: prefer_interpolation_to_compose_strings
                snippet: '${locationData[i].postCode.toUpperCase()}, ' +
                    locationData[i].streetAddress)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          child: GoogleMap(
              onMapCreated: _onGoogleMapCreated,
              markers: _marker,
              initialCameraPosition: const CameraPosition(
                  target: LatLng(52.418703305411334, -1.5151561216090441),
                  zoom: 15))),
    );
  }

  fetchVaccinationCenters() async {
    var data;
    VaccinationHelper vaccinationHelper = VaccinationHelper();
    data = await vaccinationHelper.getVaccinationCenterData();

    for (var i = 0; i < data['data'].length; i++) {
      locationData.add(VaccinationCentre(
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
        locationData = locationData;
      });
    }
  }
}
