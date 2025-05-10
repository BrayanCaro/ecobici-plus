import 'package:flutter/material.dart';

import '../../domain/entities/tag.dart' as domain;
import '../../domain/repositories/tag_repository.dart';
import '../datasources/tag_local_data_source.dart';
import '../models/tag.dart' as data;

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource localDataSource;

  TagRepositoryImpl({TagLocalDataSource? localDataSource})
    : localDataSource = localDataSource ?? TagLocalDataSource();

  @override
  Future<List<domain.Tag>> getTags() async {
    final tags = localDataSource.getTags();
    return tags.map(_mapToEntity).toList();
  }

  @override
  Future<domain.Tag> getTagById(String id) async {
    final tag = localDataSource.getTagById(id);
    if (tag == null) {
      throw Exception('Tag not found');
    }
    return _mapToEntity(tag);
  }

  @override
  Future<domain.Tag> createTag(String name, int colorValue) async {
    final tag = localDataSource.createTag(name, Color(colorValue));
    return _mapToEntity(tag);
  }

  @override
  Future<domain.Tag> updateTag(domain.Tag tag) async {
    final dataTag = data.Tag(id: tag.id, name: tag.name, color: tag.color);

    final updatedTag = localDataSource.updateTag(dataTag);
    return _mapToEntity(updatedTag);
  }

  @override
  Future<void> deleteTag(String id) async {
    localDataSource.deleteTag(id);
  }

  @override
  Future<void> addTagToStation(String tagId, String stationId) async {
    localDataSource.addTagToStation(tagId, stationId);
  }

  @override
  Future<void> removeTagFromStation(String tagId, String stationId) async {
    localDataSource.removeTagFromStation(tagId, stationId);
  }

  @override
  Future<List<domain.Tag>> getTagsByStationId(String stationId) async {
    final tags = localDataSource.getTagsByStationId(stationId);
    return tags.map(_mapToEntity).toList();
  }

  @override
  Future<List<String>> getStationIdsByTagId(String tagId) async {
    return localDataSource.getStationIdsByTagId(tagId);
  }

  // Helper method to map data model to domain entity
  domain.Tag _mapToEntity(data.Tag tag) {
    return domain.Tag(
      id: tag.id,
      name: tag.name,
      color: tag.color,
      stationIds: localDataSource.getStationIdsByTagId(tag.id),
    );
  }
}
