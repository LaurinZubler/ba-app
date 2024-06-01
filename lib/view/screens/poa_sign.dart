import 'package:ba_app/application/service/qr_code_service.dart';
import 'package:ba_app/domain/proofOfAttendance/proof_of_attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/qr.dart';
import '../theme.dart';

class PoASignView extends HookConsumerWidget {
  final ProofOfAttendance _poa;

  const PoASignView(this._poa, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWidget = useState<Widget>(const CircularProgressIndicator());
    final qrCodeServiceAsync = ref.watch(qrCodeServiceProvider);

    useEffect(() {
      qrCodeServiceAsync.when(
        data: (qrCodeService) async {
          try {
            final signedPoA = await qrCodeService.signPoA(_poa);
            activeWidget.value = Qr(qrData: signedPoA);
          } catch (e) {
            activeWidget.value = const Text('Error signing PoA');
          }
        },
        loading: () {
          activeWidget.value = const CircularProgressIndicator();
        },
        error: (err, stack) {
          activeWidget.value = Text('Error: $err');
        },
      );
    }, [qrCodeServiceAsync]);

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
                      child: Card(child: activeWidget.value),
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
