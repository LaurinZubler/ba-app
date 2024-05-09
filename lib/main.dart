import 'package:ba_app/view/screens/home.dart';
import 'package:ba_app/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // disable screen rotation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // hide android status and nav bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

    return MaterialApp(
      title: "upsi",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: UpsiTheme.light,
      home: const HomeView()
    );
  }
}