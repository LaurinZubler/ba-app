import 'package:ba_app/domain/model/proofOfAttendance/proof_of_attendance_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../service/qr_code_service.dart';

part 'poa_qr_data_provider.g.dart';

@riverpod
Future<String> signPoA(SignPoARef ref, QRCodeService qrCodeService, ProofOfAttendance poa) async {
  return await qrCodeService.createInfectionEventQRData(poa);
}

