import 'package:upsi_core/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:upsi_core/domain/repository/i_infection_repository.dart';
import 'package:upsi_tester/data/i_internez.dart';

class InfectionService {
  final IInternez _internez;
  final IInfectionRepository _infectionRepository;

  InfectionService(this._internez, this._infectionRepository);

  Future<void> publishInfection(InfectionEvent infection) async {
    const url = 'https://upsi-server.azurewebsites.net/api/UpsiContract/InfectionEvent';

    // get random infection
    final infections = await _infectionRepository.getAll();
    infections.shuffle();
    final key = infections.first.key;

    final infectionEvent = infection.copyWith(infection: key);
    await _internez.post(url, infectionEvent.toJsonString());
  }
}
