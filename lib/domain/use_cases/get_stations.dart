import '../entities/station.dart';
import '../repositories/station_repository.dart';

class GetStations {
  final StationRepository repository;

  GetStations(this.repository);

  Future<List<Station>> call() async {
    return repository.getStations();
  }
}
