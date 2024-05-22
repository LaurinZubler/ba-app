import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'exposureInfo.dart';
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
        msg: AppLocalizations.of(context)!.home_contactSaved,
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

    final DraggableScrollableController sheetController = DraggableScrollableController();
    final List<String> entries = <String>['A', 'B', 'C'];

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
        // padding: const EdgeInsets.all(32),
        padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
        decoration: UpsiTheme.homeBackground,
        child: LayoutBuilder(builder: (context, constraints) {
          final cardSize = constraints.maxWidth;
          return Stack(
            children: [
              Align(
                alignment: const Alignment(-1, -0.82),
                child: Text(
                  AppLocalizations.of(context)!.home_title,
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
              DraggableScrollableSheet(
                controller: sheetController,
                initialChildSize: 0.12,
                minChildSize: 0.12,
                maxChildSize: 0.8,
                snap: true,

                builder: (BuildContext context, ScrollController scrollController) {

                  final secondaryColor = Theme.of(context).colorScheme.secondary;
                  final border = BorderSide(
                    color: secondaryColor,
                    width: 4,
                  );

                  return Container(
                    padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child:

                    // Column(
                    //   children: [

                        // GestureDetector(
                        //   // onVerticalDragUpdate: onVerticalDragUpdate,
                        //   child: Container(
                        //     width: double.infinity,
                        //     // color: colorScheme.onSurface,
                        //     child: Align(
                        //       alignment: Alignment.topCenter,
                        //       child: Container(
                        //         margin: const EdgeInsets.symmetric(vertical: 8.0),
                        //         width: 32.0,
                        //         height: 4.0,
                        //         decoration: BoxDecoration(
                        //           // color: colorScheme.surfaceContainerHighest,
                        //           borderRadius: BorderRadius.circular(8.0),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        Container(
                          decoration: BoxDecoration(
                            border: Border(top: border, left: border, right: border),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                // controller: scrollController,
                                children: [
                                  ListTile(
                                    iconColor: secondaryColor,
                                    textColor: secondaryColor,
                                    visualDensity: VisualDensity.comfortable,
                                    // contentPadding: const EdgeInsets.only(left: 16, right: 8),
                                    // horizontalTitleGap: 8,

                                    titleTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: UpsiTheme.sfProDisplay,
                                    ),

                                    leading: const Icon(Icons.warning_rounded, size: 32),
                                    title: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment.centerLeft,
                                        child: Text(AppLocalizations.of(context)!.home_warning)),
                                  ),


                                  // ListView.builder(
                                  //   shrinkWrap: true,
                                  //   physics: const NeverScrollableScrollPhysics(),
                                  //   itemCount: entries.length,
                                  //   itemBuilder: (BuildContext context, int index) {
                                  //     return ListTile(
                                  //       title: Text(entries[index])
                                  //     );
                                  //   }
                                  // ),

                                  // Flexible(
                                  //     child: ListView.builder(
                                  //         padding: const EdgeInsets.all(8),
                                  //         itemCount: entries.length,
                                  //         controller: scrollController,
                                  //         itemBuilder: (BuildContext context, int index) {
                                  //           return ListTile(
                                  //               title: Text(entries[index])
                                  //           );
                                  //         }
                                  //     )
                                  // )
                                ],
                              ),
                            )
                          ),



                      )
                      // ]
                    // )
                  );
                },
              ),
            ]
          );
        })
      ),
    );
  }
}
