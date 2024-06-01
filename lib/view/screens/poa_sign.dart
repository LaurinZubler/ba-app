import 'package:ba_app/application/service/qr_code_service.dart';
import 'package:ba_app/domain/proofOfAttendance/proof_of_attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/provider/qr_code_service_provider.dart';
import '../components/qr.dart';
import '../theme.dart';

class PoASignView extends HookConsumerWidget {
  final ProofOfAttendance _poa;

  const PoASignView(this._poa, {super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final activeWidget = useState<Widget>(const CircularProgressIndicator());
    final qrCodeService = ref.watch(qrCodeServiceProvider);
    final signedPoA = useState("");

    qrCodeService.signPoA(_poa)
      .then((value) => {signedPoA.value = value})
      .onError((error, stackTrace) => {});
      // .onError((error, stackTrace) => {activeWidget.value = const Text('Error signing PoA')}); todo: why not possible??


    return Theme(
      data: UpsiTheme.red,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: UpsiTheme.systemUiOverlayStyle,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: LayoutBuilder(builder: (context, constraints) {
              final cardSize = constraints.maxWidth;
              return Stack(
                children: [
                  Align(
                    alignment: const Alignment(0, 0), // center screen
                    child: SizedBox(
                      width: cardSize,
                      height: cardSize,
                      child: Card(child: Qr(qrData: signedPoA.value)),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
