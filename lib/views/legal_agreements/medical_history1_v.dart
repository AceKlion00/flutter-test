import 'package:extra_staff/controllers/legal_agreements/medical_history_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/medical_history2_v.dart';
import 'package:extra_staff/views/legal_agreements/medical_history3_v.dart';
import 'package:extra_staff/views/legal_agreements/registration_complete_v.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class MedicalHistory1 extends StatefulWidget {
  const MedicalHistory1({Key? key}) : super(key: key);

  @override
  _MedicalHistory1State createState() => _MedicalHistory1State();
}

class _MedicalHistory1State extends State<MedicalHistory1> {
  final controller = MedicalHistoryController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserTempData();
  }

  getUserTempData() async {
    try {
      setState(() => isLoading = true);
      await controller.getTempMedicalInfo();
      setState(() => isLoading = false);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('yourMedicalHistory'.tr),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: gHPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Icon(
                        Icons.history,
                        size: 125,
                        color: MyColors.lightBlue,
                      ),
                      SizedBox(height: 32),
                      abTitle('medicalPhysicalMental'.tr),
                      SizedBox(height: 32),
                      abRadioButtons(controller.hasMedicalCondition, (b) {
                        setState(() {
                          controller.data.medicalCondition = b! ? '1' : '2';
                          controller.hasMedicalCondition = b;
                        });
                      }, showIcon: true),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            abBottom(onTap: (i) async {
              if (i == 0) {
                final msg = controller.validate1();
                if (msg.isNotEmpty) {
                  abShowMessage(msg);
                  return;
                }
                if (controller.hasMedicalCondition == false) {
                  setState(() => isLoading = true);
                  await Resume.shared.markAllDone();
                  final message = await controller.updateTempMedicalInfo();
                  setState(() => isLoading = false);
                  if (message.isEmpty) {
                    await Resume.shared.setDone();
                    await Resume.shared
                        .setDone(name: (MedicalHistory2).toString());
                    await Resume.shared
                        .setDone(name: (MedicalHistory3).toString());
                    Get.bottomSheet(
                      NewInfoView(6, () {
                        Get.off(() => RegistrationComplete());
                      }),
                      enableDrag: false,
                      isDismissible: false,
                      isScrollControlled: true,
                    );
                  } else {
                    abShowMessage(message);
                  }
                } else {
                  await Resume.shared.setDone();
                  Get.to(() => MedicalHistory2(),
                      arguments: {'medicalHistory': controller});
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
