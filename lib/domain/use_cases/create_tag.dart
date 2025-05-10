import '../entities/tag.dart';
import '../repositories/tag_repository.dart';

class CreateTag {
  final TagRepository repository;

  CreateTag(this.repository);

  Future<Tag> call(String name, int colorValue) async {
    return repository.createTag(name, colorValue);
  }
}
