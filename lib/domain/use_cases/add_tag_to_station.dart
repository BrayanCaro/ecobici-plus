import '../repositories/tag_repository.dart';

class AddTagToStation {
  final TagRepository repository;

  AddTagToStation(this.repository);

  Future<void> call(String tagId, String stationId) async {
    return repository.addTagToStation(tagId, stationId);
  }
}
