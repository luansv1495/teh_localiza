import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:teh_localiza/app/app.controller.dart';
import 'package:teh_localiza/app/app.widget.dart';
import 'package:teh_localiza/modules/localization/localizaztion.module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        ...LocalizationModule.export,
        Bind((i) => AppController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          module: LocalizationModule(),
          transition: TransitionType.noTransition,
        ),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
