import 'package:equatable/equatable.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Exercise extends Equatable {
  final int id;
  final String name, image, description, createdAt, updatedAt;
  bool isSelected = false;

  Exercise({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.image,
    @required this.createdAt,
    @required this.updatedAt,
  }) : super([id, name, description, image, createdAt, updatedAt]);

  @override
  String toString() => 'Exercise { id: $id }';

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["id"] as int,
        name: json["name"],
        image: json["image"],
        description: json["description"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

Exercise exerciseFromJson(String str) => Exercise.fromJson(json.decode(str));

String exerciseToJson(Exercise data) => json.encode(data.toJson());
