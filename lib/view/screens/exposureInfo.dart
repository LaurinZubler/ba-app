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

    final symptomLabels = [
      AppLocalizations.of(context)!.symptom1_label(sti.key),
      AppLocalizations.of(context)!.symptom2_label(sti.key),
      AppLocalizations.of(context)!.symptom3_label(sti.key),
    ];
    final symptomDescriptions = [
      AppLocalizations.of(context)!.symptom1_description(sti.key),
      AppLocalizations.of(context)!.symptom2_description(sti.key),
      AppLocalizations.of(context)!.symptom3_description(sti.key),
    ];

    return Theme(
      data: UpsiTheme.red,
      child: Builder(
        builder: (context) {
          return Scaffold(
            // extendBodyBehindAppBar: true,
            appBar: AppBar(
              systemOverlayStyle: UpsiTheme.systemUiOverlayStyle,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.sti_name(sti.key),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Text(
                      AppLocalizations.of(context)!.exposureInfo_actions,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ${AppLocalizations.of(context)!.exposureInfo_action1}'),
                        Text('• ${AppLocalizations.of(context)!.exposureInfo_action2}'),
                        Text('• ${AppLocalizations.of(context)!.exposureInfo_action3}'),
                        Text('• ${AppLocalizations.of(context)!.exposureInfo_action4}'),
                      ],
                    )
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      AppLocalizations.of(context)!.exposureInfo_needSupport,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.exposureInfo_hotline_label),
                              Text(
                                AppLocalizations.of(context)!.exposureInfo_hotline_nr,
                                style: Theme.of(context).textTheme.titleSmall,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.exposureInfo_web_label),
                              Text(
                                AppLocalizations.of(context)!.exposureInfo_web_url,
                                style: Theme.of(context).textTheme.titleSmall,
                              )
                            ],
                          )
                        ],
                      )
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      AppLocalizations.of(context)!.exposureInfo_symptoms,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: symptomLabels.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  symptomLabels[index],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: Text(symptomDescriptions[index]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      AppLocalizations.of(context)!.exposureInfo_moreInformation,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(AppLocalizations.of(context)!.sti_moreInformation(sti.key)),
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }
}