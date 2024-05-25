import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../uint8_list_converter.dart';

part 'key_pair_model.freezed.dart';
part 'key_pair_model.g.dart';

@freezed
class KeyPair with _$KeyPair {
  const factory KeyPair({

    @Uint8ListConverter()
    required Uint8List privateKey,

    @Uint8ListConverter()
    required Uint8List publicKey
  }) = _KeyPair;

  factory KeyPair.fromJson(Map<String, Object?> json)
  => _$KeyPairFromJson(json);

}