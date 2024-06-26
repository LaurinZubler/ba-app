import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:upsi_core/application/dto/proofOfAttendance/proof_of_attendance_dto.dart';
import 'package:upsi_core/presentation/components/qr.dart';
import 'package:upsi_core/presentation/theme.dart';

import '../provider/infection_event_qr_data_provider.dart';
import '../../application/provider/qr_code_service_provider.dart';

class PoASignView extends HookConsumerWidget {
  final ProofOfAttendance _poa;

  const PoASignView(this._poa, {super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Theme(
      data: UpsiTheme.red,
      child: Builder(builder: (context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
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
                    alignment: const Alignment(-1, -0.82),
                    child: Text(
                      AppLocalizations.of(context)!.poa_title,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0), // center screen
                    child: SizedBox(
                      width: cardSize,
                      height: cardSize,
                      child: Consumer (builder: (context, ref, child) {
                        final qrCodeService = ref.watch(qrCodeServiceProvider);
                        final AsyncValue<String> signedPoAAsync = ref.watch(createInfectionEventProvider(qrCodeService, _poa));
                        return switch (signedPoAAsync) {
                            AsyncData(:final value) => Qr(qrData: value, padding: const EdgeInsets.all(0)),
                            AsyncError() => const Center(child: Text('Oops, something unexpected happened')),
                            _ => const Center(child: Text('Loading'))
                          };
                      })
                    )
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
