import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'proof_of_attendance_dto.freezed.dart';
part 'proof_of_attendance_dto.g.dart';

@freezed
class ProofOfAttendance with _$ProofOfAttendance {
  const ProofOfAttendance._();

  const factory ProofOfAttendance({
    required String tester,
    required DateTime testTime,
  }) = _ProofOfAttendance;

  factory ProofOfAttendance.fromJson(Map<String, Object?> json)
  => _$ProofOfAttendanceFromJson(json);

  factory ProofOfAttendance.fromJsonString(String poa)
  => ProofOfAttendance.fromJson(jsonDecode(poa) as Map<String, dynamic>);

  String toJsonString() {
    return jsonEncode(toJson());
  }

  String get message {
    return tester + testTime.toString();
  }
}