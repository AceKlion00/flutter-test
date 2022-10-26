import 'package:extra_staff/controllers/login_c.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/biometric_v.dart';
import 'package:extra_staff/views/confirm_code_v.dart';
import 'package:extra_staff/views/welcome_v.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:get/get.dart';
import 'login_v.dart';

class AlreadySignedUp extends StatefulWidget {
  const AlreadySignedUp({Key? key}) : super(key: key);

  @override
  _AlreadySignedUpState createState() => _AlreadySignedUpState();
}

class _AlreadySignedUpState extends State<AlreadySignedUp> {
  final controller = LoginController();
  bool isPassCodeSet = false;
  bool isBiometricSet = false;

  @override
  void initState() {
    super.initState();
    check();
  }

  Future check() async {
    final code = localStorage?.getString('passcode') ?? '';
    final bio = await controller.isBiometricsAvaliable();
    setState(() {
      isPassCodeSet = code.isNotEmpty;
      isBiometricSet = bio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: abHeader('login'.tr, showHome: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Spacer(),
          Container(
            padding: gHPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isPassCodeSet)
                  abSimpleButton('loginWithEmail'.tr.toUpperCase(),
                      onTap: () => Get.to(() => LoginView())),
                if (isPassCodeSet) SizedBox(height: 32),
                if (isPassCodeSet)
                  abSimpleButton('loginWithPasscode'.tr.toUpperCase(),
                      onTap: () => Get.to(() => EnterCode(isFromStart: false))),
                if (isPassCodeSet) SizedBox(height: 32),
                if (isPassCodeSet)
                  abSimpleButton('Forgot Passcode'.toUpperCase(),
                      onTap: () => Get.offAll(() => WelcomeView())),
                if (isBiometricSet) SizedBox(height: 32),
                if (isBiometricSet)
                  abSimpleButton('loginWithBiometric'.tr.toUpperCase(),
                      onTap: () => Get.to(() => BiometricView(false))),
              ],
            ),
          ),
          Spacer(),
          abBottom(top: null),
        ],
      ),
    );
  }
}
