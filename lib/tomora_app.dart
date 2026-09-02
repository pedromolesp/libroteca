import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tomora/core/constants/app_constants.dart';
import 'package:tomora/core/routes/routes.dart';
import 'package:tomora/core/state_handlers/top_blocs.dart';
import 'package:tomora/core/theme/app_theme.dart';
import 'package:tomora/l10n/app_localizations.dart';

class TomoraApp extends StatelessWidget {
  const TomoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TopBlocProviders(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.light,
        routerConfig: goRouter,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
