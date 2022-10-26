import 'package:device_info/device_info.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/models/quick_add_tem_add_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'dart:io';
import 'package:flutter/services.dart';

class QuickTempAddController extends GetxController {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  List<KeyValue> salutation = [];

  List<bool?> answers = [];
  KeyValue? selectedItem;
  KeyValue selectedSalutation = KeyValue('', '');
  List<KeyValue> items = [
    KeyValue('1', 'driver'.tr),
    KeyValue('2', 'warehouse'.tr)
  ];
  List<KeyValue> locations = [];
  KeyValue? selectedLocation;
  String firstName = '';
  String lastName = '';
  String emailAddress = '';
  String phoneNo = '';
  QuickAddTempAdd? result;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    _deviceData = deviceData;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

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
        selectedItem != null &&
        selectedSalutation.id.isNotEmpty;
  }

  Future<String> getBranchInfo() async {
    await initPlatformState();
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
      selectedItem = answers.first! ? items.first : items.last;
      selectedLocation = locations.first;
    }

    if (response.errorMessage.isEmpty) return await getSalutationDropdownInfo();

    return response.errorMessage;
  }

  Future<String> getSalutationDropdownInfo() async {
    final response = await Services.shared.getSalutationDropdownInfo();
    if (response.result['salutation'] is List) {
      salutation.add(KeyValue('', 'Please select option'));
      for (var i in response.result['salutation']) {
        salutation.add(KeyValue.fromJson(i));
      }
      selectedSalutation = salutation.first;
    }
    return '';
  }

  Future<String> addQuickTemp() async {
    await initPlatformState();
    final response = await Services.shared.addQuickTemp(
      emailAddress,
      firstName,
      lastName,
      selectedItem!.id,
      selectedLocation!.id,
      _deviceData.toString(),
      phoneNo,
      selectedSalutation.id,
    );
    if (response.errorMessage.isEmpty) {
      result = QuickAddTempAdd.fromJson(response.result);
      await localStorage?.setInt('tempUserId', result!.userid);
      await localStorage?.setInt('tempTid', result!.tid);
      await Services.shared.setData();
    }
    return response.errorMessage;
  }
}
