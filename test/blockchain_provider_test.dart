import 'package:ba_app/application/global.dart';
import 'package:ba_app/infrastructure/ethereum_rpc_procider.dart';
import 'package:ba_app/infrastructure/i_blockchain_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/web3dart.dart';

// 12602065
void main() {
  late IBlockchainProvider blockchainProvider;

  setUp(() {
    blockchainProvider = EthereumRPCProvider();
  });

  group('Blockchain Integration Test', () {
    test('success', () async {
      const blockWithEvent = BlockNum.exact(12602065);
      final events = await blockchainProvider.getLogs(Global.upsiContractAddress, Global.upsiInfectionEventTopic, blockWithEvent, blockWithEvent);
      expect(events, isNotNull);
      expect(events.length, 1);
      expect(events[0].data, "0x00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b3200000000000000000000000000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000000373746900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000281a7a94b24ab24bfe2d4f6c4fabfb766ca07b32000000000000000000000000000000000000000000000000000000000000000a313731353639343939350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000097369676e61747572650000000000000000000000000000000000000000000000");
    });
  });
}
