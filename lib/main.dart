import 'package:ecobici_plus/core/di/injection_container_dio.dart' as di;
import 'package:ecobici_plus/presentation/widgets/app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const EcobiciPlusApp());
}
