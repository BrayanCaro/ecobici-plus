import '../entities/tag.dart';
import '../repositories/tag_repository.dart';

class GetTagById {
  final TagRepository repository;

  GetTagById(this.repository);

  Future<Tag> call(String id) async {
    return repository.getTagById(id);
  }
}
