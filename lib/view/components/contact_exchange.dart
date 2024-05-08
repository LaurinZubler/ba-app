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
    var cameraIcon = const Icon(Icons.photo_camera, size: 30);
    var qrIcon = const Icon(Icons.qr_code_2, size: 32);

    var qr = const Qr();
    var camera = const Camera();

    isQrActive() => ref.watch(exchangeStateProvider) == ExchangeStateEnum.qr;
    toggleExchangeState() => ref.read(exchangeStateProvider.notifier).state = (isQrActive() ? ExchangeStateEnum.camera : ExchangeStateEnum.qr);

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardSize = constraints.maxWidth;

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: cardSize,
              height: cardSize,
              child: Card(child: isQrActive() ? qr : camera),
            ),
            Align(
              alignment: Alignment(0, 0.75), // middle of width, 75% of height
              child: FloatingActionButton(
                onPressed: toggleExchangeState,
                child: isQrActive() ? cameraIcon : qrIcon,
              ),
            ),
          ],
        );
      },
    );
  }
}