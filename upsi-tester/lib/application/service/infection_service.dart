import 'package:upsi_core/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:upsi_tester/data/i_internez.dart';

class InfectionService {
  final IInternez _internez;

  InfectionService(this._internez);

  Future<void> publishInfection(InfectionEvent event) async {
    const url = 'https://upsi-server.azurewebsites.net/api/UpsiContract/InfectionEvent';
    final infectionEvent = event.copyWith(infection: "SMILING_SYNDROME");
    await _internez.post(url, infectionEvent.toJsonString());
  }
}
