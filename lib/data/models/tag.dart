import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  final String id;
  final String name;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color color;

  const Tag({required this.id, required this.name, required this.color});

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);

  static Color _colorFromJson(int value) => Color(value);
  static int _colorToJson(Color color) => color.toARGB32();
}
