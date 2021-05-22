import 'package:teh_localiza/modules/localization/domain/entities/localization.validator.dart';
import 'package:teh_localiza/modules/localization/external/drivers/geocoder.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/geolocator.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/mqtt.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/preferences.driver.dart';
import 'package:teh_localiza/modules/localization/external/drivers/uuid.driver.dart';
import 'package:teh_localiza/modules/localization/infra/datasources/localization.datasource.interface.dart';
import 'package:teh_localiza/modules/localization/infra/models/localization.model.dart';
import 'dart:convert';

class LocalizationDataSourceImpl implements LocalizationDataSourceInterface {
  final Future<PreferencesDriver> preferencesDriver;
  final GeolocatorDriver geolocatorDriver;
  final GeoCoderDriver geoCoderDriver;
  final UuidDriver uuidDriver;
  final MqttDriver mqttDriver;

  LocalizationDataSourceImpl({
    this.preferencesDriver,
    this.geolocatorDriver,
    this.geoCoderDriver,
    this.uuidDriver,
    this.mqttDriver,
  });

  @override
  Future<LocalizationModel> received({
    LocalizationValidator localizationValidator,
  }) async {
    var address = await geoCoderDriver.getFullAddress(
      latitude: localizationValidator.latitude,
      longitude: localizationValidator.longitude,
    );

    LocalizationModel localizationModel = LocalizationModel(
      latitude: localizationValidator.latitude,
      longitude: localizationValidator.longitude,
      createdAt: localizationValidator.createdAt,
      clientUid: localizationValidator.clientUid,
      address: address,
    );

    return localizationModel;
  }

  @override
  Future<bool> send({
    LocalizationValidator localizationValidator,
  }) async {
    LocalizationModel localizationModel = LocalizationModel(
      latitude: localizationValidator.latitude,
      longitude: localizationValidator.longitude,
      createdAt: localizationValidator.createdAt,
    );

    int msgId = mqttDriver.publish(
      message: jsonEncode(localizationModel.toMap()),
      topic: localizationValidator.clientUid,
    );

    if (msgId == null) {
      return false;
    }

    return true;
  }

  @override
  Future<LocalizationModel> get() async {
    await geolocatorDriver.requestPermissions();

    var position = await geolocatorDriver.getCurrentPosition();

    var address = await geoCoderDriver.getFullAddress(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    var clientUid = (await preferencesDriver).getString('clientUid');

    LocalizationModel localizationModel = LocalizationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      address: address,
      clientUid: clientUid,
    );

    return localizationModel;
  }

  @override
  Future<String> getClientUid() async {
    String clientUid;
    final prefs = await preferencesDriver;

    clientUid = prefs.getString('clientUid');

    if (clientUid == null) {
      clientUid = uuidDriver.generateUuidV4();

      await prefs.setString('clientUid', clientUid);
    }

    return clientUid;
  }
}
