import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Camera extends HookConsumerWidget {
  const Camera({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child:Text("camera"));
  }
}