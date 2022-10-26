import 'package:extra_staff/controllers/employment/company_details_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CompanyDetails extends StatefulWidget {
  const CompanyDetails({Key? key}) : super(key: key);

  @override
  _CompanyDetailsState createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  CompanyDetailsController controller = CompanyDetailsController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) controller.company = Get.arguments;
    controller.setDates();
  }

  selectDate(BuildContext context, int index) async {
    final dobString = localStorage?.getString('dob') ?? '';
    final dob = controller.stringToDateDob(dobString);
    final date = index == 1
        ? controller.stringToDate(controller.company.suggestedStartDate)
        : controller.stringToDate(controller.company.suggestedEndDate);
    final now = getNow;
    final lastStart = controller.company.suggestedEndDate.isEmpty
        ? DateTime(now.year, now.month, now.day)
        : controller.stringToDate(controller.company.suggestedEndDate);
    final minEnd = controller.company.suggestedStartDate.isEmpty
        ? minDate
        : controller.stringToDate(controller.company.suggestedStartDate);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.company.suggestedStartDate.isEmpty &&
              controller.company.suggestedEndDate.isNotEmpty
          ? lastStart
          : date,
      firstDate: index == 1 ? dob : minEnd,
      lastDate: index == 1 ? lastStart : DateTime(now.year, now.month, now.day),
    );
    if (picked != null && picked != date) {
      setState(() {
        if (index == 1) {
          controller.setStartDate(picked);
        } else {
          controller.setEndDate(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IconButton(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 16),
                iconSize: 50,
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                color: MyColors.darkBlue,
                icon: Icon(Icons.cancel_rounded),
                alignment: Alignment.centerRight,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: gHPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      abTitle('companyName'.tr),
                      SizedBox(height: 16),
                      abTextField(controller.company.company,
                          (p0) => controller.company.company = p0,
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enterText'.tr;
                        }
                        return null;
                      }),
                      SizedBox(height: 16),
                      abTitle('companyContact'.tr),
                      SizedBox(height: 16),
                      abTextField(controller.company.contactPersonName,
                          (p0) => controller.company.contactPersonName = p0,
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enterText'.tr;
                        }
                        return null;
                      }, maxLength: 250),
                      SizedBox(height: 16),
                      abTitle('companyContactEmail'.tr),
                      SizedBox(height: 16),
                      abTextField(controller.company.contactPersonEmail,
                          (p0) => controller.company.contactPersonEmail = p0,
                          validator: (value) {
                        final empty = value == null || value.isEmpty;
                        final text = value ?? '';
                        if (empty && controller.company.contactNumber.isEmpty) {
                          return 'enterText'.tr;
                        } else if (text.isNotEmpty && !text.isEmail) {
                          return 'validEmail'.tr;
                        }
                        return null;
                      }, keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 16),
                      abTitle('companyTelephone'.tr),
                      SizedBox(height: 16),
                      abTextField(
                        controller.company.contactNumber,
                        (p0) => controller.company.contactNumber = p0,
                        validator: (value) {
                          final empty = value == null || value.isEmpty;
                          final text = value ?? '';
                          if (empty &&
                              controller.company.contactPersonEmail.isEmpty) {
                            return 'enterText'.tr;
                          }
                          if (text.isEmpty) return null;
                          if (!isPhoneNo(text)) {
                            return 'validPhone'.tr;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                      ),
                      SizedBox(height: 16),
                      abTitle('jobTitle'.tr),
                      SizedBox(height: 16),
                      abTextField(controller.company.jobTitle,
                          (p0) => controller.company.jobTitle = p0,
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enterText'.tr;
                        }
                        return null;
                      }),
                      SizedBox(height: 16),
                      abTitle('reasonForLeaving'.tr),
                      SizedBox(height: 16),
                      abTextField(controller.company.leavingReason,
                          (p0) => controller.company.leavingReason = p0,
                          validator: (value) {
                        if (controller.endDate.isNotEmpty &&
                            (value == null || value.isEmpty)) {
                          return 'enterText'.tr;
                        }
                        return null;
                      }, maxLines: 3),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                abTitle('startDate'.tr),
                                SizedBox(height: 16),
                                abStatusButton(controller.startDate, null,
                                    () async {
                                  selectDate(context, 1);
                                }, hideStatus: true),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                abTitle('endDate'.tr),
                                SizedBox(height: 16),
                                abStatusButton(controller.endDate, null,
                                    () async {
                                  selectDate(context, 2);
                                }, hideStatus: true),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    if (!controller.formKey.currentState!.validate()) {
                      abShowMessage('error'.tr);
                      return;
                    }
                    if (controller.company.suggestedStartDate.isEmpty) {
                      abShowMessage('startDate'.tr);
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    final message = await controller.updateTempEmployeeInfo();
                    setState(() {
                      isLoading = false;
                    });
                    if (message.isEmpty) {
                      await Resume.shared.setDone();
                      Get.back();
                      Get.back();
                    } else {
                      abShowMessage(message);
                    }
                  } else {
                    Get.back();
                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
