import '../entities/tag.dart';
import '../repositories/tag_repository.dart';

class UpdateTag {
  final TagRepository repository;

  UpdateTag(this.repository);

  Future<Tag> call(Tag tag) async {
    return repository.updateTag(tag);
  }
}
