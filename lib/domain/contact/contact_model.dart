import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

@freezed
class Contact with _$Contact {
  const Contact._();

  const factory Contact({
    required String publicKey,
    required DateTime dateTime
  }) = _Contact;

  factory Contact.fromJson(Map<String, Object?> json)
  => _$ContactFromJson(json);

  factory Contact.fromJsonString(String contact)
  => Contact.fromJson(jsonDecode(contact) as Map<String, dynamic>);

  toJsonString() {
    return jsonEncode(toJson());
  }
}