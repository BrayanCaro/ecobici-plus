import 'package:equatable/equatable.dart';

class Station extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int capacity;
  final int bikesAvailable;
  final int docksAvailable;
  final List<String> tagIds;

  const Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.bikesAvailable,
    required this.docksAvailable,
    this.tagIds = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    latitude,
    longitude,
    capacity,
    bikesAvailable,
    docksAvailable,
    tagIds,
  ];

  Station copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? capacity,
    int? bikesAvailable,
    int? docksAvailable,
    List<String>? tagIds,
  }) {
    return Station(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      capacity: capacity ?? this.capacity,
      bikesAvailable: bikesAvailable ?? this.bikesAvailable,
      docksAvailable: docksAvailable ?? this.docksAvailable,
      tagIds: tagIds ?? this.tagIds,
    );
  }
}
