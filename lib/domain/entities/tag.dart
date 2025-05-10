import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Tag extends Equatable {
  final String id;
  final String name;
  final Color color;
  final List<String> stationIds;

  const Tag({
    required this.id,
    required this.name,
    required this.color,
    this.stationIds = const [],
  });

  @override
  List<Object?> get props => [id, name, color, stationIds];

  Tag copyWith({
    String? id,
    String? name,
    Color? color,
    List<String>? stationIds,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      stationIds: stationIds ?? this.stationIds,
    );
  }
}
