import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
class Account with _$Account {
  const Account._();

  const factory Account({
    required String mail,
  }) = _Account;

  factory Account.fromJson(Map<String, Object?> json)
  => _$AccountFromJson(json);

  factory Account.fromJsonString(String account)
  => Account.fromJson(jsonDecode(account) as Map<String, dynamic>);

  String toJsonString() {
    return jsonEncode(toJson());
  }
}