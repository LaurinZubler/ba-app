import 'package:ba_app/view/components/camera.dart';
import 'package:ba_app/view/components/qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ExchangeStateEnum { qr, camera }

class ContactExchange extends HookConsumerWidget {
  const ContactExchange({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeState = useState(ExchangeStateEnum.qr);

    const cameraIcon = Icon(Icons.photo_camera, size: 30);
    const qrIcon = Icon(Icons.qr_code_2, size: 32);

    final isQrActive = exchangeState.value == ExchangeStateEnum.qr;

    toggleWidget() => exchangeState.value = (isQrActive ? ExchangeStateEnum.camera : ExchangeStateEnum.qr);

    onQrError(String msg) {
      // todo: needed?
      // todo: if permission denied: toast
    }

    onQrDetect(String qr) {
      debugPrint("qr scanned: $qr");
      toggleWidget();

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.contactSaved,
        // msg: qr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    }

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
