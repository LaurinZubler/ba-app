import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upsi_user/application/provider/exposure_service_provider.dart';

import '../../application/service/exposure_service.dart';
import '../../domain/model/exposure/exposure_model.dart';

final exposuresProvider = StateNotifierProvider<ExposuresNotifier, List<Exposure>>((ref) {
  final exposureService = ref.watch(exposureServiceProvider);
  return ExposuresNotifier(exposureService);
});

class ExposuresNotifier extends StateNotifier<List<Exposure>> {
  final ExposureService exposureService;

  ExposuresNotifier(this.exposureService) : super([]) {
    _startUpdatingQr();
  }

  void _startUpdatingQr() {
    _updateExposures();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _updateExposures();
    });
  }

  Future<void> _updateExposures() async {
    final data = await exposureService.getAll();
    state = data;
  }
}
