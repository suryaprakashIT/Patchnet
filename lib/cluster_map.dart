import 'dart:convert';
import 'dart:math';
import 'cell_info_service.dart';
import 'main.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'firebase_service.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}



class MapSampleState extends State<MapSample> {
  GoogleMapController? mapController;
  final FirebaseService _firebaseService = FirebaseService();
  final CellInfoService _cellInfoService = CellInfoService();

  final Map<int, Color> keyColorMap = {-1: Colors.red, 0: Colors.blue, 1: Colors.green, 2: Colors.yellow,3: Colors.orange};
  List<Map<int, List<LatLng>>> cordi=[];
  Map<int,double> avg={};
  Map<int, String> region_name = {-1: 'Region 0', 0:'Region 1', 1: 'Region 2', 2: 'Region 3',3: 'Region 3'};
  String usersimname=" ";
  Map<String, dynamic> cellInfo = {};

  @override
  void initState() {
getter();
  // fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HotSpots'),
      ),
      body:
      GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(11.0200643, 76.9337782),
          zoom: 14.0,
        ),
        markers: createMarkers(),
        // circles: createCircles(),
      ),
    );

  }
  Future<void> getter() async  {
    print("fdsfsdfs");
    final simname=_firebaseService.usersimname;
    cellInfo =  await _cellInfoService.getCellInfo();
    // print();
    setState(() {
      usersimname=cellInfo['sim_operator_name'];
    });
    fetchData();
  }

  Future<void> fetchData() async {
    print(usersimname);
    String url = 'https://patchnet-cm8h.onrender.com//predict?SimName=$usersimname';
print(Uri.parse(url));
    try {
      // print("gjffkkgkgulgljglglgkglugkulglgljglgl");
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));

        //===========================================================================================================
        Map<String, dynamic> clusters =json.decode(response.body);
        print(clusters);
        List<Map<int, List<LatLng>>> fetcheddata=[];
        clusters.forEach((key, value) {
          int index = int.parse(key.split(" ")[1]);

          Map<int, List<LatLng>> clusterData = {};
          for (var data in value) {

            int clusterIndex = data["Cluster"];
            avg[clusterIndex]=data['AverageNetworkSpeed'];
            clusterData.putIfAbsent(clusterIndex, () => []);
            clusterData[clusterIndex]?.add(LatLng(data["latitude"].toDouble(), data["longitude"].toDouble()));
          }
          // print("Cluster Data: $clusterData");
          fetcheddata.add(clusterData);
        });
        print(fetcheddata);
        setState(() {
          cordi=fetcheddata;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server$e');
    }
  }

  Set<Marker> createMarkers() {
    // getter();
    // print(cordi);
    Set<Marker> markers = {};
    for (final clusterData in cordi) {
      clusterData.forEach((key, value) {
        if (key!=-1) {
          value.forEach((coord) {
            markers.add(
              Marker(
                markerId: MarkerId(coord.toString()),
                position: coord,
                infoWindow: InfoWindow(
                  title: '${region_name[key]}',
                    snippet: 'AvgNetSpeed:${avg[key]?.toStringAsFixed(2)}'),

                icon: BitmapDescriptor.defaultMarkerWithHue(
                  getHueForClusterKey(key) as double,
                ),
              ),
            );
          });
        }
      });
      continue;
    }

    return markers;
  }


  double? getHueForClusterKey(int key) {
    // Use the color mapping, return null if key not found
    final Color? color = keyColorMap[key];
    if (color != null) {
      final HSLColor hslColor = HSLColor.fromColor(color);
      return hslColor.hue;
    }
    // return null;
  }

}
