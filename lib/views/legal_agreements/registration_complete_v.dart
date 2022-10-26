import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/list_to_upload_v.dart';
import 'package:extra_staff/views/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';

class RegistrationComplete extends StatefulWidget {
  const RegistrationComplete({Key? key}) : super(key: key);

  @override
  _RegistrationCompleteState createState() => _RegistrationCompleteState();
}

class _RegistrationCompleteState extends State<RegistrationComplete> {
  @override
  void initState() {
    super.initState();
    saveProcess();
  }

  saveProcess() async {
    await localStorage?.setBool('isAgreementsCompleted', true);
    final result = await Services.shared.getTempProgressInfo();
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    } else {
      await localStorage?.setString('completed', result.result['completed']);
      await Services.shared.setData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image(
            image: AssetImage('lib/images/comingSoon.png'),
            fit: BoxFit.fitWidth,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 44),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Coming Soon ...',
                    textAlign: TextAlign.center,
                    style: MyFonts.regular(30, color: MyColors.darkBlue),
                  ),
                  Text(
                    "This is only the start of our app, stay tuned for new updates including ability to view your pay information/payslips, latest Extrastaff news, ability to check in and out of work and book your holidays all by the click of a button!",
                    textAlign: TextAlign.center,
                    style: MyFonts.regular(20, color: MyColors.grey),
                  ),
                ],
              ),
            ),
          ),
          abBottom(
            top: 'Review Application',
            bottom: 'Logout',
            onTap: (i) async {
              if (i == 0) {
                Get.offAll(() => ListToUploadView());
              } else {
                await removeAllSharedPref();
                Get.offAll(() => SplashPage());
              }
            },
          ),
        ],
      ),
    );
  }
}
