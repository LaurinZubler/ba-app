import 'package:ba_app/view/components/camera.dart';
import 'package:ba_app/view/components/qr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ExchangeStateEnum { qr, camera }

final exchangeStateProvider = StateProvider<ExchangeStateEnum>((ref) => ExchangeStateEnum.qr);

class ContactExchange extends HookConsumerWidget {
  const ContactExchange({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cameraIcon = const Icon(Icons.camera_alt, size: 30);
    var qrIcon = const Icon(Icons.qr_code_2, size: 32);

    var qr = const Qr();
    var camera = const Camera();

    isQrActive() => ref.watch(exchangeStateProvider) == ExchangeStateEnum.qr;
    toggleState() => ref.read(exchangeStateProvider.notifier).state = isQrActive() ? ExchangeStateEnum.camera : ExchangeStateEnum.qr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Center(child: isQrActive() ? qr : camera)),
        Expanded(child: Center(child: FloatingActionButton(
          onPressed: () => {toggleState()},
          child: isQrActive() ? cameraIcon : qrIcon,
        ))),
      ],
    );
  }
}