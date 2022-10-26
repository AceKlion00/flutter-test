import 'package:extra_staff/controllers/login_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/choose_code_v.dart';
import 'package:extra_staff/views/enter_code_v.dart';
import 'package:extra_staff/views/forgot_passcode_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = LoginController();
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    if (Get.arguments != null) {
      setState(() {
        controller.withoutPassword = Get.arguments;
      });
    }
  }

  Widget top() {
    return Container(
      padding: gHPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
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
          }, onFieldSubmitted: (e) async {}),
          if (!controller.withoutPassword) ...[
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
            SizedBox(height: 8),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  textStyle: MyFonts.semiBold(17),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Get.to(() => ForgotPasscodeView(), arguments: true);
                },
                child: Text('Forgot passcode'.toUpperCase()),
              ),
            ),
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
        appBar: abHeader('login'.tr, showHome: false),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: top())),
              abBottom(
                bottom: 'back'.tr,
                onTap: (i) async {
                  if (i == 0) {
                    setState(() => isLoading = true);
                    final message = await controller.login();
                    setState(() => isLoading = false);
                    if (message.isEmpty) {
                      if (controller.withoutPassword) {
                        Get.to(() => EnterCode(), arguments: controller.result);
                      } else {
                        Get.to(() => ChooseCode());
                      }
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
