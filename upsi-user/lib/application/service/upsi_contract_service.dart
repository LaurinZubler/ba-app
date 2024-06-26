import 'package:upsi_core/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:upsi_user/domain/repository/i_block_repository.dart';
import 'package:web3dart/web3dart.dart';
import '../../data/i_blockchain_service.dart';
import 'package:upsi_core/global.dart';

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
    var lastCheckedBlockNumber = await _blockRepository.get();

    if (lastCheckedBlockNumber == Global.NO_BLOCKS_CHECKED_BLOCKNUMBER) {
      final currentBlock = await _blockchainService.getLatestBlockNumber();
      lastCheckedBlockNumber = currentBlock - 4 * 60; // check blocks of approx last hour (4 blocks per min on testnet)
      _blockRepository.save(lastCheckedBlockNumber);
    }

    lastCheckedBlockNumber++; // to not check the same bock again
    List<FilterEvent> upsiLogs = await _getLogsSinceBlock(lastCheckedBlockNumber);

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
    final infectee = List<String>.from(properties[_infecteeIndex]);
    final tester = properties[_testerIndex];
    final testTime = DateTime.fromMillisecondsSinceEpoch(properties[_testTimeIndex].toInt() * 1000).toUtc();
    final signature = properties[_signatureIndex];
    return InfectionEvent(infection: infection, infectee: infectee, tester:tester, testTime: testTime, signature: signature);
  }
}