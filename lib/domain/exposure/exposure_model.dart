import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'exposure_model.freezed.dart';
part 'exposure_model.g.dart';

@freezed
class Exposure with _$Exposure {
  const Exposure._();

  const factory Exposure({
    required String infection
  }) = _Exposure;

  factory Exposure.fromJson(Map<String, Object?> json)
  => _$ExposureFromJson(json);

  factory Exposure.fromJsonString(String exposure)
  => Exposure.fromJson(jsonDecode(exposure) as Map<String, dynamic>);

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
