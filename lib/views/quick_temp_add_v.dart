import 'package:extra_staff/controllers/quick_temp_add_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/enter_code_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class QuickTempAdd extends StatefulWidget {
  const QuickTempAdd({Key? key}) : super(key: key);

  @override
  _QuickTempAddState createState() => _QuickTempAddState();
}

class _QuickTempAddState extends State<QuickTempAdd> {
  final controller = QuickTempAddController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller.answers = Get.arguments;
    getUserTempData();
  }

  getUserTempData() async {
    try {
      setState(() => isLoading = true);
      final message = await controller.getBranchInfo();
      setState(() => isLoading = false);
      if (message.isNotEmpty) abShowMessage(message);
    } catch (error) {
      print(error.toString());
    }
  }

  Widget field(String title, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        abTitle(title),
        SizedBox(height: 8),
        abTextField(title, (text) {}, keyboardType: keyboardType),
        SizedBox(height: 16),
      ],
    );
  }

  Widget top() {
    return Container(
      padding: gHPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          abTitle('nearLocation'.tr),
          SizedBox(height: 8),
          if (controller.selectedLocation != null)
            abDropDownButton(controller.selectedLocation!, controller.locations,
                (value) async {
              setState(() => controller.selectedLocation = value);
            }),
          SizedBox(height: 16),
          abTitle('salutation'.tr),
          SizedBox(height: 8),
          abDropDownButton(controller.selectedSalutation, controller.salutation,
              (value) async {
            setState(() => controller.selectedSalutation = value);
          }),
          SizedBox(height: 16),
          abTitle('firstName'.tr),
          SizedBox(height: 8),
          abTextField('', (text) => controller.firstName = text,
              validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }),
          SizedBox(height: 16),
          abTitle('lastName'.tr),
          SizedBox(height: 8),
          abTextField('', (text) => controller.lastName = text,
              validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }),
          SizedBox(height: 16),
          abTitle('enterPhone'.tr),
          SizedBox(height: 8),
          abTextField(
            '',
            (text) => controller.phoneNo = text,
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
          abTitle('emailAddress'.tr),
          SizedBox(height: 8),
          abTextField('', (text) => controller.emailAddress = text,
              keyboardType: TextInputType.emailAddress, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            } else if (!value.isEmail) {
              return 'validEmail'.tr;
            }
            return null;
          }, onFieldSubmitted: (e) async {
            next();
          }),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('initialInfo'.tr, showHome: false),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: top())),
              abBottom(
                bottom: 'unlinkAccount'.tr,
                onTap: (i) async {
                  if (i == 0) {
                    if (controller.validate()) {
                      next();
                    } else {
                      abShowMessage('error'.tr);
                    }
                  } else {
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

  next() async {
    if (controller.validate()) {
      setState(() => isLoading = true);
      final message = await controller.addQuickTemp();
      setState(() => isLoading = false);
      if (message == '') {
        await localStorage?.setString(
            'userName', controller.firstName + ' ' + controller.lastName);
        Get.to(() => EnterCode(), arguments: controller.result);
      } else {
        abShowMessage(message);
      }
    } else {
      abShowMessage('error'.tr);
    }
  }
}
