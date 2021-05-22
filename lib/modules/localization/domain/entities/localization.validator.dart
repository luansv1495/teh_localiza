import 'package:string_validator/string_validator.dart';

class LocalizationValidator {
  final double latitude;
  final double longitude;
  final int createdAt;
  final String address;
  final String clientUid;

  LocalizationValidator._({
    this.latitude,
    this.longitude,
    this.createdAt,
    this.address,
    this.clientUid,
  });

  factory LocalizationValidator.toGet() {
    return LocalizationValidator._();
  }

  factory LocalizationValidator.toReceived({
    double latitude,
    double longitude,
    int createdAt,
    String clientUid,
  }) {
    return LocalizationValidator._(
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      address: null,
      clientUid: clientUid,
    );
  }

  factory LocalizationValidator.toSend({
    double latitude,
    double longitude,
    int createdAt,
    String clientUid,
  }) {
    return LocalizationValidator._(
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      address: null,
      clientUid: clientUid,
    );
  }

  factory LocalizationValidator.toGetClientUid({
    String clientUid,
  }) {
    return LocalizationValidator._(
      clientUid: clientUid,
    );
  }

  bool get isValidLatitude => this.latitude != null;
  bool get isValidLongitude => this.longitude != null;
  bool get isValidCreatedAt => this.createdAt != null;
  bool get isValidAddress => this.address != null;
  bool get isValidclientUid => isUUID(this.clientUid);
}
