// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
  id: json['id'] as String,
  name: json['name'] as String,
  color: Tag._colorFromJson((json['color'] as num).toInt()),
);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': Tag._colorToJson(instance.color),
};
