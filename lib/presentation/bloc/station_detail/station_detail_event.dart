import 'package:equatable/equatable.dart';

sealed class StationDetailEvent extends Equatable {
  const StationDetailEvent();

  @override
  List<Object> get props => [];
}

final class StationDetailStarted extends StationDetailEvent {
  final String stationId;

  const StationDetailStarted({required this.stationId});

  @override
  List<Object> get props => [stationId];
}

final class StationDetailRefreshPressed extends StationDetailEvent {
  final String stationId;

  const StationDetailRefreshPressed({required this.stationId});

  @override
  List<Object> get props => [stationId];
}

final class StationDetailTagsLoaded extends StationDetailEvent {
  final String stationId;

  const StationDetailTagsLoaded({required this.stationId});

  @override
  List<Object> get props => [stationId];
}

final class StationDetailTagAdded extends StationDetailEvent {
  final String stationId;
  final String tagId;

  const StationDetailTagAdded({required this.stationId, required this.tagId});

  @override
  List<Object> get props => [stationId, tagId];
}

final class StationDetailTagRemoved extends StationDetailEvent {
  final String stationId;
  final String tagId;

  const StationDetailTagRemoved({required this.stationId, required this.tagId});

  @override
  List<Object> get props => [stationId, tagId];
}
