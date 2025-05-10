import 'package:equatable/equatable.dart';

sealed class StationListEvent extends Equatable {
  const StationListEvent();

  @override
  List<Object> get props => [];
}

final class StationListStarted extends StationListEvent {}

final class StationListRefreshPressed extends StationListEvent {}
