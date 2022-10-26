import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/enter_code_v.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:extra_staff/controllers/forgot_passcode_c.dart';

class ForgotPasscodeView extends StatefulWidget {
  const ForgotPasscodeView({Key? key}) : super(key: key);

  @override
  State<ForgotPasscodeView> createState() => _ForgotPasscodeViewState();
}

class _ForgotPasscodeViewState extends State<ForgotPasscodeView> {
  final controller = ForgotPasscodeController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('login'.tr, showHome: false),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: gHPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      abTitle('emailAddress'.tr),
                      SizedBox(height: 8),
                      abTextField('', (text) => controller.emailAddress = text,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enterText'.tr;
                        } else if (!value.isEmail) {
                          return 'validEmail'.tr;
                        }
                        return null;
                      }, onFieldSubmitted: (e) async {}),
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
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              abBottom(
                bottom: 'back'.tr,
                onTap: (i) async {
                  if (i == 0) {
                    final message = await controller.verifyUserFromEmailPhone();
                    if (message.isEmpty) {
                      Get.to(() => EnterCode(), arguments: controller.result);
                    } else {
                      abShowMessage(message);
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
}
