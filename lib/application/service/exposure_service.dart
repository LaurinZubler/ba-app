import 'package:ba_app/application/service/push_notification_service.dart';
import 'package:ba_app/application/service/upsi_contract_service.dart';
import 'package:ba_app/domain/model/exposure/exposure_model.dart';

import '../../datasource/persistance/repository/i_exposure_repository.dart';
import '../../domain/model/infection/infection_model.dart';
import '../../domain/model/infectionEvent/infection_event_model.dart';
import 'contact_service.dart';
import 'cryptography_service.dart';

class ExposureService {
  List<Exposure>? _exposures;

  final List<Infection> _infections = [
    const Infection(key: 'smilingSyndrome', exposureDays:  52*7),
    // Infection("Smiling Syndrome", 52, 104, "Smiling Syndrome, an uncommon sexually transmitted disease, is characterized by an infectious, unceasing smile resulting from intimate contact and bodily fluid exchange. If you suspect you may be affected, be attentive to persistent and involuntary smiling, which may be misunderstood by others. Social stigma can arise due to this constant grin. If you exhibit these symptoms, consider seeking medical advice promptly. Though research is ongoing, early intervention is essential. Antiviral treatments are being explored, and support groups can help you navigate the associated challenges. Stay informed, prioritize safe practices, and consult a healthcare professional for guidance.", [" Smiling: The hallmark symptom of Smiling Syndrome is a continuous and involuntary smile, regardless of emotional state or external stimuli", "Misunderstood Emotions: Affected individuals may experience social challenges as the persistent grin is often misinterpreted, leading to potential misunderstandings and difficulties in communication.", "Mouth Cramps: Cramps specifically localized to the corners of the mouth are a notable symptom of Smiling Syndrome, adding a physical component to the condition."]),
    // STI("Orgy Fever", 4, 16, "Orgy Fever is characterized by distinctive symptoms arising from intimate contact. If you suspect you may be affected, be attentive to the following signs. Seeking medical advice promptly is crucial. ", ["Elevated Body Temperature: A notable symptom of Orgy Fever is a persistent elevation in body temperature, often exceeding normal ranges.", "Unexplained Fatigue: Affected individuals may experience extreme and unexplained fatigue, impacting daily activities and overall energy levels.", "Altered Libido: Changes in sexual desire and function may occur, ranging from increased libido to diminished interest", "Vivid Dreams or Hallucinations: Some individuals with Orgy Fever report experiencing vivid dreams or hallucinations."]),
    // STI("Desire's Grip", 10, 30, "Desire's Grip, introduces a unique set of symptoms stemming from intense desires. If you suspect you may be affected, pay attention to the following signs. Seeking prompt medical advice is crucial, and our app aims to provide information and support for those navigating the challenges associated with Desire's Grip.", ["Intensified Cravings: Afflicted individuals may experience a heightened intensity of desires, ranging from emotional needs to physical cravings, creating a profound impact on daily lif", "Compulsive Urges: Desire's Grip may manifest as compulsive urges, compelling individuals to pursue their desires with an intensity that exceeds normal behavioral patterns.", "Emotional Turmoil: Those affected may undergo emotional turmoil, as the relentless grip of desires can lead to inner conflict, impacting mental well-being and interpersonal relationships."]),
    // STI("Intrigue Infection", 52, 104, "Intrigue Infection introduces a set of intriguing symptoms believed to arise from mysterious sources. Should you suspect infection, pay attention to the following signs. Seeking timely medical advice is essential, and our app aims to provide information and support for those navigating the enigmatic challenges associated with Intrigue Infection.", ["Cryptic Thoughts and Ideas: Affected individuals may experience a heightened sense of intrigue, often accompanied by an influx of cryptic thoughts and ideas, contributing to a sense of mystery surrounding this fictional condition.", "Paradoxical Emotions: Intrigue Infection may induce paradoxical emotional states, leading to a mix of curiosity, fascination, and occasional confusion, creating a unique psychological landscape.", "Paradoxical Emotions: Intrigue Infection may induce paradoxical emotional states, leading to a mix of curiosity, fascination, and occasional confusion, creating a unique psychological landscape."]),
    // STI("Sensation Syndrome", 1, 3, "", []),
  ];

  final IExposureRepository _exposureRepository;
  final ContactService _contactService;
  final CryptographyService _cryptographyService;
  final PushNotificationService _pushNotificationService;
  final UpsiContractService _upsiContractService;

  ExposureService(this._exposureRepository, this._contactService, this._cryptographyService, this._pushNotificationService, this._upsiContractService);

  Future<List<Exposure>> getAll() async {
    _exposures ??= await _exposureRepository.getAll();
    return _exposures!;
  }

  Future<void> save(Exposure exposure) async {
    final exposures = await getAll();
    exposures.add(exposure);
    await _exposureRepository.save(exposure);
  }

  Future<void> checkNewInfectionEvents() async {
    final infectionEvents = await _upsiContractService.getNewInfectionEvents();
    for (InfectionEvent infectionEvent in infectionEvents.reversed) {
      if(! await _signatureIsValid(infectionEvent)) {
        return;
      }

      final infection = _getInfectionFromName(infectionEvent.infection);
      final exposureDuration = Duration(days: infection.exposureDays);
      final exposureCutOffDate = DateTime.now().subtract(exposureDuration).toUtc();

      if (await _hadContactWithInfecteeSince(infectionEvent.infectee, exposureCutOffDate)) {
        _pushNotificationService.show("upsi", "Possible Exposure"); //todo: translation keys
        save(Exposure(infection: infection, testTime: infectionEvent.testTime));
      }
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

  Infection _getInfectionFromName(String name) {
    return _infections.firstWhere((i) => i.key == name);
  }

  Future<bool> _signatureIsValid(InfectionEvent infectionEvent) async {
    return await _cryptographyService.verifyInfectionEvent(infectionEvent);
  }


}
