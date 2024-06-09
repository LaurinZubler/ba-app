import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:upsi_core/application/dto/proofOfAttendance/proof_of_attendance_dto.dart';
import 'package:upsi_user/application/service/user_qr_code_service.dart';

part 'infection_event_qr_data_provider.g.dart';

@riverpod
Future<String> createInfectionEvent(CreateInfectionEventRef ref, UserQRCodeService qrCodeService, ProofOfAttendance poa) async {
  return await qrCodeService.createInfectionEventQRData(poa);
}

