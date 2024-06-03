import 'package:ba_app/infrastructure/i_blockchain_provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../domain/infectionEvent/infection_event_model.dart';
import '../global.dart';

class UpsiContractService {
  late final ContractEvent _infectionEventABI;
  late final IBlockchainProvider _blockchainProvider;

  static const int _infectionIndex = 0;
  static const int _infecteeIndex = 1;
  static const int _testerIndex = 2;
  static const int _testTimeIndex = 3;
  static const int _signatureIndex = 4;

  UpsiContractService(String abi) {
  final abi = ContractAbi.fromJson(Global.upsiContractABI, "Upsi");
  _infectionEventABI = abi.events.firstWhere((f) => f.name == "InfectionEvent", orElse: () => ContractEvent(false, "", []));
  }

  Future<List<InfectionEvent>> getNewInfectionEvents() async{
    const lastBlock = 0; // todo get from repo
    List<FilterEvent> upsiLogs = await _getLogsSinceBlock(lastBlock);

    if (upsiLogs.isNotEmpty) {
      final newLastBlock = upsiLogs.last.blockNum!; // todo: save to repo
      return upsiLogs.map((log) => _convertToInfectionEvent(log)).toList();
    }

    return List.empty();
  }

  Future<List<FilterEvent>> _getLogsSinceBlock(int fromBlock) async {
    return await _blockchainProvider.getLogs(Global.upsiContractAddress, Global.upsiInfectionEventTopic, BlockNum.exact(fromBlock), const BlockNum.current());
  }

  InfectionEvent _convertToInfectionEvent(FilterEvent filterEvent){
    final properties = _infectionEventABI.decodeResults([Global.upsiInfectionEventTopic], filterEvent.data!);
    return InfectionEvent(infection: properties[_infectionIndex], infectee: properties[_infecteeIndex], tester: properties[_testerIndex], testTime: properties[_testTimeIndex], signature: properties[_signatureIndex]);
  }
}