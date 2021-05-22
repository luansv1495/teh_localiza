import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:connectivity/connectivity.dart';
import 'package:string_validator/string_validator.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.entity.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.validator.dart';
import 'package:teh_localiza/modules/localization/domain/usecases/get.usecase.dart';
import 'package:teh_localiza/modules/localization/domain/usecases/get_client_uid.usecase.dart';
import 'package:teh_localiza/modules/localization/domain/usecases/received.usecase.dart';
import 'package:teh_localiza/modules/localization/domain/usecases/send.usecase.dart';
import 'package:teh_localiza/modules/localization/external/drivers/geolocator.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/mqtt.driver.dart';

class LocalizationController {
  final MqttDriver mqttDriver;
  final GeolocatorDriver geolocatorDriver;
  final GetClientUidUseCase getClientUidUseCase;
  final GetUseCase getUseCase;
  final ReceivedUseCase receivedUseCase;
  final SendUseCase sendUseCase;

  String clientUid;
  final ValueNotifier<bool> mqttConnecting = ValueNotifier<bool>(false);
  final ValueNotifier<bool> mqttInitialized = ValueNotifier<bool>(false);

  LatLng defaultLatLon = LatLng(51.5, -0.09);

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController codeFormController = TextEditingController();

  final ValueNotifier<Localization> localization = ValueNotifier<Localization>(
    null,
  );
  final ValueNotifier<Localization> localizationSearch =
      ValueNotifier<Localization>(
    null,
  );
  final ValueNotifier<String> address = ValueNotifier<String>("");
  final ValueNotifier<bool> connected = ValueNotifier<bool>(false);
  final ValueNotifier<bool> addressLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> sharing = ValueNotifier<bool>(false);
  final ValueNotifier<bool> viewMap = ValueNotifier<bool>(false);
  final ValueNotifier<bool> searching = ValueNotifier<bool>(false);
  final ValueNotifier<String> codeSearch = ValueNotifier<String>(null);
  final ValueNotifier<Localization> lastLocalizations =
      ValueNotifier<Localization>(
    Localization(
      latitude: 51.5,
      longitude: -0.09,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ),
  );

  final MapController mapController;

  LocalizationController({
    this.mapController,
    this.mqttDriver,
    this.geolocatorDriver,
    this.getClientUidUseCase,
    this.getUseCase,
    this.receivedUseCase,
    this.sendUseCase,
  });

  Future init() async {
    await initMqtt();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      this.getUserPosition();
    });
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<bool> checkGps() async {
    try {
      Position position = await geolocatorDriver.getCurrentPosition();
      if (position != null) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<bool> checkInitialConnection() async {
    bool gpsOperational = await checkGps();

    bool isconnected = await checkInternet();
    if (isconnected == true && gpsOperational == true) {
      connected.value = true;
      return true;
    }
    connected.value = false;
    return false;
  }

  Future initMqtt() async {
    mqttConnecting.value = true;

    var result = await getClientUidUseCase();

    result.fold((l) => print(l.message), (r) => clientUid = r);

    await mqttDriver.init(
      clientUid: clientUid,
      brokerUrl: '198.199.66.138',
      brokerPort: 1883,
      user: 'ecofire-sistema',
      password: 'ecofire-sistema-2019',
      debug: false,
      callback: receivedLocalization,
    );
    mqttConnecting.value = false;
    mqttInitialized.value = true;
  }

  receivedLocalization(String message, String topic) async {
    if (topic == codeSearch.value) {
      print('Received message:$message from topic: $topic');

      Map payload = jsonDecode(message);

      var result = await receivedUseCase(
        localizationValidator: LocalizationValidator.toReceived(
          latitude: payload['latitude'],
          longitude: payload['longitude'],
          createdAt: payload['createdAt'],
          clientUid: topic,
        ),
      );

      result.fold((l) => print(l.message), (position) {
        localizationSearch.value = position;
        address.value = position.address;
      });

      changeMapPosition(
        latitude: localizationSearch.value.latitude,
        longitude: localizationSearch.value.longitude,
      );
    }
  }

  localizeCode() {
    try {
      if (globalKey.currentState.validate()) {
        if (codeFormController.text == clientUid) {
          return;
        }
        if (codeSearch.value != null) {
          if (isUUID(codeSearch.value)) {
            mqttDriver.client.unsubscribe(codeSearch.value);
          }
        }
        codeSearch.value = codeFormController.text;
        mqttDriver.client.subscribe(codeSearch.value, mqtt.MqttQos.atLeastOnce);
        searchLocalization(true);
      }
    } catch (e) {
      print("localizeCode->" + e.toString());
    }
  }

  String validateCodeUuid(String code) {
    if (code.length == 36) {
      if (!isUUID(code)) {
        return "Código inválido";
      }
    }
    if (code.length != 36) {
      return "O código deve possuir 36 digitos";
    }
    if (code == clientUid) {
      return "O código não pode ser o mesmo que o seu";
    }
    return null;
  }

  searchLocalization(bool value) {
    print('searchLocalization->' + value.toString());
    searching.value = value;
    address.value = "";
    if (sharing.value == true && value == true) {
      shareLocalization(false);
    }
    if (value == false) {
      viewMap.value = false;
      codeFormController.clear();
      if (codeSearch.value != null) {
        if (isUUID(codeSearch.value)) {
          mqttDriver.client.unsubscribe(codeSearch.value);
        }
      }
    }
  }

  shareLocalization(bool value) {
    print('shareLocalization->' + value.toString());
    sharing.value = value;
    address.value = "";
    if (searching.value == true && value == true) {
      searchLocalization(false);
    }
    if (value == true) {
      this.getUserPosition();
    } else if (value == false) {
      viewMap.value = false;
    }
  }

  setIsViewMap(bool value) {
    viewMap.value = value;
  }

  changeMapPosition({double latitude, double longitude}) {
    if (viewMap.value == true) {
      mapController.move(
        LatLng(
          latitude,
          longitude,
        ),
        mapController.zoom,
      );

      lastLocalizations.value = Localization(
        latitude: latitude,
        longitude: longitude,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void getUserPosition() async {
    if (sharing.value == false || connected.value == false) {
      return;
    }

    var result = await getUseCase();

    result.fold((l) => print(l.message), (position) async {
      localization.value = Localization(
        latitude: position.latitude,
        longitude: position.longitude,
        createdAt: position.createdAt,
        address: position.address,
      );

      address.value = position.address;

      changeMapPosition(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      var result = await sendUseCase(
        localizationValidator: LocalizationValidator.toSend(
          latitude: position.latitude,
          longitude: position.longitude,
          createdAt: position.createdAt,
          clientUid: position.clientUid,
        ),
      );

      result.fold((l) => print(l.message), (sended) {
        if (sended == true) {
          print("mensagem enviada");
        } else {
          print("mensagem não enviada");
        }
      });
    });
  }
}
