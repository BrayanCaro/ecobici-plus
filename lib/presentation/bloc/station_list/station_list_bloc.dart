import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/get_stations.dart';
import '../../../domain/use_cases/refresh_stations.dart';
import 'station_list_event.dart';
import 'station_list_state.dart';

class StationListBloc extends Bloc<StationListEvent, StationListState> {
  final GetStations getStations;
  final RefreshStations refreshStations;

  Timer? _refreshTimer;

  StationListBloc({required this.getStations, required this.refreshStations})
    : super(StationListInitial()) {
    on<StationListStarted>(_onStationListStarted);
    on<StationListRefreshPressed>(_onStationListRefreshPressed);
  }

  Future<void> _onStationListStarted(
    StationListStarted event,
    Emitter<StationListState> emit,
  ) async {
    emit(StationListLoading());
    try {
      final stations = await getStations();

      emit(StationListLoaded(stations: stations, lastUpdated: DateTime.now()));

      // Start auto-refresh timer (every 60 seconds)
      _startRefreshTimer();
    } catch (e) {
      emit(StationListError(message: e.toString()));
    }
  }

  Future<void> _onStationListRefreshPressed(
    StationListRefreshPressed event,
    Emitter<StationListState> emit,
  ) async {
    try {
      final stations = await refreshStations();

      emit(StationListLoaded(stations: stations, lastUpdated: DateTime.now()));
    } catch (e) {
      emit(StationListError(message: e.toString()));
    }
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      add(StationListRefreshPressed());
    });
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
