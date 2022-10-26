import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/about_you/address_v.dart';
import 'package:extra_staff/views/about_you/availability_v.dart';
import 'package:extra_staff/views/about_you/bank_details_v.dart';
import 'package:extra_staff/views/about_you/equality_monitoring_v.dart';
import 'package:extra_staff/views/employment/employment_v.dart';
import 'package:extra_staff/views/legal_agreements/hmrc_checklist_start_v.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:extra_staff/views/onboarding/competency_test_v.dart';
import 'package:extra_staff/views/onboarding/onboarding_wizard_v.dart';
import 'package:extra_staff/views/working_with_us/availability2_v.dart';
import 'package:extra_staff/views/working_with_us/driving_test_v.dart';
import 'package:extra_staff/views/working_with_us/licences_upload_v.dart';
import 'package:extra_staff/views/working_with_us/roles_v.dart';
import 'package:extra_staff/views/working_with_us/skills_v.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:extra_staff/controllers/registration_c.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  _RegistrationView createState() => _RegistrationView();
}

class _RegistrationView extends State<RegistrationView> {
  final controller = RegistrationController();

  bool isLoading = true;
  Map<String, dynamic> allData = {};

  @override
  void initState() {
    super.initState();
    getUserTempData();
    fallBackTimer(true);
  }

  getUserTempData() async {
    try {
      setState(() => isLoading = true);
      controller.getCompletedValues();
      final message1 = await controller.getTempUserData();
      final message2 = await controller.getDropdownInfo();
      final message3 = await controller.getTempAgreementInfo();
      if (message1.isNotEmpty) abShowMessage(message1);
      if (message2.isNotEmpty) abShowMessage(message2);
      if (message3.isNotEmpty) abShowMessage(message3);
      allData = {
        'aboutYou': controller.data,
        'dropDowns': controller.dropDowns,
        'agreementsStatus': controller.status,
      };
      setState(() => isLoading = false);
      if (message1.isEmpty && message2.isEmpty && Get.arguments == true) {
        for (int i = 0; i < controller.completedValues.length; i++) {
          final v = controller.completedValues[i];
          if (!v) {
            switchTheFlow(i);
            return;
          }
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }

  switchTheFlow(int index) async {
    fallBackTimer(false);
    switch (index) {
      case 0:
        aboutYouNestedNavigation();
        break;
      case 1:
        Get.to(() => EmploymentView(), arguments: allData);
        break;
      case 2:
        workingWithUsNestedNavigation();
        break;
      case 3:
        Get.to(() => HMRCChecklistStartView(), arguments: allData);
        break;
      default:
        Get.to(() => HMRCChecklistStartView(), arguments: allData);
    }
  }

  aboutYouNestedNavigation() {
    final screens = [
      (Address).toString(),
      (Availability).toString(),
      (BankDetails).toString(),
      (EqualityMonitoring).toString(),
    ];

    final fd = Resume.shared.allClasses
            .where((e) => screens.contains(e.title))
            .toList()
            .firstWhereOrNull((e) => e.done == false) ??
        Todo(title: '', done: false);

    switch (fd.title) {
      case 'Availability':
        Get.to(() => Availability(), arguments: allData);
        break;
      case 'BankDetails':
        Get.bottomSheet(
          NewInfoView(5, () {
            Get.to(() => BankDetails(), arguments: allData);
          }),
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
        );
        break;
      case 'EqualityMonitoring':
        Get.to(() => EqualityMonitoring(), arguments: allData);
        break;
      default:
        Get.to(() => Address(), arguments: allData);
        break;
    }
  }

  workingWithUsNestedNavigation() {
    final screens = [
      (RolesView).toString(),
      (SkillsView).toString(),
      if (isDriver) (LicencesUploadView).toString(),
      (Availability2).toString(),
      (DrivingTestView).toString(),
      if (isQuizTest) (CompetencyTest).toString(),
      if (isQuizTest) (OnboardingWizard).toString(),
    ];

    final fd = Resume.shared.allClasses
            .where((e) => screens.contains(e.title))
            .toList()
            .firstWhereOrNull((e) => e.done == false) ??
        Todo(title: '', done: false);

    switch (fd.title) {
      case 'SkillsView':
        Get.to(() => SkillsView(), arguments: allData);
        break;
      case 'LicencesUploadView':
        Get.to(() => LicencesUploadView(), arguments: allData);
        break;
      case 'Availability2':
        Get.to(() => Availability2(), arguments: allData);
        break;
      case 'DrivingTestView':
        Get.to(() => DrivingTestView(), arguments: allData);
        break;
      case 'OnboardingWizard':
        Get.to(() => OnboardingWizard(), arguments: allData);
        break;
      case 'CompetencyTest':
        Get.to(() => CompetencyTest(), arguments: allData);
        break;
      default:
        Get.to(() => RolesView(), arguments: allData);
        break;
    }
  }

  Widget button(String title, int index) {
    bool? status;
    if (controller.completedValues.length > 1 &&
        controller.completedValues[index]) {
      status = true;
    }
    return abStatusButton(
      title,
      status,
      () async {
        if (!controller.onTheFlow(index)) {
          abShowMessage('onTheFlow'.tr);
          return;
        }
        switchTheFlow(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('registration'.tr),
        body: Form(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: gHPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      abTitle('aboutYou'.tr),
                      SizedBox(height: 16),
                      button('aboutYou'.tr, 0),
                      SizedBox(height: 16),
                      abTitle('yourEmploymentHistory'.tr),
                      SizedBox(height: 16),
                      button('yourEmploymentHistory'.tr, 1),
                      SizedBox(height: 16),
                      abTitle('ct'.tr),
                      SizedBox(height: 16),
                      button('ct'.tr, 2),
                      SizedBox(height: 16),
                      abTitle('lAgreementsC'.tr),
                      SizedBox(height: 16),
                      button('lAgreementsC'.tr, 3),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              abBottom(onTap: (i) {
                if (i == 0) {}
              }),
            ],
          ),
        ),
      ),
    );
  }
}
