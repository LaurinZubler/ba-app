import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:upsi_core/presentation/theme.dart';

import '../../domain/model/infection/infection_model.dart';

class ExposureInfoView extends HookConsumerWidget {
  final Infection _infection;

  const ExposureInfoView({super.key, required Infection infection}) : _infection = infection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final symptomLabels = [
      AppLocalizations.of(context)!.symptom1_label(_infection.key),
      AppLocalizations.of(context)!.symptom2_label(_infection.key),
      AppLocalizations.of(context)!.symptom3_label(_infection.key),
    ];
    final symptomDescriptions = [
      AppLocalizations.of(context)!.symptom1_description(_infection.key),
      AppLocalizations.of(context)!.symptom2_description(_infection.key),
      AppLocalizations.of(context)!.symptom3_description(_infection.key),
    ];

    return Theme(
      data: UpsiTheme.red,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: UpsiTheme.systemUiOverlayStyle,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    AppLocalizations.of(context)!.infection_name(_infection.key),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            AppLocalizations.of(context)!.exposureInfo_moreInformation,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 32),
                          child: Text(AppLocalizations.of(context)!.infection_moreInformation(_infection.key)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      })
    );
  }
}