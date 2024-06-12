import 'dart:async';

import 'package:upsi_core/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:upsi_user/application/provider/exposure_service_provider.dart';
import 'package:upsi_user/presentation/views/home_view.dart';
import 'package:workmanager/workmanager.dart';

const fetchNewInfectionsTask = "ch.ost.laurin.ba.upsi.upsi_user.fetchNewInfectionsTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == fetchNewInfectionsTask) {
      print("fetchNewInfectionsTask");
      await dotenv.load(fileName: ".env");
      final container = ProviderContainer();
      final exposureService = container.read(exposureServiceProvider);
      await exposureService.checkNewInfectionForPossibleExposure();
      container.dispose();
    }
    return Future.value(true);
  });
}

void main() async {
  await dotenv.load(fileName: ".env");

  Workmanager().initialize(callbackDispatcher);

  // android min frequency is 15 min. workaround: register multiple background tasks with different initial delays.
  const taskIntervalSeconds = 15;
  const androidMinFrequencyMinutes = 15;
  const i = 0;
  // for(int i = 0; i < androidMinFrequencyMinutes * taskIntervalSeconds; i++) {
    Workmanager().registerPeriodicTask (
      "periodic-task-identifier-$i",
      fetchNewInfectionsTask,
      frequency: const Duration(minutes: androidMinFrequencyMinutes),
      initialDelay: Duration(seconds: i * taskIntervalSeconds),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  // }

  runApp(const ProviderScope(child: App()));
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // disable screen rotation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: "upsi",
      theme: UpsiTheme.yellow,
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,

      // load translations using dynamic keys: https://stackoverflow.com/a/76530208
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeView()
    );
  }
}