import 'package:geolocator/geolocator.dart';

class QuestGeolocator {
  static const double acceptanceDistance = 100;

  static Future<Position> getPosition() async {
    bool serviceEnabled = false;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static double distance(double latitude1, double longitude1, double latitude2,
      double longitude2) {
    double x = GeolocatorPlatform.instance
        .distanceBetween(latitude1, longitude1, latitude2, longitude2);
    return x;
  }

  static bool distanceLess(double latitude1, double longitude1,
      double latitude2, double longitude2, double distance) {
    double x = GeolocatorPlatform.instance
        .distanceBetween(latitude1, longitude1, latitude2, longitude2);
    return x <= distance;
  }
}
