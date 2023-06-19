import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var loation = "";
  var adress = "";


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> GetAddressFromlatlon(Position position) async{

    List<Placemark> placemark =  await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemark);

    Placemark place = placemark[0];
    // print(place);
    setState(() {
      adress = " Street = ${place.street} \n Sub-locality : ${place.subLocality} \n Code : ${place.postalCode} \n  Country : ${place.country}";
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Coordinates Points',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              Text('Null Press Button',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),),
              SizedBox(
                height: 5,
              ),
              Text('ADDRESS',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(onPressed: () async {
                Position position = await _determinePosition();
                // print(position.latitude);
                // print(position.longitude);
                print(position);

                GetAddressFromlatlon(position);
                setState(() {
                  loation = "Lat : ${position.latitude}, Long : ${position.longitude} ";
                });

              },
                  child: Text('Get Location',
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),)),
              SizedBox(
                height: 10,
              ),
              Text('${loation}',style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              ),),
              Text('${adress}',style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
