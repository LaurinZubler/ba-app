import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/camera.dart';
import '../components/qr.dart';
import '../theme.dart';

enum ExchangeStateEnum{ qr, camera}

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

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

    final activeWidget = isQrActive ?
        const Qr() :
        Camera(onQrError: onQrError, onQrDetect: onQrDetect);

    final activeIcon = isQrActive ? cameraIcon : qrIcon;

    final AnimationController controller = useAnimationController(
      duration: const Duration(seconds: 3),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                alignment: const Alignment(-1, -0.85),
                child: Text(
                  AppLocalizations.of(context)!.title,
                  style: Theme.of(context).textTheme.displayLarge
                ),
              ),
              Align(
                alignment: const Alignment(0, 0), // center screen
                child: SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: Card(child: activeWidget),
                )
              ),
              Align(
                alignment: const Alignment(0, 0.75), // middle of width, 75% of height
                child: FloatingActionButton(
                  onPressed: toggleWidget,
                  child: activeIcon,
                ),
              ),

              // Expanded(
              //   flex: 1,
              //   child: DraggableScrollableSheet(
              //     initialChildSize: 0.25,
              //     minChildSize: 0.25,
              //     maxChildSize: 1,
              //     builder: (BuildContext context, ScrollController scrollController) {
              //       return Card(
              //         child: ListView(
              //           controller: scrollController,
              //           children: const [
              //             ListTile(
              //               leading: Icon(Icons.warning_rounded, size: 30),
              //               title: Text('Possible exposure!'),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // )
            ]
          );
        })
      ),
      bottomSheet: BottomSheet(
        onClosing: () {  },
        animationController: controller,
        builder: (BuildContext context) {

          final secondaryColor = Theme.of(context).colorScheme.secondary;

          final border = BorderSide(
            color: secondaryColor,
            width: 4,
          );

          return Container(
            margin: const EdgeInsets.only(left: 32, top: 32, right: 32),
            // margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              border: Border(top: border, left: border, right: border),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: ListTile(
              leading: Icon(
                  Icons.warning_rounded,
                  size: 32,
                  color: secondaryColor,
              ),
              title: Text(
                AppLocalizations.of(context)!.possibleExposure,
                style: Theme.of(context).textTheme.titleLarge
              )
              // trailing: Icon(Icons.arrow_right),
            ),
          );
        },
      ),
    );
  }
}
