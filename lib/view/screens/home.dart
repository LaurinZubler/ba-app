import 'package:ba_app/application/service/qr_code_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../application/provider/qr_data_provider.dart';
import 'exposure_info.dart';
import '../components/camera.dart';
import '../components/qr.dart';
import '../theme.dart';

enum ExchangeStateEnum { qr, camera }

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeState = useState(ExchangeStateEnum.qr);
    final qrCodeServiceAsync = ref.watch(qrCodeServiceProvider);
    final qrCodeDataAsync = ref.watch(qrCodeDataProvider);

    const cameraIcon = Icon(Icons.photo_camera, size: 30);
    const qrIcon = Icon(Icons.qr_code_2, size: 32);

    final isQrActive = exchangeState.value == ExchangeStateEnum.qr;

    toggleWidget() => exchangeState.value = (isQrActive ? ExchangeStateEnum.camera : ExchangeStateEnum.qr);

    void onQrError(String msg) {
      // TODO: needed?
      // TODO: if permission denied: toast
    }

    void onQrDetect(String scan) {
      debugPrint("QR scanned: $scan");
      toggleWidget();

      qrCodeServiceAsync.when(
        data: (qrCodeService) {
          try {
            qrCodeService.handleQrCode(scan);
            Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.home_contactSaved,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
            );
          } catch (e) {
            // TODO: wrong qr data, or expired
            Fluttertoast.showToast(
              msg: "Error processing QR data",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
            );
          }
        },
        loading: () => Fluttertoast.showToast(
          msg: "Loading QR code service...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        ),
        error: (err, stack) => Fluttertoast.showToast(
          msg: "Error loading QR code service: $err",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        ),
      );
    }

    Widget getQROrSpinner() {
      return qrCodeDataAsync.when(
        data: (qrData) {
          return Qr(qrData: qrData);
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => const CircularProgressIndicator(),
      );
    }

    final activeWidget = isQrActive ? getQROrSpinner() : Camera(onQrError: onQrError, onQrDetect: onQrDetect);

    final activeIcon = isQrActive ? cameraIcon : qrIcon;

    final controller = useAnimationController(
      duration: const Duration(seconds: 3),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: UpsiTheme.systemUiOverlayStyle,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => {},
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        decoration: UpsiTheme.homeBackground,
        child: LayoutBuilder(builder: (context, constraints) {
          final cardSize = constraints.maxWidth;
          return Stack(
            children: [
              Align(
                alignment: const Alignment(-1, -0.82),
                child: Text(
                  AppLocalizations.of(context)!.home_title,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0), // center screen
                child: SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: Card(child: activeWidget),
                ),
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
        }),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        animationController: controller,
        builder: (BuildContext context) {
          final secondaryColor = Theme.of(context).colorScheme.secondary;
          final border = BorderSide(
            color: secondaryColor,
            width: 4,
          );

          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExposureInfoView())),
            child: Container(
              margin: const EdgeInsets.only(left: 24, top: 24, right: 24),
              decoration: BoxDecoration(
                border: Border(top: border, left: border, right: border),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: ListTile(
                iconColor: secondaryColor,
                textColor: secondaryColor,
                visualDensity: VisualDensity.comfortable,
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: UpsiTheme.sfProDisplay,
                ),
                leading: const Icon(Icons.warning_rounded, size: 32),
                trailing: const Icon(Icons.arrow_right),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.home_warning,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                )
              ),
            ),
          );
        },
      ),
    );
  }
}
