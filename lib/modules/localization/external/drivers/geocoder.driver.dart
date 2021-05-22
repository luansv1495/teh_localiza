import 'package:geocoder/geocoder.dart';

class GeoCoderDriver {
  Future<String> getFullAddress({double latitude, double longitude}) async {
    Coordinates coordinates = new Coordinates(
      latitude,
      longitude,
    );

    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(
      coordinates,
    );

    Address fAddress = addresses.first;

    List<String> lAdressCheck = [
      fAddress.locality,
      fAddress.adminArea,
      fAddress.subLocality,
      fAddress.subAdminArea,
      fAddress.addressLine,
    ];

    List<String> lAdress = [];

    lAdressCheck.forEach((element) {
      if (element != null) {
        lAdress.add(element);
      }
    });

    return lAdress.join(", ");
  }
}
