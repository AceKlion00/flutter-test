import 'package:extra_staff/controllers/legal_agreements/medical_history_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/medical_history3_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalHistory2 extends StatefulWidget {
  const MedicalHistory2({Key? key}) : super(key: key);

  @override
  _MedicalHistory2State createState() => _MedicalHistory2State();
}

class _MedicalHistory2State extends State<MedicalHistory2> {
  MedicalHistoryController controller = MedicalHistoryController();

  @override
  void initState() {
    super.initState();
    controller = Get.arguments['medicalHistory'];
  }

  @override
  Widget build(BuildContext context) {
    final keys = controller.values.keys.toList();
    final value = controller.values.values.toList();
    return Scaffold(
      appBar: abHeader('yourMedicalHistory'.tr),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: gHPadding,
            child: Column(
              children: [
                SizedBox(height: 32),
                abTitle('youSuffer?'.tr),
                SizedBox(height: 32),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: gHPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.values.length,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, position) {
                      return Column(
                        children: [
                          CheckboxListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            value: value[position],
                            onChanged: (v) => setState(() {
                              controller.values[keys[position]] = v!;
                              controller.setValues(position, v ? '1' : '2');
                            }),
                            title: abTitle(keys[position]),
                          ),
                          Divider(thickness: 2, color: MyColors.offWhite),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  abTitle('furtherDetails'.tr),
                  SizedBox(height: 8),
                  abTextField(
                    controller.data.medicalDesc,
                    (t) => controller.data.medicalDesc = t,
                    maxLength: -1,
                    onFieldSubmitted: (p) {
                      next();
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          abBottom(onTap: (i) async {
            if (i == 0) {
              next();
            }
          }),
        ],
      ),
    );
  }

  next() async {
    final msg = controller.validate2();
    if (msg.isNotEmpty) {
      abShowMessage(msg);
      return;
    }
    await Resume.shared.setDone();
    Get.to(() => MedicalHistory3(), arguments: {'medicalHistory': controller});
  }
}
