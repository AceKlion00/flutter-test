import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'list_to_upload_v.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';

class RegistrationProgress extends StatefulWidget {
  const RegistrationProgress({Key? key}) : super(key: key);

  @override
  _RegistrationProgressState createState() => _RegistrationProgressState();
}

class _RegistrationProgressState extends State<RegistrationProgress> {
  int progress = 0;
  double width = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() => isLoading = true);
    await getTempDeskInfo();
    setState(() {
      progress = Resume.shared.progress;
      if (progress < 10) {
        progress = 10;
      }
      isLoading = false;
    });
  }

  Future getTempDeskInfo() async {
    final result = await Services.shared.getTempDeskInfo();
    if (result.errorMessage.isNotEmpty) {
      abShowMessage(result.errorMessage);
    } else {
      if (result.result['isDriver'] is bool) {
        await localStorage?.setBool('isDriver', result.result['isDriver']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final str =
        'completed%'.tr + ' ' + '$progress%' + ' ' + 'registration'.tr + '.';
    width = MediaQuery.of(context).size.width - (gHPadding.right * 2);
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('dashboard'.tr),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: gHPadding,
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    Stack(
                      children: [
                        LinearProgressIndicator(
                          value: progress / 100,
                          minHeight: 40,
                          color: MyColors.darkBlue,
                          backgroundColor: MyColors.offWhite,
                        ),
                        Container(
                          height: 40,
                          width: progress == 0 ? width : width * progress / 100,
                          alignment: Alignment.center,
                          child: Text(
                            progress >= 15 ? '$progress%' : '',
                            style: MyFonts.medium(20, color: MyColors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    abWords(str, '$progress% ${'registration'.tr}.', null),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            abBottom(
              top: progress != 0
                  ? 'resume'.tr.toUpperCase()
                  : 'start'.tr.toUpperCase(),
              bottom: null,
              onTap: (i) {
                if (i == 0) {
                  if (progress != 0) {
                    Resume.shared.navigate();
                  } else {
                    Get.to(() => ListToUploadView());
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
