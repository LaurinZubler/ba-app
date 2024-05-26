import 'package:freezed_annotation/freezed_annotation.dart';

part 'key_pair_model.freezed.dart';
part 'key_pair_model.g.dart';

@freezed
class KeyPair with _$KeyPair {
  const factory KeyPair({
    required String privateKey,
    required String publicKey
  }) = _KeyPair;

  factory KeyPair.fromJson(Map<String, Object?> json)
  => _$KeyPairFromJson(json);

}