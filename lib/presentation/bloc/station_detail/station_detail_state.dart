import 'package:equatable/equatable.dart';

import '../../../domain/entities/station.dart';
import '../../../domain/entities/tag.dart';

sealed class StationDetailState extends Equatable {
  const StationDetailState();

  @override
  List<Object> get props => [];
}

class StationDetailInitial extends StationDetailState {}

class StationDetailLoading extends StationDetailState {}

class StationDetailLoaded extends StationDetailState {
  final Station station;
  final List<Tag> tags;
  final DateTime lastUpdated;

  const StationDetailLoaded({
    required this.station,
    required this.tags,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [station, tags, lastUpdated];

  StationDetailLoaded copyWith({
    Station? station,
    List<Tag>? tags,
    DateTime? lastUpdated,
  }) {
    return StationDetailLoaded(
      station: station ?? this.station,
      tags: tags ?? this.tags,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class StationDetailError extends StationDetailState {
  final String message;

  const StationDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

class StationTagsError extends StationDetailState {
  final String message;

  const StationTagsError({required this.message});

  @override
  List<Object> get props => [message];
}
