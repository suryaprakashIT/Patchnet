import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
// import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MAP.dart';
import 'cell_info_service.dart'; // Import your Dart class
// import 'cluster.dart';
import 'cluster_map.dart';
import 'location_service.dart'; // Import LocationService
import 'dart:math';
import 'package:flogger/flogger.dart';
import 'firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'netspeed.dart';
import 'netspeed.dart';
import 'netspeed.dart'; // Import your Dart class




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final netspeed = NetworkSpeedMonitor(onUpdateSpeed: (speed) {
  //   print(speed);




  // Assuming you have the list populated




  // Create an instance of FirebaseService




  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(

        primaryColor: Colors.black,
        // primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.grey),
        // You can set your primary color here
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF001D3D), // Set the background color of the AppBar
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24, // Adjust the font size as needed
            fontWeight: FontWeight.bold,// Set the text color of the title
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black), // Set the background color of ElevatedButton
            textStyle: MaterialStateProperty.all(TextStyle(color: Colors.tealAccent)), // Set the text color
          ),
        ),
        // buttonTheme: ButtonThemeData(
        //   buttonColor: Colors.black,
        //   textTheme: ButtonTextTheme.primary,
        // ),
        // Add more customization as needed
      ),
      //   theme: ThemeData(
      //     primaryColor: Colors.teal, // Set primary color to teal
      //     hintColor: Colors.tealAccent, // Set accent color to teal (if needed)
      //     scaffoldBackgroundColor: Colors.teal, // Set scaffold background color to teal
      //     textTheme: const TextTheme(
      //       // Set the default text style to white
      //       bodyText1: TextStyle(color: Colors.white),
      //       bodyText2: TextStyle(color: Colors.white),
      //     ),
      //     drawerTheme: const DrawerThemeData(
      //       // Customize the drawer theme here
      //       // For example, set the background color of the drawer
      //       backgroundColor: Colors.teal,
      //       // textTheme: TextStyle(color: Colors.white), // Text color of drawer items
      //     ),
      //   ),
      home: Splash(),
    );
  }
}
class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Create an AnimationController with a duration of 4 seconds
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // Forward the animation to 1.0, which means a full 360-degree rotation
    _controller.forward();

    // Navigate to the next screen after the animation is complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width:40 ,),
                RotationTransition(
                  turns: _controller.view,

                  child:
                  Image.asset(
                    'images/backimage.png', // Replace with your image asset path
                    width: 100,
                    height: 100,
                  ),
                ),
                // SizedBox(height: 15),
                Text(
                  "PatchNET",
                  style: TextStyle(
                    fontSize: 44,
                    // color: Color(0xFF213E3B),
                    color: Color(0xFFB4FF00),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NovaSquare', // Set the font family
                  ),
                ),
              ],
            ),

            SizedBox(height: 100),
            // CupertinoActivityIndicator(
            //   color: Colors.white,
            // ),
            SizedBox(height: 320),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }
}

