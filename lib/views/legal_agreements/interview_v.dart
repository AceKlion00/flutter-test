import 'package:extra_staff/controllers/legal_agreements/interview_c.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/medical_history1_v.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Interview extends StatefulWidget {
  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<Interview> {
  final controller = InterviewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apicall();
  }

  apicall() async {
    setState(() => isLoading = true);
    await controller.getQuickTempVerification();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('interview'.tr),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: gHPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 32),
                    abTitle('likeInterviewConducted'.tr),
                    SizedBox(height: 16),
                    abDropDownButton(controller.interviewMethod,
                        controller.dropDowns.methods, (e) {
                      controller.interviewMethod = e;
                      setState(() {});
                    }),
                    SizedBox(height: 16),
                    abTitle('wtcyd'.tr),
                    SizedBox(height: 16),
                    abDropDownButton(
                        controller.interviewTime, controller.dropDowns.times,
                        (e) {
                      controller.interviewTime = e;
                      setState(() {});
                    }),
                    SizedBox(height: 16),
                    abTitle('interviewDate'.tr),
                    SizedBox(height: 16),
                    abStatusButton(controller.interviewDateStr, null, () async {
                      final now = getNow;
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.interviewDate,
                        firstDate: DateTime(now.year, now.month, now.day),
                        lastDate: DateTime(now.year + 1, now.month, now.day),
                      );
                      if (picked != null &&
                          picked != controller.interviewDate) {
                        setState(() {
                          controller.setInterviewDate(picked);
                          controller.interviewDate = picked;
                        });
                      }
                    }, hideStatus: true),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            abBottom(
              top: 'finish'.tr,
              onTap: (i) async {
                if (i == 0) {
                  final value = controller.validate();
                  if (value.isNotEmpty) {
                    abShowMessage(value);
                  } else {
                    final message = await controller.updateTempInterviewInfo();
                    if (message.isNotEmpty) {
                      abShowMessage(message);
                      return;
                    }
                    await Resume.shared.setDone();
                    Get.to(() => MedicalHistory1());
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
