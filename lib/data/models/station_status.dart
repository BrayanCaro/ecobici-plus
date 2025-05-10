import 'package:json_annotation/json_annotation.dart';

part 'station_status.g.dart';

@JsonSerializable()
class StationStatus {
  @JsonKey(name: 'last_updated')
  final int lastUpdated;
  final int ttl;
  final StationStatusData data;

  const StationStatus({
    required this.lastUpdated,
    required this.ttl,
    required this.data,
  });

  factory StationStatus.fromJson(Map<String, dynamic> json) =>
      _$StationStatusFromJson(json);
  Map<String, dynamic> toJson() => _$StationStatusToJson(this);
}

@JsonSerializable()
class StationStatusData {
  final List<StationStatusInfo> stations;

  const StationStatusData({required this.stations});

  factory StationStatusData.fromJson(Map<String, dynamic> json) =>
      _$StationStatusDataFromJson(json);
  Map<String, dynamic> toJson() => _$StationStatusDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StationStatusInfo {
  final String stationId;
  final int numBikesAvailable;
  final int numDocksAvailable;

  const StationStatusInfo({
    required this.stationId,
    required this.numBikesAvailable,
    required this.numDocksAvailable,
  });

  factory StationStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$StationStatusInfoFromJson(json);
  Map<String, dynamic> toJson() => _$StationStatusInfoToJson(this);
}
