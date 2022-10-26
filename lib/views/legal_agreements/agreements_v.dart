import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/user_confirmation_v.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/controllers/legal_agreements/agreements_c.dart';
import 'package:extra_staff/views/legal_agreements/agreement1_v.dart';

class AgreementsView extends StatefulWidget {
  const AgreementsView({Key? key}) : super(key: key);

  @override
  _AgreementsViewState createState() => _AgreementsViewState();
}

class _AgreementsViewState extends State<AgreementsView> {
  final controller = AgreementsController();

  @override
  void initState() {
    super.initState();
    if (Get.arguments is List) {
      controller.status = Get.arguments;
      if (controller.status.isEmpty || controller.allAccepted()) {
        Future.delayed(duration, () {
          navigate();
        });
      }
    }
  }

  Widget agreement(KeyValue index) {
    return Column(
      children: [
        SizedBox(height: 16),
        abStatusButton(index.value, controller.status.contains(index.id),
            () async {
          controller.currentIndex = int.parse(index.id);
          await navigate();
        }, hideStatus: true),
        SizedBox(height: 16),
      ],
    );
  }

  navigate() async {
    await Resume.shared.setDone();
    if (controller.allAccepted()) {
      Get.to(() => UserConfirmationView());
      return;
    }
    final value = await Get.to(() => Agreement1(), arguments: controller);
    if (value == null) {
      final message = await controller.getTempAgreementInfo();
      if (message.isNotEmpty) abShowMessage(message);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: abHeader('agreements'.tr),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: gHPadding,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  for (var i in controller.allAgreements) agreement(i),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          abBottom(onTap: (i) async {
            if (i == 0) {
              await navigate();
            }
          }),
        ],
      ),
    );
  }
}
