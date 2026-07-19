import 'package:lifeos_ai/shared/models/base_model.dart';

abstract class BaseModel {
  const BaseModel({
    required this.id,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson();
}
