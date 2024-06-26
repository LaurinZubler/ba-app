import 'package:upsi_core/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:upsi_tester/presentation/views/home_view.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: App()));
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // disable screen rotation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: "tester",
      theme: UpsiTheme.red,
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,

      // load translations using dynamic keys: https://stackoverflow.com/a/76530208
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeView()
    );
  }
}