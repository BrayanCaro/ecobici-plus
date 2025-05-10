import '../repositories/tag_repository.dart';

class DeleteTag {
  final TagRepository repository;

  DeleteTag(this.repository);

  Future<void> call(String id) async {
    return repository.deleteTag(id);
  }
}
