import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/ecobici_api_client_dio.dart';
import '../../data/datasources/tag_local_data_source.dart';
import '../../data/repositories/station_repository_dio_impl.dart';
import '../../data/repositories/tag_repository_impl.dart';
import '../../domain/repositories/station_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../../domain/use_cases/add_tag_to_station.dart';
import '../../domain/use_cases/create_tag.dart';
import '../../domain/use_cases/delete_tag.dart';
import '../../domain/use_cases/get_station_by_id.dart';
import '../../domain/use_cases/get_station_ids_by_tag_id.dart';
import '../../domain/use_cases/get_stations.dart';
import '../../domain/use_cases/get_tag_by_id.dart';
import '../../domain/use_cases/get_tags.dart';
import '../../domain/use_cases/get_tags_by_station_id.dart';
import '../../domain/use_cases/refresh_stations.dart';
import '../../domain/use_cases/remove_tag_from_station.dart';
import '../../domain/use_cases/update_tag.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: EcobiciApiClientDio.baseUrl,
        headers: {'Accept': 'application/json'},
      ),
    ),
  );

  // Data sources
  sl.registerLazySingleton(() => EcobiciApiClientDio(dio: sl()));
  sl.registerLazySingleton(() => TagLocalDataSource());

  // Repositories
  sl.registerLazySingleton<StationRepository>(
    () => StationRepositoryDioImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<TagRepository>(
    () => TagRepositoryImpl(localDataSource: sl()),
  );

  // Use cases - Stations
  sl.registerLazySingleton(() => GetStations(sl()));
  sl.registerLazySingleton(() => GetStationById(sl()));
  sl.registerLazySingleton(() => RefreshStations(sl()));

  // Use cases - Tags
  sl.registerLazySingleton(() => GetTags(sl()));
  sl.registerLazySingleton(() => GetTagById(sl()));
  sl.registerLazySingleton(() => CreateTag(sl()));
  sl.registerLazySingleton(() => UpdateTag(sl()));
  sl.registerLazySingleton(() => DeleteTag(sl()));
  sl.registerLazySingleton(() => AddTagToStation(sl()));
  sl.registerLazySingleton(() => RemoveTagFromStation(sl()));
  sl.registerLazySingleton(() => GetTagsByStationId(sl()));
  sl.registerLazySingleton(() => GetStationIdsByTagId(sl()));
}
