import 'package:ba_app/view/components/camera.dart';
import 'package:ba_app/view/components/qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ExchangeStateEnum { qr, camera }

class ContactExchange extends HookConsumerWidget {
  const ContactExchange({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeState = useState(ExchangeStateEnum.qr);

    final cameraIcon = const Icon(Icons.photo_camera, size: 30);
    final qrIcon = const Icon(Icons.qr_code_2, size: 32);

    final isQrActive = exchangeState.value == ExchangeStateEnum.qr;

    final toggleWidget = () => exchangeState.value = (isQrActive ? ExchangeStateEnum.camera : ExchangeStateEnum.qr);

    final onQrError = (BuildContext context, Object error) {
      // todo: needed?
      debugPrint("qr error");
    };

    final onQrDetect = (String qr) {
      debugPrint("qr scanned: $qr");
      toggleWidget();

      // todo: i18n: contact saved
      Fluttertoast.showToast(
        // msg: 'contact saved',
        msg: qr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    };


    final activeWidget = isQrActive ? const Qr() : Camera(onQrError: onQrError, onQrDetect: onQrDetect);

    final activeIcon = isQrActive ? cameraIcon : qrIcon;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = constraints.maxWidth;

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: cardSize,
              height: cardSize,
              child: Card(child: activeWidget),
            ),
            Align(
              alignment: const Alignment(0, 0.75), // middle of width, 75% of height
              child: FloatingActionButton(
                onPressed: toggleWidget,
                child: activeIcon,
              ),
            ),
          ],
        );
      },
    );
  }
}
