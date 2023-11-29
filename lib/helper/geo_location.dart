import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class GeoLocation {
   String? currentAddress;
   Position? currentPosition;

   GeoLocation(){
    setAllData();
  }
  setAllData() async {
    await getCurrentPosition();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (hasPermission) {
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        currentPosition = position;
        _getAddressFromLatLng(currentPosition!);
      }).catchError((e) {
        debugPrint(e);
      });
    }else{
      return;
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placeMarks) {
      Placemark place = placeMarks[0];
        currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Location Page")),
  //     body: SafeArea(
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text('LAT: ${currentPosition?.latitude ?? ""}'),
  //             Text('LNG: ${currentPosition?.longitude ?? ""}'),
  //             Text('ADDRESS: ${currentAddress ?? ""}'),
  //             const SizedBox(height: 32),
  //             ElevatedButton(
  //               onPressed: getCurrentPosition,
  //               child: const Text("Get Current Location"),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}