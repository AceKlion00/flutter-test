import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/controllers/login_c.dart';
import 'package:extra_staff/views/registration_progress_v.dart';

class BiometricView extends StatelessWidget {
  BiometricView(this.isSkippable);

  final bool isSkippable;
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: abHeader('useBiometricID?'.tr,
          showHome: false, showBack: !isSkippable),
      body: Column(
        children: [
          Expanded(
            child: FittedBox(
              child: Image(
                image: AssetImage('lib/images/face.png'),
                height: 125,
                width: 125,
              ),
            ),
          ),
          abBottom(
            top: 'useBiometricID'.tr,
            bottom: isSkippable ? 'setUpLater'.tr : null,
            onTap: (i) async {
              final next = await controller.proceed(i);
              if (i == 0 && !next) {
                abShowMessage('error'.tr);
              } else {
                Get.to(() => RegistrationProgress());
              }
            },
          ),
        ],
      ),
    );
  }
}
