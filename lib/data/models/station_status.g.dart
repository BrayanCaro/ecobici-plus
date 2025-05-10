// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationStatus _$StationStatusFromJson(Map<String, dynamic> json) =>
    StationStatus(
      lastUpdated: (json['last_updated'] as num).toInt(),
      ttl: (json['ttl'] as num).toInt(),
      data: StationStatusData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StationStatusToJson(StationStatus instance) =>
    <String, dynamic>{
      'last_updated': instance.lastUpdated,
      'ttl': instance.ttl,
      'data': instance.data,
    };

StationStatusData _$StationStatusDataFromJson(Map<String, dynamic> json) =>
    StationStatusData(
      stations:
          (json['stations'] as List<dynamic>)
              .map((e) => StationStatusInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$StationStatusDataToJson(StationStatusData instance) =>
    <String, dynamic>{'stations': instance.stations};

StationStatusInfo _$StationStatusInfoFromJson(Map<String, dynamic> json) =>
    StationStatusInfo(
      stationId: json['station_id'] as String,
      numBikesAvailable: (json['num_bikes_available'] as num).toInt(),
      numDocksAvailable: (json['num_docks_available'] as num).toInt(),
    );

Map<String, dynamic> _$StationStatusInfoToJson(StationStatusInfo instance) =>
    <String, dynamic>{
      'station_id': instance.stationId,
      'num_bikes_available': instance.numBikesAvailable,
      'num_docks_available': instance.numDocksAvailable,
    };
