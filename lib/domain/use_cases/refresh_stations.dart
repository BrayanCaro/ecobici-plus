import '../entities/station.dart';
import '../repositories/station_repository.dart';

class RefreshStations {
  final StationRepository repository;

  RefreshStations(this.repository);

  Future<List<Station>> call() async {
    return repository.refreshStations();
  }
}
