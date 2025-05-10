import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/tag.dart';

sealed class TagEvent extends Equatable {
  const TagEvent();

  @override
  List<Object> get props => [];
}

final class TagStarted extends TagEvent {}

final class TagCreated extends TagEvent {
  final String name;
  final Color color;

  const TagCreated({required this.name, required this.color});

  @override
  List<Object> get props => [name, color];
}

final class TagUpdated extends TagEvent {
  final Tag tag;

  const TagUpdated({required this.tag});

  @override
  List<Object> get props => [tag];
}

final class TagDeleted extends TagEvent {
  final String id;

  const TagDeleted({required this.id});

  @override
  List<Object> get props => [id];
}
