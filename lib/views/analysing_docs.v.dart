import 'package:extra_staff/views/new_info_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';

class AnalysingDocs extends StatelessWidget {
  const AnalysingDocs({Key? key, this.seconds}) : super(key: key);

  final Duration? seconds;

  getImagesData() async {
    await Future.delayed(seconds ?? duration);
    if (seconds == null) {
      Get.bottomSheet(
        WillPopScope(
          onWillPop: () async => false,
          child: NewInfoView(4, () {
            Get.offAll(() => RegistrationView());
          }),
        ),
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
      );
    } else {
      Get.back();
    }
  }

  Widget topImage() {
    final image = 'lib/images/${isDriver ? 'driving' : 'warehouse'}.png';
    return Image(image: AssetImage(image), fit: BoxFit.fitWidth);
  }

  @override
  Widget build(BuildContext context) {
    getImagesData();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              if (seconds != null) topImage(),
              Spacer(),
              Image.asset(
                'lib/images/EFOS-Analysing-standard.gif',
                gaplessPlayback: true,
                repeat: ImageRepeat.repeat,
                fit: BoxFit.fitWidth,
                height: 100,
              ),
              SizedBox(height: 50),
              Container(
                padding: gHPadding,
                child: abWords(
                  'analysingDocuments'.tr,
                  'analysing',
                  WrapAlignment.center,
                ),
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
