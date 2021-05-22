import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:teh_localiza/app/resources/string.dart';
import 'package:teh_localiza/app/resources/theme.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.theme,
      navigatorKey: Modular.navigatorKey,
      initialRoute: Modular.initialRoute,
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
