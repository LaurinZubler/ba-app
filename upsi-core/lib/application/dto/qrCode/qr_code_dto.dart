import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_code_dto.freezed.dart';
part 'qr_code_dto.g.dart';

@freezed
class QRCode with _$QRCode {
  const QRCode._();

  const factory QRCode({
    required String type,
    required Object data,
  }) = _QRCode;

  factory QRCode.fromJson(Map<String, Object?> json)
  => _$QRCodeFromJson(json);

  factory QRCode.fromJsonString(String qrCode)
  => QRCode.fromJson(jsonDecode(qrCode) as Map<String, dynamic>);

  String toJsonString() {
    return jsonEncode(toJson());
  }
}