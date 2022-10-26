import 'package:extra_staff/controllers/list_to_upload_c.dart';
import 'package:extra_staff/controllers/working_with_us/availability2_c.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:extra_staff/views/onboarding/onboarding_wizard_v.dart';
import 'package:extra_staff/views/working_with_us/driving_test_v.dart';
import 'package:extra_staff/views/registration_v.dart';
import 'package:extra_staff/views/upload_documents_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Availability2 extends StatefulWidget {
  const Availability2({Key? key}) : super(key: key);

  @override
  _Availability2State createState() => _Availability2State();
}

class _Availability2State extends State<Availability2> {
  final controller = Availability2Controller();
  final listToUploadController = ListToUploadController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    controller.getDataFromStorage();
    setState(() => isLoading = true);
    await controller.apiCalls();
    setState(() {
      isLoading = false;
      controller.setData();
    });
  }

  Widget buttons(int index, String title) {
    bool isSelected = false;
    switch (index) {
      case 1:
        isSelected = controller.dMon;
        break;
      case 2:
        isSelected = controller.dTue;
        break;
      case 3:
        isSelected = controller.dWed;
        break;
      case 4:
        isSelected = controller.dThu;
        break;
      case 5:
        isSelected = controller.dFri;
        break;
      case 6:
        isSelected = controller.dSat;
        break;
      default:
        isSelected = controller.dSun;
    }
    return InkWell(
      onTap: () {
        switch (index) {
          case 1:
            controller.dMon = !controller.dMon;
            controller.data.monday = controller.dMon.toString();
            break;
          case 2:
            controller.dTue = !controller.dTue;
            controller.data.tuesday = controller.dTue.toString();
            break;
          case 3:
            controller.dWed = !controller.dWed;
            controller.data.wednesday = controller.dWed.toString();
            break;
          case 4:
            controller.dThu = !controller.dThu;
            controller.data.thursday = controller.dThu.toString();
            break;
          case 5:
            controller.dFri = !controller.dFri;
            controller.data.friday = controller.dFri.toString();
            break;
          case 6:
            controller.dSat = !controller.dSat;
            controller.data.saturday = controller.dSat.toString();
            break;
          default:
            controller.dSun = !controller.dSun;
            controller.data.sunday = controller.dSun.toString();
        }
        setState(() {});
      },
      child: Container(
        width: buttonHeight,
        height: buttonHeight,
        decoration: abOutline(
          borderColor: MyColors.lightGrey,
          color: isSelected ? MyColors.green : null,
        ),
        margin: EdgeInsets.all(2),
        alignment: AlignmentDirectional.center,
        child: Text(title,
            style: MyFonts.regular(
              16,
              color: isSelected ? MyColors.white : MyColors.black,
            )),
      ),
    );
  }

  Widget top() {
    return Container(
      padding: gHPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          abTitle('dayAvailabilityQuestion'.tr),
          SizedBox(height: 8),
          Wrap(
            children: [
              buttons(1, 'mon'.tr),
              buttons(2, 'tue'.tr),
              buttons(3, 'wed'.tr),
              buttons(4, 'thu'.tr),
              buttons(5, 'fri'.tr),
              buttons(6, 'sat'.tr),
              buttons(7, 'sun'.tr),
            ],
          ),
          SizedBox(height: 16),
          abTitle('workingInNightQuestion'.tr),
          SizedBox(height: 8),
          abRadioButtons(controller.areYouInterested, (b) {
            setState(() {
              controller.data.nightWork = b == null ? '' : b.toString();
              controller.areYouInterested = b;
            });
          }, showIcon: true),
          SizedBox(height: 16),
          abTitle('ownTransport'.tr),
          SizedBox(height: 8),
          abRadioButtons(controller.haveOwnTransport, (b) {
            setState(() {
              controller.data.ownTrasport = b == null ? '' : b.toString();
              controller.haveOwnTransport = b;
            });
          }, showIcon: true),
          SizedBox(height: 16),
          abTitle('hiVis'.tr),
          SizedBox(height: 8),
          abRadioButtons(controller.requireHiVis, (b) {
            setState(() {
              controller.data.hiVis = b == null ? '' : b.toString();
              controller.requireHiVis = b;
            });
          }, showIcon: true),
          SizedBox(height: 16),
          abTitle('safetyBoots'.tr),
          SizedBox(height: 8),
          abRadioButtons(controller.requireSafetyBoots, (b) {
            setState(() {
              controller.data.requireSafetyBoot = b == null ? '' : b.toString();
              controller.requireSafetyBoots = b;
            });
          }, showIcon: true),
          SizedBox(height: 16),
          abTitle('shoeSize'.tr),
          SizedBox(height: 8),
          abDropDownButton(
              controller.selectedItem, controller.dropDowns.safetyBootSize,
              (value) {
            setState(() {
              controller.data.safetyBootSize = value.id;
              controller.selectedItem = value;
            });
          }),
          SizedBox(height: 16),
          CheckboxListTile(
            title: abTitle('dbs'.tr),
            contentPadding: EdgeInsets.zero,
            value: controller.data.dbsCheck == '1',
            onChanged: (newValue) {
              controller.data.dbsCheck = (newValue ?? false) ? '1' : '2';
              setState(() {});
            },
          ),
          SizedBox(height: 16),
          if (controller.data.dbsCheck == '1') ...[
            abTitle('Date of expiry'),
            SizedBox(height: 16),
            abStatusButton(
                dateToString(controller.dbsDate, false) ?? 'dd/mm/yyyy', null,
                () async {
              final now = getNow;
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: controller.dbsDate ?? now,
                firstDate: now,
                lastDate: DateTime(now.year + 10),
              );
              if (picked != null) {
                setState(() {
                  controller.dbsDate = picked;
                  controller.data.dbsDate = dateToString(picked, true) ?? '';
                });
              }
            }, hideStatus: true),
            SizedBox(height: 16),
          ],
          if (!isDriver) ...[
            InkWell(
              onTap: () {
                abShowAlert(context, '48hours'.tr, 'ok');
              },
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: MyColors.lightBlue,
                  ),
                  SizedBox(width: 16),
                  Text(
                    '48 hours',
                    style: MyFonts.regular(18, color: MyColors.black).merge(
                      TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            abDropDownButton(controller.selected48Hour,
                controller.selected48Hour.id.isEmpty ? [] : controller.hours48,
                (newValue) {
              controller.selected48Hour = newValue;
              controller.data.hourOutput = newValue.id;
              setState(() {});
            }),
            SizedBox(height: 16),
          ],
          if (controller.isForklift) ...[
            abTitle('Please upload your Forklift Licence'),
            SizedBox(height: 16),
            abStatusButton('Forklift', controller.isForkliftDocUploaded,
                () async {
              listToUploadController.type = KeyValue.fromJson({});
              final success = await Get.to(
                  () => UploadDocumentsView(controller: listToUploadController),
                  arguments: {'isForklift': true});
              setState(() => controller.isForkliftDocUploaded = success);
            }),
            SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('yourAvailability'.tr),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: top())),
              abBottom(onTap: (i) async {
                if (i == 0) {
                  final error = controller.validate();
                  if (error.isNotEmpty) {
                    abShowMessage(error);
                    return;
                  }
                  final message = await controller.updateTempWorkInfo();
                  if (message.isNotEmpty) {
                    abShowMessage(message);
                    return;
                  }
                  await Resume.shared.setDone();
                  if (isDriver) {
                    Get.to(() => DrivingTestView());
                  } else if (isQuizTest && !is35T) {
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
              })
            ],
          ),
        ),
      ),
    );
  }
}
