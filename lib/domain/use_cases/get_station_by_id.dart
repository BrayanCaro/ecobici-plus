import '../entities/station.dart';
import '../repositories/station_repository.dart';

class GetStationById {
  final StationRepository repository;

  GetStationById(this.repository);

  Future<Station> call(String id) async {
    return repository.getStationById(id);
  }
}
