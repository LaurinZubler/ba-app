import 'package:upsi/application/dto/infectionEvent/infection_event_dto.dart';
import 'package:upsi/application/global.dart';
import 'package:upsi/application/service/upsi_contract_service.dart';
import 'package:upsi/data/i_blockchain_service.dart';
import 'package:upsi/domain/repositories/i_block_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:web3dart/web3dart.dart';

import 'upsi_contract_service_test.mocks.dart';

@GenerateMocks([IBlockchainService, IBlockRepository])
void main() {
  late MockIBlockchainService mockBlockchainService;
  late MockIBlockRepository mockBlockRepository;
  late UpsiContractService upsiContractService;

  setUp(() {
    mockBlockchainService = MockIBlockchainService();
    mockBlockRepository = MockIBlockRepository();
    upsiContractService = UpsiContractService(mockBlockchainService, mockBlockRepository);
  });

  group('getNewInfectionEvents()', () {
    test('success', () async {
      final event = FilterEvent(removed: false, logIndex: 1, transactionIndex: 1, transactionHash: "transactionHash", blockHash: "blockHash", blockNum: 1, address: EthereumAddress.fromHex(Global.UPSI_CONTRACT_ADDRESS), data: "0x00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b3200000000000000000000000000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000000373746900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32000000000000000000000000000000000000000000000000000000000000000a313731353639343939350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000097369676e61747572650000000000000000000000000000000000000000000000", topics: [Global.UPSI_INFECTION_EVENT_TOPIC]);
      final expectedInfectionEvent = InfectionEvent(infection: "sti", infectee: ["0x281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32"], tester: "0x281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32", testTime: DateTime.fromMillisecondsSinceEpoch(1715694995000), signature: "signature");

      when(mockBlockRepository.get()).thenAnswer((_) async => 1);
      when(mockBlockchainService.getLogs(any, any, any, any)).thenAnswer((_) async => [event]);
      when(mockBlockchainService.getLatestBlockNumber()).thenAnswer((_) async => 1);

      final infectionEvents = await upsiContractService.getNewInfectionEvents();
      expect(infectionEvents.length, 1);
      expect(infectionEvents[0], expectedInfectionEvent);

      verify(mockBlockRepository.get()).called(1);
      verify(mockBlockRepository.save(any)).called(1);
      verify(mockBlockchainService.getLogs(any, any, any, any)).called(1);
      verifyNever(mockBlockchainService.getLatestBlockNumber());
    });

    test('multiple events', () async {
      final event1 = FilterEvent(removed: false, logIndex: 1, transactionIndex: 1, transactionHash: "transactionHash", blockHash: "blockHash", blockNum: 2, address: EthereumAddress.fromHex(Global.UPSI_CONTRACT_ADDRESS), data: "0x00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b3200000000000000000000000000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000000373746900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32000000000000000000000000000000000000000000000000000000000000000a313731353639343939350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000097369676e61747572650000000000000000000000000000000000000000000000", topics: [Global.UPSI_INFECTION_EVENT_TOPIC]);
      final event2 = FilterEvent(removed: false, logIndex: 1, transactionIndex: 1, transactionHash: "transactionHash", blockHash: "blockHash", blockNum: 3, address: EthereumAddress.fromHex(Global.UPSI_CONTRACT_ADDRESS), data: "0x00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b3200000000000000000000000000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000000373746900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32000000000000000000000000000000000000000000000000000000000000000a313731353639343939350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000097369676e61747572650000000000000000000000000000000000000000000000", topics: [Global.UPSI_INFECTION_EVENT_TOPIC]);
      final expectedInfectionEvent = InfectionEvent(infection: "sti", infectee: ["0x281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32"], tester: "0x281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32", testTime: DateTime.fromMillisecondsSinceEpoch(1715694995000), signature: "signature");

      when(mockBlockRepository.get()).thenAnswer((_) async => 1);
      when(mockBlockchainService.getLogs(any, any, any, any)).thenAnswer((_) async => [event1, event2]);
      when(mockBlockchainService.getLatestBlockNumber()).thenAnswer((_) async => 1);

      final infectionEvents = await upsiContractService.getNewInfectionEvents();
      expect(infectionEvents.length, 2);
      expect(infectionEvents[0], expectedInfectionEvent);
      expect(infectionEvents[1], expectedInfectionEvent);

      verify(mockBlockRepository.get()).called(1);
      verify(mockBlockRepository.save(3)).called(1);
      verifyNever(mockBlockRepository.save(2));
      verify(mockBlockchainService.getLogs(any, any, any, any)).called(1);
      verifyNever(mockBlockchainService.getLatestBlockNumber());
    });

    test('no last block', () async {
      final event = FilterEvent(removed: false, logIndex: 1, transactionIndex: 1, transactionHash: "transactionHash", blockHash: "blockHash", blockNum: 1, address: EthereumAddress.fromHex(Global.UPSI_CONTRACT_ADDRESS), data: "0x00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b3200000000000000000000000000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000000373746900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32000000000000000000000000000000000000000000000000000000000000000a313731353639343939350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000097369676e61747572650000000000000000000000000000000000000000000000", topics: [Global.UPSI_INFECTION_EVENT_TOPIC]);
      final expectedInfectionEvent = InfectionEvent(infection: "sti", infectee: ["0x281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32"], tester: "0x281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32", testTime: DateTime.fromMillisecondsSinceEpoch(1715694995000), signature: "signature");

      when(mockBlockRepository.get()).thenAnswer((_) async => Global.NO_BLOCKS_CHECKED_BLOCKNUMBER);
      when(mockBlockchainService.getLogs(any, any, any, any)).thenAnswer((_) async => [event]);
      when(mockBlockchainService.getLatestBlockNumber()).thenAnswer((_) async => 1);

      final infectionEvents = await upsiContractService.getNewInfectionEvents();
      expect(infectionEvents.length, 1);
      expect(infectionEvents[0], expectedInfectionEvent);

      verify(mockBlockRepository.get()).called(1);
      verify(mockBlockRepository.save(any)).called(1);
      verify(mockBlockchainService.getLogs(any, any, any, any)).called(1);
      verify(mockBlockchainService.getLatestBlockNumber()).called(1);
    });

    test('no new infection events', () async {
      when(mockBlockRepository.get()).thenAnswer((_) async => 1);
      when(mockBlockchainService.getLogs(any, any, any, any)).thenAnswer((_) async => []);
      when(mockBlockchainService.getLatestBlockNumber()).thenAnswer((_) async => 1);

      final infectionEvents = await upsiContractService.getNewInfectionEvents();
      expect(infectionEvents.length, 0);

      verify(mockBlockRepository.get()).called(1);
      verifyNever(mockBlockRepository.save(any));
      verify(mockBlockchainService.getLogs(any, any, any, any)).called(1);
      verifyNever(mockBlockchainService.getLatestBlockNumber());
    });
  });
}
