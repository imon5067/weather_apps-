import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:permission_handler/permission_handler.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double? latitude = 0;
  double? longitude = 0;
  String? myLocation = " ";
  String? cityName = "Helsinki";
  String description = "Suny";
  double temperature = 0;
  double wind = 0;
  final record = TextEditingController();
  String? searchR = '';

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
        myLocation = "${place.locality}, ${place.country}";
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
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        description = weatherData["weather"][0]["description"];
        temperature = weatherData["main"]["temp"];
        wind = weatherData["wind"]["speed"];
      });
    } else {}
  }

  void fetchcity() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$searchR&units=metric&appid=26bcb6dfb4cf05b2e96f6791e362e83a'));
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        description = weatherData["weather"][0]["description"];
        temperature = weatherData["main"]["temp"];
        wind = weatherData["wind"]["speed"];
      });
    } else {}
  }

  void openApiPage() {
    Navigator.pushNamed(context, '/deviceapi');
  }

  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Project"),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Lat: ${latitude}",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              "Lon: $longitude",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              myLocation!,
              style: const TextStyle(fontSize: 30),
            ),
            Text(cityName!, style: const TextStyle(fontSize: 40)),
            Text(description, style: const TextStyle(fontSize: 30)),
            Text('$temperature °C', style: const TextStyle(fontSize: 30)),
            Text('$wind km/h', style: const TextStyle(fontSize: 30)),
            Text(searchR!, style: const TextStyle(fontSize: 30)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: record,
                decoration: const InputDecoration(
                  hintText: "Search a city",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    cityName = record.text;
                  });
                  fetchWeather();
                },
                child: Text(
                  "Seach",
                  style: const TextStyle(fontSize: 20),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  startLocation();
                },
                child: Text(
                  "Update",
                  style: const TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20), // Set padding
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  openApiPage();
                },
                child: Text(
                  "Sensore",
                  style: const TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }

  void present() {}
}
