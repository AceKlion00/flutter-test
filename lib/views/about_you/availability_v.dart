import 'package:extra_staff/controllers/about_you/availability_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/about_you/bank_details_v.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Availability extends StatefulWidget {
  const Availability({Key? key}) : super(key: key);

  @override
  _AvailabilityState createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  final controller = AvailabilityController();

  Map<String, dynamic> allData = {};
  bool isLoading = false;
  final isNiUploaded = localStorage?.getBool('isNiUploaded') ?? false;

  @override
  void initState() {
    super.initState();
    controller.data = Get.arguments['aboutYou'];
    controller.dropDowns = Get.arguments['dropDowns'];
    allData = {'aboutYou': controller.data, 'dropDowns': controller.dropDowns};
    setData();
  }

  setData() async {
    await controller.setData();
    if (!isNiUploaded) controller.data.nationalInsurance = '';
    setState(() {});
  }

  Widget top() {
    return Container(
      padding: gHPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          if (isNiUploaded) ...[
            abTitle('nationalInsurance'.tr),
            SizedBox(height: 8),
            abTextField(
                controller.data.nationalInsurance,
                (p0) => controller.data.nationalInsurance =
                    p0.replaceAll(' ', ''), validator: (value) {
              if (value == null || value.isEmpty) {
                return 'enterText'.tr;
              }
              return null;
            }),
            SizedBox(height: 16),
          ],
          abTitle('dateOfBirth'.tr),
          SizedBox(height: 8),
          abStatusButton(controller.formatDateStr(), null, () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: controller.selectedDob ?? maxDate,
              firstDate: minDate,
              lastDate: maxDate,
            );
            if (picked != null && picked != controller.selectedDob) {
              setState(() {
                controller.selectedDob = picked;
                controller.setDate(picked);
              });
            }
          }, hideStatus: true),
          SizedBox(height: 16),
          abTitle('euNS'.tr),
          SizedBox(height: 8),
          abDropDownButton(
              controller.selectedEU, controller.dropDowns.euNational,
              (value) async {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              controller.data.euNational = value.id;
              controller.selectedEU = value;
            });
          }),
          SizedBox(height: 16),
          abTitle('employemntStatus'.tr),
          SizedBox(height: 8),
          abDropDownButton(controller.selectedES, controller.esValues, (v) {
            setState(() {
              controller.data.contract = v.id;
              controller.selectedES = v;
            });
          }),
          SizedBox(height: 16),
          abTitle('emergencyContactName'.tr),
          SizedBox(height: 8),
          abTextField(controller.data.emergencyContact, (text) {
            controller.data.emergencyContact = text;
          }, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }),
          SizedBox(height: 16),
          abTitle('emergencyContactRelationship'.tr),
          SizedBox(height: 8),
          abDropDownButton(
              controller.selectedRelationship, controller.contactRelationship,
              (value) {
            setState(() {
              controller.data.emergencyContactRelationship = value.id;
            });
          }),
          SizedBox(height: 16),
          abTitle('emergencyContactTelephoneNumber'.tr),
          SizedBox(height: 8),
          abTextField(
            controller.data.emergencyContactNumber,
            (text) {
              controller.data.emergencyContactNumber = text;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'enterText'.tr;
              } else if (!isPhoneNo(value)) {
                return 'validPhone'.tr;
              }
              return null;
            },
            keyboardType: TextInputType.number,
            maxLength: 11,
          ),
          SizedBox(height: 16),
          abTitle('hasCriminalConvictions'.tr),
          SizedBox(height: 16),
          abRadioButtons(controller.hasCriminalConvictions, (b) {
            setState(() {
              controller.data.criminal = b! ? '1' : '2';
              controller.hasCriminalConvictions = b;
            });
          }, showIcon: true),
          SizedBox(height: 16),
          abTitle('If yes, please give further details'),
          SizedBox(height: 8),
          abTextField(controller.data.criminalDesc,
              (p0) => controller.data.criminalDesc = p0, validator: (value) {
            if (controller.data.criminal == '1' &&
                (value == null || value.isEmpty)) {
              return 'enterText'.tr;
            }
            return null;
          }),
          SizedBox(height: 16),
          abTitle('How did you hear about Extrastaff?'),
          SizedBox(height: 8),
          abDropDownButton(controller.selectedItem, controller.dropDowns.hearEs,
              (value) async {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              controller.data.hearAboutUS = value.id;
              controller.selectedItem = value;
            });
            await next(0, false);
          }),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  next(int i, bool showMessage) async {
    final error = controller.validate();
    if (error.isNotEmpty) {
      if (showMessage) {
        abShowMessage(error);
      }
      return;
    }
    if (i == 0) {
      setState(() => isLoading = true);
      final message = await controller.updateTempInfo();
      setState(() => isLoading = false);
      if (message.isEmpty) {
        await localStorage?.setString('dob', controller.data.dob);
        await Resume.shared.setDone();
        Get.bottomSheet(
          NewInfoView(5, () {
            Get.to(() => BankDetails(), arguments: allData);
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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('aboutYou'.tr),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: top())),
              abBottom(onTap: (i) async {
                await next(i, true);
              })
            ],
          ),
        ),
      ),
    );
  }
}
