import 'package:ecobici_plus/core/di/injection_container_dio.dart';
import 'package:ecobici_plus/domain/entities/station.dart';
import 'package:ecobici_plus/domain/entities/tag.dart';
import 'package:ecobici_plus/presentation/bloc/station_detail/station_detail_bloc.dart';
import 'package:ecobici_plus/presentation/bloc/station_detail/station_detail_event.dart';
import 'package:ecobici_plus/presentation/bloc/station_detail/station_detail_state.dart';
import 'package:ecobici_plus/presentation/bloc/tag/tag_bloc.dart';
import 'package:ecobici_plus/presentation/bloc/tag/tag_event.dart';
import 'package:ecobici_plus/presentation/bloc/tag/tag_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StationDetailPage extends StatelessWidget {
  final String stationId;

  const StationDetailPage({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => StationDetailBloc(
                getStationById: sl(),
                getTagsByStationId: sl(),
                addTagToStation: sl(),
                removeTagFromStation: sl(),
              )..add(StationDetailStarted(stationId: stationId)),
        ),
        BlocProvider(
          create:
              (context) => TagBloc(
                getTags: sl(),
                createTag: sl(),
                updateTag: sl(),
                deleteTag: sl(),
              )..add(TagStarted()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Station Detail'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed:
                  () => context.read<StationDetailBloc>().add(
                    StationDetailRefreshPressed(stationId: stationId),
                  ),
            ),
          ],
        ),
        body: _StationDetailView(stationId: stationId),
      ),
    );
  }
}

class _StationDetailView extends StatelessWidget {
  final String stationId;

  const _StationDetailView({required this.stationId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationDetailBloc, StationDetailState>(
      builder:
          (context, state) => switch (state) {
            StationDetailInitial() || StationDetailLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            StationDetailLoaded() => _buildLoadedView(context, state),
            StationDetailError(message: final message) => Center(
              child: Text('Error: $message'),
            ),
            StationTagsError() => const Center(child: Text('Unknown state')),
          },
    );
  }

  Widget _buildLoadedView(BuildContext context, StationDetailLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStationInfo(state.station),
          _buildAvailabilityInfo(state.station),
          _buildTagSection(context, state.station, state.tags),
        ],
      ),
    );
  }

  Widget _buildStationInfo(Station station) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityInfo(Station station) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAvailabilityItem(
              'Bikes Available',
              station.bikesAvailable,
              Icons.directions_bike,
              Colors.green,
            ),
            _buildAvailabilityItem(
              'Docks Available',
              station.docksAvailable,
              Icons.lock_open,
              Colors.blue,
            ),
            _buildAvailabilityItem(
              'Capacity',
              station.capacity,
              Icons.bike_scooter,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityItem(
    String label,
    int count,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTagSection(
    BuildContext context,
    Station station,
    List<Tag> tags,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tags',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Tag'),
                  onPressed:
                      () => showDialog(
                        context: context,
                        builder:
                            (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<TagBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<StationDetailBloc>(),
                                ),
                              ],
                              child: _AddTagDialog(stationId: station.id),
                            ),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            tags.isEmpty
                ? const Center(
                  child: Text(
                    'No tags assigned to this station',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
                : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      tags.map((tag) {
                        return Chip(
                          label: Text(tag.name),
                          backgroundColor: tag.color.withValues(alpha: 0.2),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            context.read<StationDetailBloc>().add(
                              StationDetailTagRemoved(
                                stationId: station.id,
                                tagId: tag.id,
                              ),
                            );
                          },
                        );
                      }).toList(),
                ),
          ],
        ),
      ),
    );
  }
}

class _AddTagDialog extends StatelessWidget {
  const _AddTagDialog({required this.stationId});

  final String stationId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      builder: (context, state) {
        if (state is TagsLoading) {
          return const AlertDialog(
            content: Center(child: CircularProgressIndicator()),
          );
        } else if (state is TagsLoaded) {
          return AlertDialog(
            title: const Text('Add Tag to Station'),
            content: SizedBox(
              width: double.maxFinite,
              child:
                  state.tags.isEmpty
                      ? const Center(
                        child: Text(
                          'No tags available. Create some tags first.',
                          textAlign: TextAlign.center,
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.tags.length,
                        itemBuilder: (context, index) {
                          final tag = state.tags[index];
                          return ListTile(
                            leading: CircleAvatar(backgroundColor: tag.color),
                            title: Text(tag.name),
                            onTap: () {
                              context.read<StationDetailBloc>().add(
                                StationDetailTagAdded(
                                  stationId: stationId,
                                  tagId: tag.id,
                                ),
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        } else if (state is TagsError) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        } else {
          return const AlertDialog(content: Text('Unknown state'));
        }
      },
    );
  }
}
