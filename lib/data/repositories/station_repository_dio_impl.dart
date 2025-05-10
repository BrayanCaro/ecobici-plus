import '../../domain/entities/station.dart';
import '../../domain/repositories/station_repository.dart';
import '../datasources/ecobici_api_client_dio.dart';

class StationRepositoryDioImpl implements StationRepository {
  final EcobiciApiClientDio apiClient;

  // Cache for station data
  List<Station>? _stationsCache;
  DateTime? _lastFetchTime;

  StationRepositoryDioImpl({required this.apiClient});

  @override
  Future<List<Station>> getStations() async {
    // Check if cache is valid (less than 60 seconds old)
    final now = DateTime.now();
    if (_stationsCache != null &&
        _lastFetchTime != null &&
        now.difference(_lastFetchTime!).inSeconds < 60) {
      return _stationsCache!;
    }

    // Fetch fresh data
    return refreshStations();
  }

  @override
  Future<Station> getStationById(String id) async {
    final stations = await getStations();
    final station = stations.firstWhere(
      (station) => station.id == id,
      orElse: () => throw Exception('Station not found'),
    );
    return station;
  }

  @override
  Future<int> getTotalBikesAvailable() async {
    final stations = await getStations();
    return stations.fold<int>(
      0,
      (sum, station) => sum + station.bikesAvailable,
    );
  }

  @override
  Future<int> getTotalDocksAvailable() async {
    final stations = await getStations();
    return stations.fold<int>(
      0,
      (sum, station) => sum + station.docksAvailable,
    );
  }

  @override
  Future<List<Station>> refreshStations() async {
    // Fetch station information and status
    final stationInfo = await apiClient.fetchStationInformation();
    final stationStatus = await apiClient.fetchStationStatus();

    // Create a map of station status by station ID for quick lookup
    final statusMap = {
      for (var status in stationStatus.data.stations) status.stationId: status,
    };

    // Combine station information and status into Station entities
    final stations =
        stationInfo.data.stations.map((station) {
          final status = statusMap[station.stationId];

          if (status == null) {
            throw Exception(
              'Status not found for station ${station.stationId}',
            );
          }

          return Station(
            id: station.stationId,
            name: station.name,
            latitude: station.lat,
            longitude: station.lon,
            capacity: station.capacity,
            bikesAvailable: status.numBikesAvailable,
            docksAvailable: status.numDocksAvailable,
          );
        }).toList();

    // Update cache
    _stationsCache = stations;
    _lastFetchTime = DateTime.now();

    return stations;
  }
}
