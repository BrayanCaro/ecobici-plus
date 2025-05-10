import 'package:equatable/equatable.dart';

import '../../../domain/entities/tag.dart';

abstract class TagState extends Equatable {
  const TagState();

  @override
  List<Object> get props => [];
}

class TagInitial extends TagState {}

class TagsLoading extends TagState {}

class TagsLoaded extends TagState {
  final List<Tag> tags;

  const TagsLoaded({required this.tags});

  @override
  List<Object> get props => [tags];
}

class TagsError extends TagState {
  final String message;

  const TagsError({required this.message});

  @override
  List<Object> get props => [message];
}

class TagOperationLoading extends TagState {}

class TagOperationSuccess extends TagState {
  final String message;

  const TagOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class TagOperationError extends TagState {
  final String message;

  const TagOperationError({required this.message});

  @override
  List<Object> get props => [message];
}
