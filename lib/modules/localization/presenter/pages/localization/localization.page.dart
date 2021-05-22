import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:teh_localiza/app/resources/colors.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/localization.controller.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/widgets/actions_card.widget.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/widgets/code_card.widget.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/widgets/address_card.widget.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/widgets/form_code_card.widget.dart';
import 'package:teh_localiza/modules/localization/presenter/pages/localization/widgets/map_card.widget.dart';
import 'package:teh_localiza/modules/localization/resources/widgets.dart';

class LocalizationPage extends StatefulWidget {
  @override
  _LocalizationPageState createState() => _LocalizationPageState();
}

class _LocalizationPageState
    extends ModularState<LocalizationPage, LocalizationController> {
  StreamSubscription<ConnectivityResult> subscription;
  @override
  initState() {
    super.initState();
    checkNetWork();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) => checkChangeNetWork(result));
  }

  checkChangeNetWork(ConnectivityResult result) async {
    print("alterou: " + result.toString());
    bool isConnected = await controller.checkInternet();
    bool gpsOperational = await controller.checkGps();
    if (isConnected == false || gpsOperational == false) {
      controller.connected.value = false;
    }
  }

  checkNetWork() async {
    bool connected = await controller.checkInitialConnection();
    if (connected == true) {
      await controller.init();
    }
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ContainerGradient(
          colors: AppColors.moduleLocalization['pallete1'],
          child: ValueListenableBuilder<bool>(
            valueListenable: controller.mqttConnecting,
            builder: (context, isMqttConnecting, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: controller.connected,
                builder: (context, isConnected, child) {
                  print('ValueListenableBuilder->isConnected->' +
                      isConnected.toString());
                  return <Widget>[
                    InitialLoading(),
                    DisconnectedNetwork(),
                    Center(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        children: [
                          AddressCard(),
                          CodeCard(),
                          FormCodeCard(),
                          ActionsCard(),
                          MapCard(),
                        ],
                      ),
                    ),
                  ][compileByState(
                    isConnected: isConnected,
                    isMqttConnecting: isMqttConnecting,
                  )];
                },
              );
            },
          ),
        ),
      ),
    );
  }

  int compileByState({bool isMqttConnecting, bool isConnected}) {
    if (isConnected == false) {
      return 1;
    } else if (isMqttConnecting == true) {
      return 0;
    }
    return 2;
  }
}
