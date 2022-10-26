import 'package:extra_staff/controllers/legal_agreements/medical_history_c.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/registration_complete_v.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';

class MedicalHistory3 extends StatefulWidget {
  const MedicalHistory3({Key? key}) : super(key: key);

  @override
  _MedicalHistory3State createState() => _MedicalHistory3State();
}

class _MedicalHistory3State extends State<MedicalHistory3> {
  bool isLoading = false;
  MedicalHistoryController controller = MedicalHistoryController();

  @override
  void initState() {
    super.initState();
    controller = Get.arguments['medicalHistory'];
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
                  padding: gHPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      abTitle('receivingMedicalTreatment?'.tr),
                      SizedBox(height: 8),
                      abRadioButtons(controller.treatment, (p0) {
                        setState(() {
                          controller.data.treatment = p0! ? '1' : '2';
                          controller.treatment = p0;
                        });
                      }),
                      SizedBox(height: 16),
                      abTitle('furtherDetails'.tr),
                      SizedBox(height: 8),
                      abTextField(controller.data.treatmentData,
                          (p0) => controller.data.treatmentData = p0,
                          maxLines: 3),
                      SizedBox(height: 16),
                      abTitle('takenAnyDrugsMedicines?'.tr),
                      SizedBox(height: 8),
                      abRadioButtons(controller.drug, (p0) {
                        setState(() {
                          controller.data.drug = p0! ? '1' : '2';
                          controller.drug = p0;
                        });
                      }),
                      SizedBox(height: 16),
                      abTitle('furtherDetails'.tr),
                      SizedBox(height: 8),
                      abTextField(controller.data.drugData,
                          (p0) => controller.data.drugData = p0,
                          maxLines: 3),
                      SizedBox(height: 16),
                      abTitle('detailsOfAllIllnesses'.tr),
                      SizedBox(height: 16),
                      abTextField(controller.data.illnessData,
                          (p0) => controller.data.illnessData = p0,
                          maxLines: 3),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              abBottom(
                top: 'save'.tr,
                bottom: null,
                onTap: (i) async {
                  if (i == 0) {
                    next();
                  }
                },
              ),
            ],
          ),
        ));
  }

  next() async {
    final msg = controller.validate3();
    if (msg.isNotEmpty) {
      abShowMessage(msg);
      return;
    }
    setState(() => isLoading = true);
    await Resume.shared.markAllDone();
    final message = await controller.updateTempMedicalInfo();
    setState(() => isLoading = false);
    if (message.isEmpty) {
      await Resume.shared.setDone();
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
  }
}
