import 'dart:ffi';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceApiScreen extends StatefulWidget {
  const DeviceApiScreen({super.key});

  @override
  State<DeviceApiScreen> createState() => _DeviceApiScreenState();
}

class _DeviceApiScreenState extends State<DeviceApiScreen> {
  double xSensorValue = 0;
  double ySensorvalue = 0;
  double zSensorVAlue = 0;
  double? latitude = 0;
  double? longitude = 0;
  String? myLocation = " ";
  String? cityName = " ";
  String description = "Suny";
  double temperature = 0;
  double wind = 0;
  @override
  void initState() {
    super.initState();
    // startSensors();
    fetchWeather();
  }

  void startSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        xSensorValue = event.x;
        ySensorvalue = event.y;
        zSensorVAlue = event.z;
      });
    });
  }

  void startLocation() async {
    if (await Permission.location.request().isGranted) {
      Location location = new Location();
      location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          latitude = currentLocation.latitude;
          longitude = currentLocation.longitude;
          locationName();
        });
      });
    }
  }

  void locationName() async {
    try {
      List<geocode.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(latitude!, longitude!);

      geocoding.Placemark place = placemarks[0];

      setState(() {
        myLocation = "${place.locality}, ${place.postalCode}, ${place.country}";
        cityName = "${place.locality}";
        fetchWeather();
      });
    } catch (e) {
      print(e);
    }
  }

  void fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=26bcb6dfb4cf05b2e96f6791e362e83a'));
    // Uri uri = Uri.parse(
    //     'https://api.openweathermap.org/data/2.5/weather?q=turku&units=metric&appid=26bcb6dfb4cf05b2e96f6791e362e83a');
    // var response = await http.get(uri);
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        description = weatherData["weather"][0]["description"];
        temperature = weatherData["main"]["temp"];
        wind = weatherData["wind"]["speed"];
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sensor screem"),
        ),
        body: Column(
          children: [
            Text(
              "X: $xSensorValue",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              "Y: $ySensorvalue",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              "Z: $zSensorVAlue",
              style: const TextStyle(fontSize: 30),
            ),
            ElevatedButton(
                onPressed: () {
                  startSensors();
                },
                // ignore: prefer_const_constructors
                child: Text(
                  "Start sensor",
                  style: const TextStyle(fontSize: 20),
                )),
          ],
        ));
  }
}
