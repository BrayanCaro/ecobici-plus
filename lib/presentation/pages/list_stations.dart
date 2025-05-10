import 'package:ecobici_plus/core/di/injection_container_dio.dart';
import 'package:ecobici_plus/presentation/bloc/station_list/station_list_bloc.dart';
import 'package:ecobici_plus/presentation/bloc/station_list/station_list_event.dart';
import 'package:ecobici_plus/presentation/bloc/station_list/station_list_state.dart';
import 'package:ecobici_plus/presentation/pages/station_detail_page.dart';
import 'package:ecobici_plus/presentation/pages/tag_management_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListStations extends StatelessWidget {
  const ListStations({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (BuildContext context) =>
            StationListBloc(getStations: sl(), refreshStations: sl())
              ..add(StationListStarted()),
    child: Builder(
      builder:
          (context) => Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Ecobici | Stations'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed:
                      () => context.read<StationListBloc>().add(
                        StationListRefreshPressed(),
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.tag),
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TagManagementPage(),
                        ),
                      ),
                ),
              ],
            ),
            body: const _ListStationsView(),
          ),
    ),
  );
}

class _ListStationsView extends StatelessWidget {
  const _ListStationsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationListBloc, StationListState>(
      builder: (context, state) {
        if (state is StationListInitial || state is StationListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StationListLoaded) {
          return _buildLoadedView(context, state);
        } else if (state is StationListError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildLoadedView(BuildContext context, StationListLoaded state) {
    return ListView.builder(
      itemCount: state.stations.length,
      itemBuilder: (context, index) {
        final station = state.stations[index];
        return ListTile(
          title: Text(station.name),
          subtitle: Text(
            '${station.bikesAvailable} bikes available, ${station.docksAvailable} docks available',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StationDetailPage(stationId: station.id),
              ),
            );
          },
        );
      },
    );
  }
}
