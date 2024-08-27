import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cell_info_service.dart';
import 'location_service.dart';

class MapView extends StatefulWidget {
  final double userLat; // User's latitude
  final double userLng; // User's longitude
  final double towerLat; // Tower's latitude
  final double towerLng; // Tower's longitude
  final double nearbylat; // Tower's latitude
  final double nearbylng;
  final double nearby_user_netspeed;


  MapView({
    required this.userLat,
    required this.userLng,
    required this.towerLat,
    required this.towerLng,
    required this.nearbylat,
    required this.nearbylng,
    required this.nearby_user_netspeed,
  });

  @override
  _MapViewState createState() => _MapViewState();
}



class _MapViewState extends State<MapView> {
  late GoogleMapController _mapController;
  String tappedLocation = '';
  String tapLoc='' ;
  LatLng? tappedMarkerCoordinates;
  double netspeed=0.0;
  double actuladistance=0.0;


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void zoomToUserLocation() {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(widget.userLat, widget.userLng),
        15.0, // You can adjust the zoom level as needed
      ),
    );
  }


  void displayLocationInfo(double lat, double lng ,double net_speed, String locationType) {
    setState(() {
      // tappedLocation = 'Latitude: $lat\nLongitude: $lng';
      tapLoc = '$locationType\n';
      netspeed=net_speed;
      tappedMarkerCoordinates = LatLng(lat, lng); // Store tapped marker coordinates
    });
  }

  // double degreesToRadians(double degrees) {
  //   return degrees * (pi / 180.0);
  // }

  void calculateDistance() async {
    // Ensure you have valid userLat, userLng, towerLocation['latitude'], and towerLocation['longitude'] values

    double userLatRadians = widget.userLat * (pi / 180.0);
    double userLngRadians = widget.userLng * (pi / 180.0);
    double towerLatRadians = widget.nearbylat * (pi / 180.0);
    double towerLngRadians = widget.nearbylng * (pi / 180.0);
    Map<String, dynamic> rertrivedata = {};


    double earthRadius = 6371.0; // Earth's radius in kilometers

    double dLat = towerLatRadians - userLatRadians;
    double dLng = towerLngRadians - userLngRadians;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(userLatRadians) * cos(towerLatRadians) * sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c; // Distance in kilometers
    setState(() {
      // Update the distance in the UI
      actuladistance = distance;
      print(
          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$actuladistance");
    });
  }

    // double degreesToRadians(double degrees) {
    //   return degrees * (pi / 180.0);
    //   // ... (Your existing code for calculating distance)
    // }
  void clearTappedLocation() {
    setState(() {
      // tapLoc = null;
      netspeed=0.0;
      tappedMarkerCoordinates = null; // Clear tapped marker coordinates
    });
  }

  // double degreesToRadians(double degrees) {
  //   return degrees * (pi / 180.0);
  //   // ... (Your existing code for calculating distance)
  // }
    @override
    void initState() {
      super.initState();
      calculateDistance();
    }
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.userLat, widget.userLng),
            zoom: 9.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId('userMarker'),
              position: LatLng(widget.userLat, widget.userLng),
              onTap: () {
                // displayLocationInfo(LatLng(widget.userLat, widget.userLng));
                clearTappedLocation();
                calculateDistance();
                displayLocationInfo(widget.userLat, widget.userLng,0.0,'Your Location');
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),
            Marker(
              markerId: MarkerId('towerMarker'),
              position: LatLng(widget.towerLat, widget.towerLng),
              onTap: () {
                // displayLocationInfo(LatLng(widget.towerLat, widget.towerLng));
                clearTappedLocation();
                calculateDistance();
                displayLocationInfo(widget.towerLat, widget.towerLng,0.0,'Tower Location');
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
            Marker(
              markerId: MarkerId('nearbyuser'),
              position: LatLng(widget.nearbylat, widget.nearbylng),
              onTap: () {
                // displayLocationInfo(LatLng(widget.nearbylat, widget.nearbylng));
                clearTappedLocation();
                calculateDistance();
                displayLocationInfo(widget.nearbylat, widget.nearbylng,widget.nearby_user_netspeed,'Near by User');
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ),
          },
          circles: {
            Circle(
              circleId: CircleId('userCircle'),
              center: LatLng(widget.userLat, widget.userLng),
              radius: 150, // Adjust the radius as needed (in meters)
              strokeWidth: 2,
              strokeColor: Colors.blue.withOpacity(0.5),
              fillColor: Colors.blue.withOpacity(0.1),
            ),
            Circle(
              circleId: CircleId('towerCircle'),
              center: LatLng(widget.towerLat, widget.towerLng),
              radius:400 , // Adjust the radius as needed (in meters)
              strokeWidth: 2,
              strokeColor: Colors.red.withOpacity(0.5),
              fillColor: Colors.red.withOpacity(0.1),
            ),
          },
          onTap: (LatLng latLng) {
            clearTappedLocation();
          },
        ),
        if (tappedMarkerCoordinates != null) // Display coordinates only if a marker is tapped
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child:
              Text(
                '$tapLoc'!='Near by User'
                    ? '($tapLoc, ${tappedMarkerCoordinates!.latitude.toStringAsFixed(4)}, ${tappedMarkerCoordinates!.longitude.toStringAsFixed(4)}, $netspeed,$actuladistance)'
                    : '($tapLoc, ${tappedMarkerCoordinates!.latitude.toStringAsFixed(4)}, ${tappedMarkerCoordinates!.longitude.toStringAsFixed(4)},$actuladistance)',
                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
            ),
          ),
        Positioned(
          bottom: 110.0,
          right: 0.0,
          child:
          ElevatedButton(
            onPressed: zoomToUserLocation,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(1), backgroundColor: Colors.transparent, // Adjust padding as needed
              shape: CircleBorder(),),
            child: Icon(Icons.gps_fixed_outlined, color: Colors.greenAccent, ),
          ),
          // ElevatedButton(
          //       onPressed: zoomToUserLocation,
          //       child: Text('Zoom to User Location'),
          //     ),
        ),
        // Positioned(
        //   bottom: 20.0,
        //   right: 20.0,
        //   child: YourOverlayWidget2(),
        // ),




      ],
    );

    // Additional UI components go her
  }
}

