import 'package:better_uuid/uuid.dart';

class UuidDriver {
  String generateUuidV4() {
    return Uuid.v4().toString();
  }
}
