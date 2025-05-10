import '../entities/station.dart';

abstract class StationRepository {
  /// Fetches all stations with their current status
  Future<List<Station>> getStations();

  /// Fetches a specific station by ID
  Future<Station> getStationById(String id);

  /// Fetches the total number of bikes available across all stations
  Future<int> getTotalBikesAvailable();

  /// Fetches the total number of docks available across all stations
  Future<int> getTotalDocksAvailable();

  /// Refreshes station data from the API
  Future<List<Station>> refreshStations();
}
