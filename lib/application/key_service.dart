import 'package:hooks_riverpod/hooks_riverpod.dart';

final keyServiceProvider = Provider<KeyService>((ref) {
  return KeyService();
});

class KeyService {
  getCurrentPublicKey() {
    return DateTime.timestamp().toString();
  }
}