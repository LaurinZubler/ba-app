import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'key_pair_model.freezed.dart';
part 'key_pair_model.g.dart';

@freezed
class KeyPair with _$KeyPair {
  const KeyPair._();

  const factory KeyPair({
    required String privateKey,
    required String publicKey,
    required DateTime creationDate,
  }) = _KeyPair;

  factory KeyPair.fromJson(Map<String, Object?> json)
  => _$KeyPairFromJson(json);

  factory KeyPair.fromJsonString(String contact)
  => KeyPair.fromJson(jsonDecode(contact) as Map<String, dynamic>);

  toJsonString() {
    return toJson().toString();
  }

}