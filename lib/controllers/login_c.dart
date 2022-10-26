import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:extra_staff/models/quick_add_tem_add_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  String password = '';
  String emailAddress = '';
  bool withoutPassword = false;
  QuickAddTempAdd? result;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final localAuth = LocalAuthentication();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final allItems = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '+1',
    '0',
    '-1',
  ];

  Future<bool> checkAuth() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    if (!canCheckBiometrics) {
      return false;
    }

    try {
      bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'authenticateBiometric'.tr,
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      );
      print(didAuthenticate);
      return didAuthenticate;
    } on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> isBiometricsAvaliable() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    if (!canCheckBiometrics) {
      return false;
    }

    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face)) {
      return true;
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> proceed(int index) async {
    if (index == 0) {
      bool next = await checkAuth();
      if (next) {
        final response = await Services.shared.updateTempBioInfo();
        if (response.errorMessage.isNotEmpty) {
          abShowMessage(response.errorMessage);
          return false;
        }
      }
      return next;
    }
    return true;
  }

  bool validate() {
    return formKey.currentState!.validate();
  }

  Future<String> login() async {
    BaseApiResponse response;
    if (withoutPassword) {
      response = await Services.shared.tempVerificationByEmail(emailAddress);
    } else {
      // response = await Services.shared
      //     .postLogin(emailAddress, password, (isiOS ? 1 : 2));
      response =
          await Services.shared.verifyUserFromEmailPwd(emailAddress, password);
    }
    if (response.errorMessage.isEmpty) {
      result = QuickAddTempAdd.fromJson(response.result);
      await localStorage?.setInt('tempUserId', result!.userid);
      await localStorage?.setInt('tempTid', result!.tid);
      await Services.shared.setData();

      await initPlatformState();
      // response = await Services.shared
      //     .addDeviceDetails(emailAddress, _deviceData.toString());
      localStorage?.setString('device', _deviceData['device']);
      Services.shared.headers['device'] = device;
      response = await Services.shared.addDeviceDetails(emailAddress, device);
    }
    return response.errorMessage;
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      // if (Platform.isAndroid) {
      //   deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      // } else if (Platform.isIOS) {
      //   deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      // }
      final device = Platform.isAndroid
          ? (await deviceInfoPlugin.androidInfo).display
          : (await deviceInfoPlugin.iosInfo).identifierForVendor;
      deviceData = {'device': device};
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    _deviceData = deviceData;
  }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'androidId': build.androidId,
  //     'systemFeatures': build.systemFeatures,
  //   };
  // }

  // Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     'systemName': data.systemName,
  //     'systemVersion': data.systemVersion,
  //     'model': data.model,
  //     'localizedModel': data.localizedModel,
  //     'identifierForVendor': data.identifierForVendor,
  //     'isPhysicalDevice': data.isPhysicalDevice,
  //     'utsname.sysname:': data.utsname.sysname,
  //     'utsname.nodename:': data.utsname.nodename,
  //     'utsname.release:': data.utsname.release,
  //     'utsname.version:': data.utsname.version,
  //     'utsname.machine:': data.utsname.machine,
  //   };
  // }
}