// class Splash extends StatefulWidget {
//   @override
//   State<Splash> createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 4), () {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => MyHomePage()));
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.teal, // Set the background color to teal
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "PatchNet",
//                   style: TextStyle(
//                     color: Colors.white, // Set the text color to white
//                     fontSize: 58, // Adjust the font size as needed
//                     fontWeight: FontWeight.bold, // Adjust the font weight as needed
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             CupertinoActivityIndicator(
//               color: Color.fromARGB(255, 0, 0, 0),
//             ),
//             SizedBox(
//               height: 350,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CellInfoService _cellInfoService = CellInfoService();
  final LocationService _locationService = LocationService();

  final FirebaseService _firebaseService = FirebaseService();
  final NetworkSpeedMonitor _networkSpeedService = NetworkSpeedMonitor();









  List<String> closeUserIds=[];

  Map<String, dynamic> towerLocation = {};
  Map<String, dynamic> cellInfo = {};
  Map<String, dynamic> Retervirdata = {};

  double userLat = 0.0;
  double userLng = 0.0;
  double nearbylat=0.0;
  double nearbylng=0.0;
  double netspeed=0.0;
  String Simname = "";
  double nearbyusernetworkspeed=0.0;

  static  String name = "";
  static  String Email = "";
  bool emailError = false;

  // String get userId => null;

  // TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // clearSharedPreferences();
    // getMobileNetworkSpeed();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // getMobileNetworkSpeed();
      userLocation();
    });
    // userLocation();
    // getinfo();
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      getMobileNetworkSpeed();
    });
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      userLocation();
      getinfo();
    });
    Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      calculateDistance();
    });
    // getinfo();

    checkFirstTime();
    loadmap();
  }
  Future<String> getsimname() async{
    return Simname;
  }

  Future<double> getMobileNetworkSpeed() async {

    final url = 'https://www.youtube.com';
    final startTime = DateTime.now();

    try {
      final response = await http.get(Uri.parse(url));
      final endTime = DateTime.now();

      final downloadTimeInSeconds = endTime.difference(startTime).inMilliseconds / 1000;
      final downloadSpeedKbpsValue = (response.contentLength! / downloadTimeInSeconds) / 1024;


      // netspeed = downloadSpeedKbpsValue;

      setState(() {
        netspeed = downloadSpeedKbpsValue;
        // _signalStrength = newSignalStrength;
      });
      print(netspeed);
      return netspeed;
      // onUpdateSpeed(downloadSpeed);
    } catch (e) {
      print('Error: $e');
      return  -1;
    }
  }

  Future<void> calculateDistance() async {
    // Ensure you have valid userLat, userLng, towerLocation['latitude'], and towerLocation['longitude'] values
    double userLatRadians = degreesToRadians(userLat);
    double userLngRadians = degreesToRadians(userLng);
    double towerLatRadians = degreesToRadians(towerLocation['latitude']);
    double towerLngRadians = degreesToRadians(towerLocation['longitude']);
    Map<String, dynamic> rertrivedata = {};


    double earthRadius = 6371.0; // Earth's radius in kilometers

    double dLat = towerLatRadians - userLatRadians;
    double dLng = towerLngRadians - userLngRadians;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(userLatRadians) * cos(towerLatRadians) * sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c; // Distance in kilometers
    setState(() {
      // Update the distance in the UI
      towerLocation['distance'] = distance;
    });
    // String userEmail = emailController.text;
    // print('User Email: $userEmail');
    // String modifiedEmail = userEmail.replaceAll('.com', '');
    // print('Modified Email: $modifiedEmail');
    // final networkSpeed = await _networkSpeedService.getMobileNetworkSpeed();
    // print('Mobile network speed: $networkSpeed kilobits per second');

    String userEmail = Email;
    print('User Email: $userEmail');
    String modifiedEmail = userEmail.replaceAll('.com', '');
    print('Modified Email: $modifiedEmail');
    // final networkSpeed = await _networkSpeedService.getMobileNetworkSpeed();
    final networkSpeed =  netspeed;

    print(networkSpeed);
    print('Mobile network speed: $netspeed kilobits per second');

    // print('hiiii');


    await _firebaseService.storeUserLocation(userLat, userLng,modifiedEmail,netspeed ,Simname);
    // await _firebaseService.calculateDistancesWithCondition();
    //
    // // Assuming you have the list populated
    // closeUserIds = _firebaseService.closeUserIds;
    //
    // // Call extractAndPrintLocations with the list of close user IDs
    // await extractAndPrintLocations(closeUserIds);


  }
  // Future<void> mapNearbyUser(String newuserId) async {
  //   List<String> newlistuser=['$newuserId'];
  //   try {
  //     Map<String, Map<String, double>> newuserLocations = await _firebaseService.extractLocations(newlistuser);
  //
  //     // Print user locations
  //     newuserLocations.forEach((userId, location) {
  //       print('User ID: $userId, Latitude: ${location['latitude']}, Longitude: ${location['longitude'] }, optimalnetworkspeed ${location['usernetworkSpeed']}');
  //
  //       setState(() {
  //         nearbylat=location['latitude']!;
  //         nearbylng=location['longitude']!;
  //       });
  //
  //     });
  //
  //
  //   } catch (e) {
  //     print('Error extracting and printing locations: $e');
  //   }
  //
  // }
  Future<void> mapNearbyUser(String newuserId) async {
    List<String> newlistuser = ['$newuserId'];
    try {
      Map<String, dynamic> fetchedData = Retervirdata ;

      // Extracting user IDs from fetched data
      List<String> userIDs = fetchedData.keys.toList();
      print(userIDs); // Print user IDs

      // Assuming you want to set nearbylat and nearbylng based on the first user's location
      if (fetchedData.containsKey(newuserId)) {
        Map<String, dynamic> userData = fetchedData[newuserId];
        print(userData['latitude']);
        print(userData['longitude']);

        setState(() {
          // Set state variables with the retrieved latitude and longitude
          // You might need to use the actual setState method from your Flutter widget
          nearbylat = userData['latitude'];
          nearbylng = userData['longitude'];
          nearbyusernetworkspeed=userData['networkSpeed'];
        });
      } else {
        print('User ID not found in fetched data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  Future<void> extractAndPrintLocations(List<String> userIds) async {
    try {
      Map<String, Map<String, double>> userLocations = await _firebaseService.extractLocations(userIds);

      // Print user locations
      userLocations.forEach((userId, location) {
        print('User ID: $userId, Latitude: ${location['latitude']}, Longitude: ${location['longitude'] }, optimalnetworkspeed ${location['usernetworkSpeed']}');
      });

    } catch (e) {
      print('Error extracting and printing locations: $e');
    }

  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
    // ... (Your existing code for calculating distance)
  }
  Future<void> userLocation() async{
    final userLocation = await _locationService.getCurrentLocation();

    if (userLocation.isNotEmpty) {
      userLat = userLocation['latitude'];
      userLng = userLocation['longitude'];


      print('User Location Latitude: $userLat');
      print('User Location Longitude: $userLng');
      // calculateDistance();

    } else {
      print('User location not available.');
    }

  }
  Future<void> getinfo() async {



    //GETINFO-------------------------------------
    try {

      cellInfo = await _cellInfoService.getCellInfo(); // Store cellInfo here
      if (cellInfo is Map<String, dynamic>) {
        // Now you have MNC, MCC, LAC, and Cell ID values in cellInfo
        print('MNC: ${cellInfo['mnc']}');
        print('MCC: ${cellInfo['mcc']}');
        print('LAC: ${cellInfo['tac'] ?? "Unknown"}'); // Use null check for LAC
        print('CID: ${cellInfo['cid'] ?? "Unknown"}');
        print('sim_operator_name: ${cellInfo['sim_operator_name'] ?? "Unknown"}');
        print('signal_strength: ${cellInfo['signal_strength'] ?? "Unknown"}');
        // Use null check for CID
        Simname = cellInfo['sim_operator_name'] ?? "Unknown" ;

      } else {
        print('Error: Unexpected response format');
      }
    } catch (e) {
      print('Error: $e');
    }



  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  Future<void> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;

    if (isFirstTime) {
      // Show the sign-in dialog
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Sign In",style: TextStyle(
              fontSize: 25,
              color: Color(0xFF5FF4EE),
              fontWeight: FontWeight.bold,
              fontFamily: 'NovaSquare', // Set the font family
            ),),
            content: Container(
              width: 150,
              height: 150,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF5FF4EE),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NovaSquare',),),
                    onChanged: (value) {
                      setState(() {
                        name = value; // Update the 'name' variable
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF5FF4EE),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NovaSquare',// Set the font family
                      ),),
                    onChanged: (value) {
                      setState(() {
                        Email = value; // Update the 'userEmail' variable
                        emailError = !Email.toLowerCase().endsWith("@gmail.com");
                        // Set the email error flag based on the condition
                      });
                    },
                  ),
                  if (emailError)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Please enter a valid Gmail address",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (!emailError) {
                    // Save the fact that the user has signed in
                    prefs.setBool('first_time', false);
                    // You can use 'name' and 'userEmail' variables as needed
                    // Store the email permanently
                    prefs.setString('user_email', Email);
                    prefs.setString('user_name', name);
                    // You can use 'name' and 'userEmail' variables as needed
                    print("Name: $name, Email: $Email");
                    // print("Name: $name, Email: $Email");
                    Navigator.of(context).pop();
                  } else {
                    // Show an error message if there's an issue
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fix the errors before signing in.",style: TextStyle(color: Colors.red),),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text("Sign In",style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF5FF4EE),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NovaSquare', // Set the font family
                ),),
              ),
              ElevatedButton(
                onPressed: () {
                  // User clicked cancel
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel",style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF5FF4EE),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NovaSquare', // Set the font family
                ),),
              ),
            ],
          );
        },
      );
    } else {
      // Retrieve the stored email
      String storedEmail = prefs.getString('user_email') ?? "";
      String storedName = prefs.getString('user_name') ?? "";
      setState(() {
        Email = storedEmail;
        name = storedName;
      });
    }
  }

  Future<Expanded> loadmap() async{
    return
      // print('nearby======================='+'$nearbylat'+'$nearbylng');
      Expanded(
        flex: 1,
        child: MapView(
          userLat: userLat,
          userLng: userLng,
          towerLat: (towerLocation?['latitude'] ?? 0.0) as double,
          towerLng: (towerLocation?['latitude'] ?? 0.0) as double,
          nearbylng: nearbylat,
          nearbylat: nearbylng,
          nearby_user_netspeed: nearbyusernetworkspeed,
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PatchNET  '+ '   ${Simname}:'+'${netspeed.toStringAsFixed(2)}kbps',
          style: TextStyle(
            fontSize: 22,
            color: Color(0xFF5FF4EE),
            fontWeight: FontWeight.bold,
            fontFamily: 'NovaSquare', // Set the font family
          ),),
      ),
      drawer: buildDrawer(),
      body: Stack(
        // child:
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: (userLat == null || userLng == null || towerLocation['latitude'] == null || towerLocation['longitude'] == null)
                ? const CircularProgressIndicator()
                :
            Expanded(
              child: MapView(
                userLat: userLat,
                userLng: userLng,
                towerLat: towerLocation['latitude'] ,
                towerLng: towerLocation['longitude'],
                nearbylat: nearbylat,
                nearbylng: nearbylng,
                nearby_user_netspeed: nearbyusernetworkspeed,
              ),
            ),
          ),


          const SizedBox(
              height: 400,
              width: 180),
          // Positioned(
          //   bottom: 60.0,
          //   left: 250.0,
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       // Call fetchData() when the button is pressed
          //       List<Map<int, List<LatLng>>> fetchedData = await _firebaseService.fetchData();
          //
          //       // Do something with the retrieved data
          //       if (fetchedData != null) {
          //         // Handle the retrieved data
          //         print('Retrieved Data: $fetchedData');
          //       } else {
          //         // Handle if fetching data failed
          //         print('Failed to fetch data');
          //       }
          //     },
          //     child: Text('Cluster'),
          //   ),
          // ),
          Positioned(
            top:50.0,
            left:15.0,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapSample()),
                );
              },
              child: const Text('Hotspot',style: TextStyle(
                fontSize: 22,
                color: Color(0xFF5FF4EE),
                fontWeight: FontWeight.bold,
                fontFamily: 'NovaSquare', // Set the font family
              ),),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: ElevatedButton(
              onPressed: () async {
                try {

                  loadmap();
                  towerLocation = await _cellInfoService.getTowerLocation(cellInfo);
                  if (towerLocation.isNotEmpty) {
                    print('Latitude: ${towerLocation['latitude']}');
                    print('Longitude: ${towerLocation['longitude']}');
                    calculateDistance();
                    // await _firebaseService.getUsersWithSameProvider();

                  } else {
                    print('Tower location not available.');
                  }


                } catch (e) {
                  print('Error retrieving tower location: $e');
                }
              },
              child: const Text('Get Tower Location',style: TextStyle(
                fontSize: 15,
                color: Color(0xFF5FF4EE),
                fontWeight: FontWeight.bold,
                fontFamily: 'NovaSquare', // Set the font family
              ),),
            ),

          ),
          Positioned(
            bottom: 20.0,
            left: 190.0,
            child: ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> fetchedData = await _firebaseService.fetchData();

                // Do something with the retrieved data
                if (fetchedData != null) {
                  // Handle the retrieved data
                  print('Retrieved Data: $fetchedData');
                  Retervirdata = fetchedData;
                  closeUserIds = List<String>.from(fetchedData.keys);
                  print(closeUserIds);
                } else {
                  // Handle if fetching data failed
                  print('Failed to fetch data');
                }
                // // Call calculateDistancesBetweenUsers() when the button is pressed
                // await _firebaseService.calculateDistancesWithCondition();
                //
                // // Assuming you have the list populated
                //  closeUserIds = _firebaseService.closeUserIds;
                //
                // // Call extractAndPrintLocations with the list of close user IDs
                // await extractAndPrintLocations(closeUserIds);
                // loadmap();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return getUserlocation();
                  },
                );
              },
              child: const Text('Nearbyuser',style: TextStyle(
                fontSize: 15,
                color: Color(0xFF5FF4EE),
                fontWeight: FontWeight.bold,
                fontFamily: 'NovaSquare', // Set the font family
              ),),
            ),
          ),
        ],

      ),
    );
  }


  // Widget getUserlocation() {
  //   List<String> additionalInfoList = closeUserIds; // Replace this with your list
  //
  //   List<Widget> options = additionalInfoList.take(5).map((info) {
  //
  //     return
  //
  //       SimpleDialogOption(
  //       onPressed: () {
  //         // Handle the option press as needed
  //         mapNearbyUser(info);
  //         print('Selected: $info==========================================================================================');
  //         loadmap();
  //         Navigator.of(context).pop(); // Close the dialog
  //       },
  //       child: Text(info),
  //     );
  //   }).toList();
  //
  //   return AlertDialog(
  //     title: Text('Cell Info Details'),
  //     content: Container(
  //       width: 100, // Adjust the width as needed
  //       height: 210,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: options,
  //       ),
  //     ),
  //     contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(12.0)),
  //     ),
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         child: Text('Close'),
  //       ),
  //     ],
  //   );
  // }

  Widget getUserlocation() {
    List<String> additionalInfoList = closeUserIds; // Replace this with your list

    List<Widget> options;

    if (additionalInfoList.isEmpty) {
      // Show a circular loading indicator if the list is empty
      options = [const CircularProgressIndicator()];
    } else {
      // Show SimpleDialogOption widgets for the first five items
      options = additionalInfoList.take(5).map((info) {
        return SimpleDialogOption(
          onPressed: () {
            // Handle the option press as needed
            mapNearbyUser(info);
            print('Selected: $info==========================================================================================');
            loadmap();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(info),
        );
      }).toList();
    }

    return AlertDialog(
      title: const Text('Cell Info Details',style: TextStyle(
        fontSize: 15,
        color: Color(0xFF5FF4EE),
        fontWeight: FontWeight.bold,
        fontFamily: 'NovaSquare', // Set the font family
      ),),
      content: Container(
        width: 100, // Adjust the width as needed
        height: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: options,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

          },


          child: const Text('Close',style: TextStyle(
            fontSize: 15,
            color: Color(0xFF5FF4EE),
            fontWeight: FontWeight.bold,
            fontFamily: 'NovaSquare', // Set the font family
          ),),
        ),
      ],
    );
  }


  Widget buildCellInfoDialog() {
    return AlertDialog(
      title: const Text('Cell Info Details',style: TextStyle(
        fontSize: 15,
        color: Color(0xFF5FF4EE),
        fontWeight: FontWeight.bold,
        fontFamily: 'NovaSquare',)),
      content: Container(
        width: 100, // Adjust the width as needed
        height: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildInfoRow('MNC', cellInfo['mnc']),
            buildInfoRow('MCC', cellInfo['mcc']),
            buildInfoRow('LAC', cellInfo['tac'] ?? 'Unknown'),
            buildInfoRow('CID', cellInfo['cid'] ?? 'Unknown'),
            buildInfoRow('SIM', cellInfo['sim_operator_name'].toString() ?? 'Unknown'),
            buildInfoRow('Signal Strength', cellInfo['signal_strength'].toString() ?? 'Unknown'),
            // print('sim_operator_name: ${cellInfo['sim_operator_name'] ?? "Unknown"}');
            // print('signal_strength: ${cellInfo['signal_strength'] ?? "Unknown"}');
            // Add more Text widgets for additional cell info details
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close',style: TextStyle(
            fontSize: 15,
            color: Color(0xFF5FF4EE),
            fontWeight: FontWeight.bold,
            fontFamily: 'NovaSquare',),
          ),)
      ],
    );
  }
  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF001D3D),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Cell Info Details',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 24,
                //   ),
                // ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle, // Add your user icon here
                      size: 40, // Adjust the size as needed
                      color: Colors.white,
                    ),
                    SizedBox(width:10),
                    Row(
                      children: [
                        Text(
                          '$name',
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF5FF4EE),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NovaSquare', // Set the font family
                          ),
                        ),

                      ],
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.email, // Use Icons.email for the email icon
                      size: 40, // Adjust the size as needed
                      color: Colors.white,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      '$Email',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF5FF4EE),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NovaSquare', // Set the font family

                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),

          ListTile(
            title: const Text('Cell Info',style: TextStyle(
              fontSize: 15,
              color: Color(0xFF5FF4EE),
              fontWeight: FontWeight.bold,
              fontFamily: 'NovaSquare', // Set the font family
            ),),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return buildCellInfoDialog();
                },
              );
            },
          ),

          ListTile(
            title: const Text('UserID',style: TextStyle(
              fontSize: 15,
              color: Color(0xFF5FF4EE),
              fontWeight: FontWeight.bold,
              fontFamily: 'NovaSquare', // Set the font family
            ),),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return getUserlocation();
                },
              );
            },
          ),
          // Add more ListTile widgets for additional cell info details
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF5FF4EE),
              fontWeight: FontWeight.bold,
              fontFamily: 'NovaSquare',

            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF5FF4EE),
              fontWeight: FontWeight.bold,
              fontFamily: 'NovaSquare',
            ),
          ),
        ],
      ),
    );
  }
}
