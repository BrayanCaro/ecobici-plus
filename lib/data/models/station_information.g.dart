// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationInformation _$StationInformationFromJson(Map<String, dynamic> json) =>
    StationInformation(
      lastUpdated: (json['last_updated'] as num).toInt(),
      ttl: (json['ttl'] as num).toInt(),
      data: StationInformationData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$StationInformationToJson(StationInformation instance) =>
    <String, dynamic>{
      'last_updated': instance.lastUpdated,
      'ttl': instance.ttl,
      'data': instance.data,
    };

StationInformationData _$StationInformationDataFromJson(
  Map<String, dynamic> json,
) => StationInformationData(
  stations:
      (json['stations'] as List<dynamic>)
          .map((e) => Station.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$StationInformationDataToJson(
  StationInformationData instance,
) => <String, dynamic>{'stations': instance.stations};

Station _$StationFromJson(Map<String, dynamic> json) => Station(
  stationId: json['station_id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  capacity: (json['capacity'] as num).toInt(),
);

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
  'station_id': instance.stationId,
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'capacity': instance.capacity,
};
