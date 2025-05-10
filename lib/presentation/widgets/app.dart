import 'package:ecobici_plus/presentation/pages/list_stations.dart';
import 'package:flutter/material.dart';

class EcobiciPlusApp extends StatelessWidget {
  const EcobiciPlusApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecobici Plus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(3, 76, 27, 1.0),
        ),
        useMaterial3: true,
      ),
      home: const ListStations(),
    );
  }
}
