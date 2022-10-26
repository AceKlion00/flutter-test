import 'package:extra_staff/controllers/working_with_us/driving_test_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:extra_staff/views/onboarding/onboarding_wizard_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class DrivingTestView extends StatefulWidget {
  @override
  _DrivingTestViewState createState() => _DrivingTestViewState();
}

class _DrivingTestViewState extends State<DrivingTestView> {
  bool isLoading = false;
  final controller = DrivingTestController();
  final tableBorder = TableBorder(
    top: BorderSide(color: MyColors.lightGrey),
    horizontalInside: BorderSide(color: MyColors.lightGrey),
    bottom: BorderSide(color: MyColors.lightGrey),
  );
  final filter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  @override
  initState() {
    super.initState();
    apicall();
  }

  apicall() async {
    setState(() => isLoading = true);
    await controller.getTempDrivingTestInfo();
    setState(() => isLoading = false);
  }

  Widget smallText(String str) {
    return Text(str, style: MyFonts.regular(15));
  }

  Widget tableRow(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: smallText(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('dt'.tr),
        body: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: gHPadding,
              child: smallText(controller.longTexts[0]),
            ),
            SizedBox(height: 16),
            Padding(
              padding: gHPadding,
              child: Table(
                border: tableBorder,
                children: [
                  TableRow(
                      children: [for (var i in controller.row1) tableRow(i)]),
                  TableRow(
                      children: [for (var i in controller.row2) tableRow(i)])
                ],
              ),
            ),
            Expanded(
              child: RawScrollbar(
                isAlwaysShown: true,
                thumbColor: MyColors.darkBlue,
                radius: Radius.circular(16),
                thickness: 16,
                child: SingleChildScrollView(
                  padding: gHPadding,
                  child: Form(
                    key: isLoading ? null : controller.drivingTest,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        abTitle('Name'),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.driverName,
                          (e) => controller.test.driverName = e,
                          hintText: '',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        abTitle('Licence Category:'),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.licenseCategory,
                          (e) => controller.test.licenseCategory = e,
                          hintText: '',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        abTitle('Date'),
                        SizedBox(height: 16),
                        abStatusButton(controller.licenseDateApp, null,
                            () async {
                          final now = getNow;
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                stringToDate(controller.licenseDateApp, true) ??
                                    now,
                            firstDate: now,
                            lastDate: DateTime(now.year + 10),
                          );
                          if (picked != null) {
                            setState(() {
                              controller.licenseDateApp = formatDate(picked);
                              controller.test.licenseDate =
                                  dateToString(picked, true) ?? '';
                            });
                          }
                        }, hideStatus: true),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[1]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.maxDriHours,
                          (e) => controller.test.maxDriHours = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Maximum hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[2]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.breakMinutes,
                          (e) => controller.test.breakMinutes = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Break Minutes',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[3]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.repBreakMinutes,
                          (e) => controller.test.repBreakMinutes = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Replaced Break Minutes',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.folBreakMinutes,
                          (e) => controller.test.folBreakMinutes = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Followed Break Minutes',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[4]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.dayHours,
                          (e) => controller.test.dayHours = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Daily Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[5]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.weekOcca,
                          (e) => controller.test.weekOcca = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Number of Occasions',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.maxHour,
                          (e) => controller.test.maxHour = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Maximum Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[6]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.weekMaxHour,
                          (e) => controller.test.weekMaxHour = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Maximum Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.exceedHour,
                          (e) => controller.test.exceedHour = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Exceed Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            abTitle('\t\t\t• '),
                            Expanded(child: abTitle(controller.longTexts[7])),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            abTitle('\t\t\t• '),
                            Expanded(child: abTitle(controller.longTexts[8])),
                          ],
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[9]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.dayMinHours,
                          (e) => controller.test.dayMinHours = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Minimum Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[10]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.dayRestMinHours,
                          (e) => controller.test.dayRestMinHours = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Minimum Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        abTitle(controller.longTexts[11]),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            abTitle('\t\t\t• '),
                            Expanded(child: abTitle(controller.longTexts[12])),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            abTitle('\t\t\t• '),
                            Expanded(child: abTitle(controller.longTexts[13])),
                          ],
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[14]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.weekRestHour,
                          (e) => controller.test.weekRestHour = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Rest Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.weekRedRestHour,
                          (e) => controller.test.weekRedRestHour = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Reduced Rest Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[15]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.trainingHours,
                          (e) => controller.test.trainingHours = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Training Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        abTitle(controller.longTexts[16]),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            abTitle('\t\t\t• '),
                            Expanded(child: abTitle(controller.longTexts[17])),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            abTitle('\t\t\t• '),
                            Expanded(child: abTitle(controller.longTexts[18])),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            abTitle('\t\t\t• '),
                            Expanded(child: abTitle(controller.longTexts[19])),
                          ],
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[20]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.maxHourLim,
                          (e) => controller.test.maxHourLim = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Maximum Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[21]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.minBreakMinutes,
                          (e) => controller.test.minBreakMinutes = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Minimum Break Minutes',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[22]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.totalBreakMin,
                          (e) => controller.test.totalBreakMin = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Total Break Minutes',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[23]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.breakMin,
                          (e) => controller.test.breakMin = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Total Break Minutes',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[24]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.totalHours,
                          (e) => controller.test.totalHours = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Maximum Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                        smallText(controller.longTexts[25]),
                        SizedBox(height: 16),
                        abTextField(
                          controller.test.weekMaxHourLim,
                          (e) => controller.test.weekMaxHourLim = e,
                          keyboardType: TextInputType.number,
                          inputFormatters: [filter],
                          hintText: 'Maximum Hours',
                          validator: (e) => textValidate(e),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            abBottom(onTap: (i) async {
              if (i == 0) {
                if (controller.validated()) {
                  setState(() => isLoading = true);
                  final success = await controller.updateTempDrivingTestInfo();
                  setState(() => isLoading = false);
                  if (success) {
                    await Resume.shared.setDone();
                    if (isQuizTest && !is35T) {
                      Get.bottomSheet(
                        NewInfoView(7, () async {
                          Get.to(() => OnboardingWizard());
                        }),
                        enableDrag: false,
                        isDismissible: false,
                        isScrollControlled: true,
                      );
                    } else {
                      await localStorage?.setBool(
                          'isCompetencyTestCompleted', true);
                      Get.off(() => RegistrationView());
                    }
                  }
                }
              }
            }),
          ],
        ),
      ),
    );
  }

  textValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'enterText'.tr;
    }
    return null;
  }
}
