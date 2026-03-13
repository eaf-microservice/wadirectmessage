import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wadirectmessage/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: const HomeScreen()),
  );
}
