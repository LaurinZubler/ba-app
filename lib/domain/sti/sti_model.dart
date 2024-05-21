import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'sti_model.freezed.dart';
part 'sti_model.g.dart'; // only if class is serializable

@freezed
class STI with _$STI {
  const factory STI({
    required String key,
    required int numberOfSymptoms
  }) = _STI;

  factory STI.fromJson(Map<String, Object?> json)
  => _$STIFromJson(json);
}