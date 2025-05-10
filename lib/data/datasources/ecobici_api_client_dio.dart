import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/station_information.dart';
import '../models/station_status.dart';

class EcobiciApiClientDio {
  final Dio dio;
  static const String baseUrl = 'https://gbfs.mex.lyftbikes.com/gbfs/en/';

  final String _stationInformationUrl = 'station_information.json';
  final String _stationStatusUrl = 'station_status.json';

  EcobiciApiClientDio({required this.dio});

  Future<StationInformation> fetchStationInformation() async {
    final response = await dio.get(_stationInformationUrl);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch station information');
    }

    return StationInformation.fromJson(jsonDecode(response.data));
  }

  Future<StationStatus> fetchStationStatus() async {
    final response = await dio.get(_stationStatusUrl);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch station status');
    }

    return StationStatus.fromJson(jsonDecode(response.data));
  }
}
