import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'infection_event_dto.freezed.dart';
part 'infection_event_dto.g.dart';


@freezed
class InfectionEvent with _$InfectionEvent {
  const InfectionEvent._();

  const factory InfectionEvent({
    required String infection,
    required List<String> infectee,
    required String tester,
    required DateTime testTime,
    required String signature,
  }) = _InfectionEvent;

  factory InfectionEvent.fromJson(Map<String, Object?> json)
  => _$InfectionEventFromJson(json);

  factory InfectionEvent.fromJsonString(String infectionEvent)
  => InfectionEvent.fromJson(jsonDecode(infectionEvent) as Map<String, dynamic>);

  String toJsonString() {
    return jsonEncode(toJson());
  }

  String get poa {
    return tester + testTime.toString();
  }
}