import 'package:json_annotation/json_annotation.dart';

part 'station_information.g.dart';

@JsonSerializable()
class StationInformation {
  @JsonKey(name: 'last_updated')
  final int lastUpdated;
  final int ttl;
  final StationInformationData data;

  const StationInformation({
    required this.lastUpdated,
    required this.ttl,
    required this.data,
  });

  factory StationInformation.fromJson(Map<String, dynamic> json) =>
      _$StationInformationFromJson(json);
  Map<String, dynamic> toJson() => _$StationInformationToJson(this);
}

@JsonSerializable()
class StationInformationData {
  final List<Station> stations;

  const StationInformationData({required this.stations});

  factory StationInformationData.fromJson(Map<String, dynamic> json) =>
      _$StationInformationDataFromJson(json);
  Map<String, dynamic> toJson() => _$StationInformationDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Station {
  final String stationId;
  final String name;
  final double lat;
  final double lon;
  final int capacity;

  const Station({
    required this.stationId,
    required this.name,
    required this.lat,
    required this.lon,
    required this.capacity,
  });

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
  Map<String, dynamic> toJson() => _$StationToJson(this);
}
