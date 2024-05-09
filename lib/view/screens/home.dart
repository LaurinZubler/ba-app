import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/contact_exchange.dart';
import '../theme.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: UpsiTheme.homeBackground,
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.title),
              const Expanded(child: ContactExchange()),
            ]
          )
        ),
      ),
    );
  }
}