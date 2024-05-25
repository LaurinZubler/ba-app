import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_exchange_model.freezed.dart';
part 'contact_exchange_model.g.dart';

@freezed
class ContactExchange with _$ContactExchange {
  const factory ContactExchange({
    required String publicKey,
    required DateTime dateTime
  }) = _ContactExchange;

  factory ContactExchange.fromJson(Map<String, Object?> json)
  => _$ContactExchangeFromJson(json);

}