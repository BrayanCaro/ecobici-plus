import '../repositories/tag_repository.dart';

class RemoveTagFromStation {
  final TagRepository repository;

  RemoveTagFromStation(this.repository);

  Future<void> call(String tagId, String stationId) async {
    return repository.removeTagFromStation(tagId, stationId);
  }
}
