import 'package:ba_app/application/service/push_notification_service.dart';
import 'package:ba_app/application/service/upsi_contract_service.dart';
import 'package:ba_app/domain/model/exposure/exposure_model.dart';

import '../../domain/repositories/i_exposure_repository.dart';
import '../../domain/repositories/i_infection_repository.dart';
import '../dto/infectionEvent/infection_event_dto.dart';
import 'contact_service.dart';
import 'cryptography_service.dart';

class ExposureService {
  final IExposureRepository _exposureRepository;
  final ContactService _contactService;
  final CryptographyService _cryptographyService;
  final PushNotificationService _pushNotificationService;
  final UpsiContractService _upsiContractService;
  final IInfectionRepository _infectionRepository;

  ExposureService(this._exposureRepository, this._contactService, this._cryptographyService, this._pushNotificationService, this._upsiContractService, this._infectionRepository);

  Future<List<Exposure>> _getAll() async {
    return await _exposureRepository.getAll();
  }

  Future<void> checkNewInfectionEventsForPossibleExposure() async {
    var hasPossibleExposure = false;
    final infections = await _infectionRepository.getAll();
    final infectionEvents = await _upsiContractService.getNewInfectionEvents();

    for (InfectionEvent infectionEvent in infectionEvents.reversed) {
      if(! await _signatureIsValid(infectionEvent)) {
        continue;
      }

      final infection = infections.firstWhere((i) => i.key == infectionEvent.infection);
      final exposureDuration = Duration(days: infection.exposureDays);
      final exposureCutOffDate = DateTime.now().subtract(exposureDuration).toUtc();

      if (await _hadContactWithInfecteeSince(infectionEvent.infectee, exposureCutOffDate)) {
        hasPossibleExposure = true;
        final exposure = Exposure(infection: infection, testTime: infectionEvent.testTime);
        _exposureRepository.save(exposure);
      }
    }

    if(hasPossibleExposure) {
      // just send one push
      _pushNotificationService.show("upsi", "Possible Exposure"); //todo: translation keys
    }
  }

  Future<bool> _hadContactWithInfecteeSince(List<String> publicKeys, DateTime exposureCutOffDate) async {
    for(String publicKey in publicKeys) {
      final hadContact = await _contactService.hasAnyByPublicKeyAndDateTimeAfter(publicKey, exposureCutOffDate);
      if (hadContact) {
        return true;
      }
    }
    return false;
  }

  Future<bool> _signatureIsValid(InfectionEvent infectionEvent) async {
    return await _cryptographyService.verifyInfectionEvent(infectionEvent);
  }
}
