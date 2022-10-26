import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/models/quick_add_tem_add_m.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SetPasswordController extends GetxController {
  List<bool?> answers = [];
  KeyValue? selectedItem;
  List<KeyValue> items = [
    KeyValue('1', 'driver'.tr),
    KeyValue('2', 'warehouse'.tr)
  ];
  List<KeyValue> locations = [];
  KeyValue? selectedLocation;
  String password = '';
  String rePassword = '';

  QuickAddTempAdd? result;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<dynamic> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Please enable location permission from setting';
    }

    return await Geolocator.getCurrentPosition();
  }

  bool validate() {
    return formKey.currentState!.validate() &&
        selectedLocation != null &&
        selectedItem != null;
  }

  Future<String> getBranchInfo() async {
    final location = await determinePosition();
    if (location is String) {
      return location;
    }
    final response = await Services.shared
        .getBranchInfo(location.latitude, location.longitude);
    if (response.result is List) {
      for (var item in response.result) {
        locations.add(KeyValue.fromJson(item));
      }
    }
    selectedItem = answers.first! ? items.first : items.last;
    selectedLocation = locations.first;
    return response.errorMessage;
  }

  Future<String> addPassword() async {
    final response = await Services.shared.addPassword(password, rePassword);
    return response.errorMessage;
  }

  Future<String> updateTempPwdInfo() async {
    final response = await Services.shared.updateTempPwdInfo();
    return response.errorMessage;
  }
}
