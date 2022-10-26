import 'package:extra_staff/controllers/set_password_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/choose_code_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({Key? key}) : super(key: key);

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final controller = SetPasswordController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
          abTitle('enterPassword'.tr),
          SizedBox(height: 8),
          abPasswordField('', (text) => controller.password = text,
              validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }),
          SizedBox(height: 16),
          abTitle('reEnterPassword'.tr),
          SizedBox(height: 8),
          abPasswordField('', (text) => controller.rePassword = text,
              validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }, onFieldSubmitted: (e) async {
            await next();
          }),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('setPassword'.tr, showHome: false, showBack: false),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: top())),
              abBottom(
                bottom: null,
                onTap: (i) async {
                  if (i == 0) {
                    await next();
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
    if (!controller.formKey.currentState!.validate()) {
      return;
    } else if (controller.password.length < 6) {
      abShowMessage('pMin6'.tr);
      return;
    } else if (controller.password != controller.rePassword) {
      abShowMessage('pSame'.tr);
      return;
    }
    setState(() => isLoading = true);
    final message = await controller.addPassword();
    final message2 = await controller.updateTempPwdInfo();
    setState(() => isLoading = false);
    if (message.isEmpty && message2.isEmpty) {
      Get.to(() => ChooseCode());
    } else {
      abShowMessage('$message $message2');
    }
  }
}
