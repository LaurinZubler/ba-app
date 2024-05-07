import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Qr extends HookConsumerWidget {
  const Qr({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text("qr");
  }
}