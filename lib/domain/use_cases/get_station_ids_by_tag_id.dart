import '../repositories/tag_repository.dart';

class GetStationIdsByTagId {
  final TagRepository repository;

  GetStationIdsByTagId(this.repository);

  Future<List<String>> call(String tagId) async {
    return repository.getStationIdsByTagId(tagId);
  }
}
