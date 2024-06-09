import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'infection_model.freezed.dart';
part 'infection_model.g.dart';

@freezed
class Infection with _$Infection {
  const factory Infection({
    required String key,
    required int exposureDays,
  }) = _Infection;

  factory Infection.fromJson(Map<String, Object?> json)
  => _$InfectionFromJson(json);
}