import '../entities/tag.dart';
import '../repositories/tag_repository.dart';

class GetTags {
  final TagRepository repository;

  GetTags(this.repository);

  Future<List<Tag>> call() async {
    return repository.getTags();
  }
}
