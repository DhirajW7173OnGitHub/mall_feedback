import 'package:geocoding/geocoding.dart';

class GetLocation {
  ///get place name with lat and long
  Future<String> getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place =
          placemarks[0]; // Assuming the first result is the desired one
      String address =
          '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      print('Place Name: $address');

      return address;
    } catch (e) {
      print('Error: $e');
      throw 'Error:$e';
    }
  }
}

GetLocation getLocation = GetLocation();
