import 'package:flutter/material.dart';
import 'package:ba_app/domain/sti/sti_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme.dart';

class ExposureInfoView extends HookConsumerWidget {
  const ExposureInfoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    const sti = STI(key: "smilingSyndrome", numberOfSymptoms: 3);

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        systemOverlayStyle: UpsiTheme.systemUiOverlayStyle,
        foregroundColor: UpsiTheme.secondaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Stack(
            children: [
              Align(
                alignment: const Alignment(-1, -0.82),
                child: Text(
                  AppLocalizations.of(context)!.sti_name(sti.key),
                  style: Theme.of(context).textTheme.displayLarge
                ),
              ),
            ]
        )
      )
    );
  }
}