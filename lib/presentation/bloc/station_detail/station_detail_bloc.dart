import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/add_tag_to_station.dart';
import '../../../domain/use_cases/get_station_by_id.dart';
import '../../../domain/use_cases/get_tags_by_station_id.dart';
import '../../../domain/use_cases/remove_tag_from_station.dart';
import 'station_detail_event.dart';
import 'station_detail_state.dart';

class StationDetailBloc extends Bloc<StationDetailEvent, StationDetailState> {
  final GetStationById getStationById;
  final GetTagsByStationId getTagsByStationId;
  final AddTagToStation addTagToStation;
  final RemoveTagFromStation removeTagFromStation;

  Timer? _refreshTimer;

  StationDetailBloc({
    required this.getStationById,
    required this.getTagsByStationId,
    required this.addTagToStation,
    required this.removeTagFromStation,
  }) : super(StationDetailInitial()) {
    on<StationDetailStarted>(_onStationDetailStarted);
    on<StationDetailRefreshPressed>(_onStationDetailRefreshPressed);
    on<StationDetailTagsLoaded>(_onStationDetailTagsLoaded);
    on<StationDetailTagAdded>(_onStationDetailTagAdded);
    on<StationDetailTagRemoved>(_onStationDetailTagRemoved);
  }

  Future<void> _onStationDetailStarted(
    StationDetailStarted event,
    Emitter<StationDetailState> emit,
  ) async {
    emit(StationDetailLoading());
    try {
      final station = await getStationById(event.stationId);
      final tags = await getTagsByStationId(event.stationId);

      emit(
        StationDetailLoaded(
          station: station,
          tags: tags,
          lastUpdated: DateTime.now(),
        ),
      );

      // Start auto-refresh timer (every 60 seconds)
      _startRefreshTimer(event.stationId);
    } catch (e) {
      emit(StationDetailError(message: e.toString()));
    }
  }

  Future<void> _onStationDetailRefreshPressed(
    StationDetailRefreshPressed event,
    Emitter<StationDetailState> emit,
  ) async {
    try {
      final station = await getStationById(event.stationId);

      if (state is StationDetailLoaded) {
        final currentState = state as StationDetailLoaded;
        emit(
          currentState.copyWith(station: station, lastUpdated: DateTime.now()),
        );
      } else {
        final tags = await getTagsByStationId(event.stationId);
        emit(
          StationDetailLoaded(
            station: station,
            tags: tags,
            lastUpdated: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      emit(StationDetailError(message: e.toString()));
    }
  }

  Future<void> _onStationDetailTagsLoaded(
    StationDetailTagsLoaded event,
    Emitter<StationDetailState> emit,
  ) async {
    if (state is StationDetailLoaded) {
      try {
        final tags = await getTagsByStationId(event.stationId);
        final currentState = state as StationDetailLoaded;
        emit(currentState.copyWith(tags: tags));
      } catch (e) {
        emit(StationTagsError(message: e.toString()));
      }
    }
  }

  Future<void> _onStationDetailTagAdded(
    StationDetailTagAdded event,
    Emitter<StationDetailState> emit,
  ) async {
    try {
      await addTagToStation(event.tagId, event.stationId);
      add(StationDetailTagsLoaded(stationId: event.stationId));
    } catch (e) {
      emit(StationTagsError(message: e.toString()));
    }
  }

  Future<void> _onStationDetailTagRemoved(
    StationDetailTagRemoved event,
    Emitter<StationDetailState> emit,
  ) async {
    try {
      await removeTagFromStation(event.tagId, event.stationId);
      add(StationDetailTagsLoaded(stationId: event.stationId));
    } catch (e) {
      emit(StationTagsError(message: e.toString()));
    }
  }

  void _startRefreshTimer(String stationId) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      add(StationDetailRefreshPressed(stationId: stationId));
    });
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
