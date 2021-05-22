import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:teh_localiza/app/app.controller.dart';
import 'package:teh_localiza/modules/localization/domain/usecases/get.usecase.dart';
import 'package:teh_localiza/modules/localization/domain/usecases/get_client_uid.usecase.dart';
import 'package:teh_localiza/modules/localization/domain/usecases/received.usecase.dart';
import 'package:teh_localiza/modules/localization/domain/usecases/send.usecase.dart';
import 'package:teh_localiza/modules/localization/external/datasources/localization.datasource.impl.dart';
import 'package:teh_localiza/modules/localization/external/drivers/geocoder.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/geolocator.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/mqtt.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/preferences.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/uuid.driver.dart';
import 'package:teh_localiza/modules/localization/infra/repositories/localization.repository.impl.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/localization.controller.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/localization.page.dart';

class LocalizationModule extends ChildModule {
  static List<Bind> export = [
    Bind(
      (i) => LocalizationController(
        mapController: MapController(),
        mqttDriver: i.get(),
        geolocatorDriver: i.get(),
        getClientUidUseCase: i.get(),
        getUseCase: i.get(),
        receivedUseCase: i.get(),
        sendUseCase: i.get(),
      ),
      singleton: true,
    ),
    Bind((i) => ReceivedUseCaseImpl(
          repository: i.get(),
        )),
    Bind((i) => GetUseCaseImpl(
          repository: i.get(),
        )),
    Bind((i) => GetClientUidUseCaseImpl(
          repository: i.get(),
        )),
    Bind((i) => SendUseCaseImpl(
          repository: i.get(),
        )),
    Bind((i) => LocalizationRepositoryImpl(
          localizationDataSourceInterface: i.get(),
        )),
    Bind(
      (i) => LocalizationDataSourceImpl(
        preferencesDriver: PreferencesDriver.getInstance(),
        geolocatorDriver: i.get(),
        geoCoderDriver: GeoCoderDriver(),
        uuidDriver: UuidDriver(),
        mqttDriver: i.get(),
      ),
      singleton: true,
    ),
    Bind(
      (i) => MqttDriver(),
      singleton: true,
    ),
    Bind(
      (i) => GeolocatorDriver(),
      singleton: true,
    ),
  ];

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, __) => LocalizationPage(),
          transition: TransitionType.noTransition,
        ),
      ];
}
