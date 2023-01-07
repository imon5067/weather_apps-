import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_application_final_project/Screens/main_screen.dart';
import 'package:flutter_application_final_project/Screens/device_api_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: "Weather App",
    initialRoute: '/main',
    routes: {
      '/main': ((context) => const MainScreen()),
      '/deviceapi': ((context) => const DeviceApiScreen()),
    },
  ));
}
