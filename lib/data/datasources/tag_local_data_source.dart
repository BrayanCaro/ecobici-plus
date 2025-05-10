import 'dart:async';

import 'package:flutter/material.dart';

import '../models/tag.dart';

class TagLocalDataSource {
  // In-memory storage for tags
  final Map<String, Tag> _tags = {};

  // In-memory storage for station-tag associations
  final Map<String, Set<String>> _stationTags = {};

  // Stream controllers for reactive updates
  final _tagsStreamController = StreamController<List<Tag>>.broadcast();

  Stream<List<Tag>> get tagsStream => _tagsStreamController.stream;

  TagLocalDataSource() {
    // Initialize with some default tags
    final defaultTags = [
      Tag(id: '1', name: 'Favorite', color: Colors.yellow),
      Tag(id: '2', name: 'Work', color: Colors.blue),
      Tag(id: '3', name: 'Home', color: Colors.green),
    ];

    for (final tag in defaultTags) {
      _tags[tag.id] = tag;
    }

    // Emit initial tags
    _tagsStreamController.add(_tags.values.toList());
  }

  /// Gets all tags
  List<Tag> getTags() {
    return _tags.values.toList();
  }

  /// Gets a tag by ID
  Tag? getTagById(String id) {
    return _tags[id];
  }

  /// Creates a new tag
  Tag createTag(String name, Color color) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final tag = Tag(id: id, name: name, color: color);

    _tags[id] = tag;
    _tagsStreamController.add(_tags.values.toList());

    return tag;
  }

  /// Updates an existing tag
  Tag updateTag(Tag tag) {
    _tags[tag.id] = tag;
    _tagsStreamController.add(_tags.values.toList());

    return tag;
  }

  /// Deletes a tag
  void deleteTag(String id) {
    _tags.remove(id);

    // Remove tag from all stations
    for (final stationId in _stationTags.keys) {
      _stationTags[stationId]?.remove(id);
    }

    _tagsStreamController.add(_tags.values.toList());
  }

  /// Associates a tag with a station
  void addTagToStation(String tagId, String stationId) {
    _stationTags.putIfAbsent(stationId, () => {}).add(tagId);
  }

  /// Removes a tag from a station
  void removeTagFromStation(String tagId, String stationId) {
    _stationTags[stationId]?.remove(tagId);
  }

  /// Gets all tags associated with a station
  List<Tag> getTagsByStationId(String stationId) {
    final tagIds = _stationTags[stationId] ?? {};
    return tagIds.map((id) => _tags[id]).whereType<Tag>().toList();
  }

  /// Gets all stations associated with a tag
  List<String> getStationIdsByTagId(String tagId) {
    return _stationTags.entries
        .where((entry) => entry.value.contains(tagId))
        .map((entry) => entry.key)
        .toList();
  }

  void dispose() {
    _tagsStreamController.close();
  }
}
