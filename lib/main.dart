import 'dart:io';
import 'package:barapp/pages/BarListPage.dart';
import 'package:flutter/material.dart';
import 'package:barapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:barapp/model/app.dart';
import 'package:barapp/objectbox.g.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

Store? store;
String? iosDeviceInfo;

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.ios,
  );
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  iosDeviceInfo = iosInfo.identifierForVendor;
  store = await openStore();
  SystemChrome.setPreferredOrientations([
    // 縦向き
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}
