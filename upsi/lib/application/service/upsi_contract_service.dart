import 'package:upsi/domain/repositories/i_block_repository.dart';
import 'package:web3dart/web3dart.dart';
import '../../data/i_blockchain_service.dart';
import '../dto/infectionEvent/infection_event_dto.dart';
import '../global.dart';

class UpsiContractService {
  late final ContractEvent _infectionEventABI;
  late final IBlockchainService _blockchainService;
  late final IBlockRepository _blockRepository;

  static const int _infectionIndex = 0;
  static const int _infecteeIndex = 1;
  static const int _testerIndex = 2;
  static const int _testTimeIndex = 3;
  static const int _signatureIndex = 4;

  UpsiContractService(this._blockchainService, this._blockRepository) {
    final abi = ContractAbi.fromJson(Global.UPSI_CONTRACT_ABI, "Upsi");
    _infectionEventABI = abi.events.firstWhere((f) => f.name == "InfectionEvent", orElse: () => ContractEvent(false, "", []));
  }

  Future<List<InfectionEvent>> getNewInfectionEvents() async{
    var lastInfectionBlock = await _blockRepository.get();

    if (lastInfectionBlock == Global.NO_BLOCKS_CHECKED_BLOCKNUMBER) {
      lastInfectionBlock = await _blockchainService.getLatestBlockNumber();
    }

    List<FilterEvent> upsiLogs = await _getLogsSinceBlock(lastInfectionBlock);

    if (upsiLogs.isNotEmpty) {
      _blockRepository.save(upsiLogs.last.blockNum!);
    }

    return upsiLogs.map((log) => _convertToInfectionEvent(log)).toList();
  }

  Future<List<FilterEvent>> _getLogsSinceBlock(int fromBlock) async {
    return await _blockchainService.getLogs(Global.UPSI_CONTRACT_ADDRESS, Global.UPSI_INFECTION_EVENT_TOPIC, fromBlock, null);
  }

  InfectionEvent _convertToInfectionEvent(FilterEvent filterEvent){
    final properties = _infectionEventABI.decodeResults([Global.UPSI_INFECTION_EVENT_TOPIC], filterEvent.data!);
    final infection = properties[_infectionIndex];
    final infectee =  (List<EthereumAddress>.from(properties[_infecteeIndex] as List)).map((address) => address.hex).toList();
    final tester = (properties[_testerIndex] as EthereumAddress).hex;
    final testTime = DateTime.fromMillisecondsSinceEpoch(int.parse(properties[_testTimeIndex]) * 1000);
    final signature = properties[_signatureIndex];
    return InfectionEvent(infection: infection, infectee: infectee, tester:tester, testTime: testTime, signature: signature);
  }
}