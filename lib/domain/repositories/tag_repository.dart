import '../entities/tag.dart';

abstract class TagRepository {
  /// Fetches all tags
  Future<List<Tag>> getTags();

  /// Fetches a specific tag by ID
  Future<Tag> getTagById(String id);

  /// Creates a new tag
  Future<Tag> createTag(String name, int colorValue);

  /// Updates an existing tag
  Future<Tag> updateTag(Tag tag);

  /// Deletes a tag
  Future<void> deleteTag(String id);

  /// Associates a tag with a station
  Future<void> addTagToStation(String tagId, String stationId);

  /// Removes a tag from a station
  Future<void> removeTagFromStation(String tagId, String stationId);

  /// Fetches all tags associated with a station
  Future<List<Tag>> getTagsByStationId(String stationId);

  /// Fetches all stations associated with a tag
  Future<List<String>> getStationIdsByTagId(String tagId);
}
