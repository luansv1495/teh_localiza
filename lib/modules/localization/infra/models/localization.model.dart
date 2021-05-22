import 'package:teh_localiza/modules/localization/domain/entities/localization.entity.dart';

class LocalizationModel extends Localization {
  LocalizationModel({
    double latitude,
    double longitude,
    int createdAt,
    String address,
    String clientUid,
  }) : super(
          latitude: latitude,
          longitude: longitude,
          createdAt: createdAt,
          address: address,
          clientUid: clientUid,
        );

  Map<String, dynamic> toMap() {
    return {
      'latitude': this.latitude,
      'longitude': this.longitude,
      'createdAt': this.createdAt,
      'address': this.address,
      'clientUid': this.clientUid,
    };
  }

  factory LocalizationModel.fromMap(Map<String, dynamic> map) {
    return LocalizationModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: map['createdAt'],
      address: map['address'],
      clientUid: map['clientUid'],
    );
  }
}
