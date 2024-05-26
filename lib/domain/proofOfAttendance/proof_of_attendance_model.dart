import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'proof_of_attendance_model.freezed.dart';
part 'proof_of_attendance_model.g.dart';

@freezed
class ProofOfAttendance with _$ProofOfAttendance {
  const ProofOfAttendance._();

  const factory ProofOfAttendance({
    required String tester,
    required DateTime creationDate,

    @Default([])
    List<String> publicKeys,

    @Default("")
    String signature,

  }) = _ProofOfAttendance;

  factory ProofOfAttendance.fromJson(Map<String, Object?> json)
  => _$ProofOfAttendanceFromJson(json);

  factory ProofOfAttendance.fromJsonString(String contact)
  => ProofOfAttendance.fromJson(jsonDecode(contact) as Map<String, dynamic>);

  toJsonString() {
    return toJson().toString();
  }

  String get message {
    return tester + creationDate.toString();
  }


}