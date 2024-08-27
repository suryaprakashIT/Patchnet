import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';



// Future<Map<String, dynamic>> fetchData() async {
//   String url = 'http://192.168.43.254:5000/predict';
//   print('hi-==========================================================');
//   try {
//     print("gjffkkgkgulgljglglgkglugkulglgljglgl");
//     var response = await http.get(Uri.parse(url));
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       print(json.decode(response.body));
//
//
//
//       // Map<String, List<Map<String, dynamic>>> clusters = {"Cluster -1": [{"networkSpeed": 628.5214954813159, "SimName": "Jio", "latitude": 11.0200643, "longitude": 76.9337782, "Cluster": -1}, {"networkSpeed": 272.87, "SimName": "Jio", "latitude": 11.0182482, "longitude": 76.9335272, "Cluster": -1}, {"networkSpeed": 126.56, "SimName": "Jio", "latitude": 11.017953, "longitude": 76.9361287, "Cluster": -1}, {"networkSpeed": 392.48, "SimName": "Jio", "latitude": 11.0203949, "longitude": 76.938222, "Cluster": -1}, {"networkSpeed": 147.86, "SimName": "Jio", "latitude": 11.0178507, "longitude": 76.9358002, "Cluster": -1}, {"networkSpeed": 473.95, "SimName": "Jio", "latitude": 11.0189506, "longitude": 76.9360012, "Cluster": -1}, {"networkSpeed": 370.69, "SimName": "Jio", "latitude": 11.0172422, "longitude": 76.9344581, "Cluster": -1}, {"networkSpeed": 318.18, "SimName": "Jio", "latitude": 11.0206718, "longitude": 76.933202, "Cluster": -1}, {"networkSpeed": 451.87, "SimName": "Jio", "latitude": 11.019653, "longitude": 76.9350976, "Cluster": -1}, {"networkSpeed": 51.1, "SimName": "Jio", "latitude": 11.0206848, "longitude": 76.9353314, "Cluster": -1}, {"networkSpeed": 240.14, "SimName": "Jio", "latitude": 11.0190295, "longitude": 76.9347361, "Cluster": -1}, {"networkSpeed": 422.07, "SimName": "Jio", "latitude": 11.0185548, "longitude": 76.9333379, "Cluster": -1}, {"networkSpeed": 12.98, "SimName": "Jio", "latitude": 11.0198259, "longitude": 76.9378487, "Cluster": -1}, {"networkSpeed": 399.56, "SimName": "Jio", "latitude": 11.0180608, "longitude": 76.9348204, "Cluster": -1}, {"networkSpeed": 16.48, "SimName": "Jio", "latitude": 11.0200872, "longitude": 76.9340748, "Cluster": -1}, {"networkSpeed": 592.68, "SimName": "Jio", "latitude": 11.0205603, "longitude": 76.9356147, "Cluster": -1}, {"networkSpeed": 143.84, "SimName": "Jio", "latitude": 11.0173378, "longitude": 76.9376654, "Cluster": -1}, {"networkSpeed": 253.86, "SimName": "Jio", "latitude": 11.0175666, "longitude": 76.9387577, "Cluster": -1}, {"networkSpeed": 298.3685211922475, "SimName": "Jio", "latitude": 11.0174936, "longitude": 76.9392747, "Cluster": -1}], "Cluster 0": [{"networkSpeed": 250.63480989347232, "SimName": "Jio", "latitude": 11.0206498, "longitude": 76.9349576, "Cluster": 0}, {"networkSpeed": 183.43476927220496, "SimName": "Jio", "latitude": 11.0212012, "longitude": 76.9339085, "Cluster": 0}, {"networkSpeed": 199.44797601914942, "SimName": "Jio", "latitude": 11.0206498, "longitude": 76.9349576, "Cluster": 0}], "Cluster 1": [{"networkSpeed": 217.54, "SimName": "Jio", "latitude": 11.0186149, "longitude": 76.9372974, "Cluster": 1}, {"networkSpeed": 273.84, "SimName": "Jio", "latitude": 11.0186555, "longitude": 76.9362142, "Cluster": 1}, {"networkSpeed": 223.17, "SimName": "Jio", "latitude": 11.0193583, "longitude": 76.938115, "Cluster": 1}, {"networkSpeed": 106.49, "SimName": "Jio", "latitude": 11.019133, "longitude": 76.9389629, "Cluster": 1}], "Cluster 2": [{"networkSpeed": 401.94415656887753, "SimName": "Jio", "latitude": 11.0209957, "longitude": 76.9349576, "Cluster": 2}, {"networkSpeed": 373.52, "SimName": "Jio", "latitude": 11.0209545, "longitude": 76.9358873, "Cluster": 2}, {"networkSpeed": 397.05, "SimName": "Jio", "latitude": 11.0200434, "longitude": 76.9365775, "Cluster": 2}], "Cluster 3": [{"networkSpeed": 491.68, "SimName": "Jio", "latitude": 11.0178833, "longitude": 76.9377848, "Cluster": 3}, {"networkSpeed": 572.39, "SimName": "Jio", "latitude": 11.0182308, "longitude": 76.9384031, "Cluster": 3}, {"networkSpeed": 421.85, "SimName": "Jio", "latitude": 11.017516, "longitude": 76.9380221, "Cluster": 3}]};
//       Map<String, List<Map<String, dynamic>>> clusters =json.decode(response.body);
//       print("sdfsdf");
//       print(clusters);
//       print("sdfsdfsdfsd");
//       List<Map<int, List<LatLng>>> fetcheddata=[];
//       clusters.forEach((key, value) {
//         int index = int.parse(key.split(" ")[1]);
//
//         Map<int, List<LatLng>> clusterData = {};
//         for (var data in value) {
//           int clusterIndex = data["Cluster"];
//           clusterData.putIfAbsent(clusterIndex, () => []);
//           clusterData[clusterIndex]?.add(LatLng(data["latitude"].toDouble(), data["longitude"].toDouble()));
//         }
//         // print("Cluster Data: $clusterData");
//         fetcheddata.add(clusterData);
//       });
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   } catch (e) {
//     throw Exception('Failed to connect to the server$e');
//   }
// }
