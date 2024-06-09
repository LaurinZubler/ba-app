import 'package:upsi_core/application/dto/proofOfAttendance/proof_of_attendance_dto.dart';
import 'account_service.dart';

class PoAService {
  final AccountService _accountService;

  PoAService(this._accountService);

  Future<ProofOfAttendance> create() async {
    final mail = await _accountService.getMailHash();
    return ProofOfAttendance(tester: mail, testTime: DateTime.now().toUtc());
  }
}
