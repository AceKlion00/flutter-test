import 'package:extra_staff/controllers/list_to_upload_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/employment/employment_history_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:extra_staff/views/upload_documents_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EmploymentView extends StatefulWidget {
  @override
  State<EmploymentView> createState() => _EmploymentViewState();
}

class _EmploymentViewState extends State<EmploymentView> {
  final controller = ListToUploadController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  apiCall() async {
    setState(() => isLoading = true);
    await controller.getTempCVInfo();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: abHeader('Employment'),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Container(
          padding: gHPadding,
          child: Column(
            children: [
              SizedBox(height: 32),
              abSimpleButton(
                'Upload CV',
                onTap: () async => await action(0),
                backgroundColor:
                    controller.isCVUploaded ? MyColors.green : null,
              ),
              SizedBox(height: 16),
              abTitle('Or'),
              SizedBox(height: 16),
              abSimpleButton('Enter manually',
                  onTap: () async => await action(1)),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  action(int index) async {
    bool result = false;
    if (index == 0) {
      result = await Get.to(() => UploadDocumentsView(controller: controller),
          arguments: {'isCV': true});
    } else {
      result =
          await Get.to(() => EmploymentHistory(), arguments: {'isCV': true});
    }
    if (result) {
      await localStorage?.setBool('isEmploymentHistoryCompleted', true);
      await Resume.shared.setDone();
      Get.off(() => RegistrationView());
    }
  }
}
