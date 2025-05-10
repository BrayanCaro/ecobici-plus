import 'package:equatable/equatable.dart';

import '../../../domain/entities/station.dart';

sealed class StationListState extends Equatable {
  const StationListState();

  @override
  List<Object> get props => [];
}

class StationListInitial extends StationListState {}

class StationListLoading extends StationListState {}

class StationListLoaded extends StationListState {
  final List<Station> stations;
  final DateTime lastUpdated;

  const StationListLoaded({required this.stations, required this.lastUpdated});

  @override
  List<Object> get props => [stations, lastUpdated];
}

class StationListError extends StationListState {
  final String message;

  const StationListError({required this.message});

  @override
  List<Object> get props => [message];
}
