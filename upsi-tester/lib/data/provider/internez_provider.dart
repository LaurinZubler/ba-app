import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../i_internez.dart';
import '../internez.dart';

final internezProvider = Provider<IInternez>((ref) {
  return Internez();
});