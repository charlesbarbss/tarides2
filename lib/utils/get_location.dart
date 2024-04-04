import 'dart:convert';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tarides/utils/keys.dart';
import 'package:http/http.dart' as http;

Future<String> getAddressFromLatLng(double lat, double lng) async {
  final currentAddress =
      await GeoCode().reverseGeocoding(latitude: lat, longitude: lng);
  return currentAddress.city!;
}
