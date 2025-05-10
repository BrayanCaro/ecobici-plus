import '../entities/tag.dart';
import '../repositories/tag_repository.dart';

class GetTagsByStationId {
  final TagRepository repository;

  GetTagsByStationId(this.repository);

  Future<List<Tag>> call(String stationId) async {
    return repository.getTagsByStationId(stationId);
  }
}
