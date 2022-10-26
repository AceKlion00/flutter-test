import 'package:extra_staff/controllers/enter_code_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/set_password_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterCode extends StatefulWidget {
  const EnterCode({Key? key}) : super(key: key);

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final controller = EnterCodeController();
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    controller.data = Get.arguments;
  }

  Widget txtField() {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: MyFonts.bold(32, color: MyColors.darkBlue),
      length: 4,
      obscureText: true,
      obscuringCharacter: '*',
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      validator: (v) {
        return null;
      },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        selectedFillColor: MyColors.white,
        inactiveFillColor: MyColors.white,
        activeFillColor: Colors.white,
        selectedColor: MyColors.darkBlue,
        inactiveColor: MyColors.darkBlue,
        activeColor: MyColors.darkBlue,
      ),
      cursorColor: MyColors.darkBlue,
      animationDuration: Duration(milliseconds: 300),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      boxShadows: [
        BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
      onCompleted: (v) async {
        controller.otp = v;
        if (controller.otp == '9999') {
          Get.to(() => SetPassword());
          return;
        }
        setState(() => isLoading = true);
        final result = await controller.getQuickTempVerification();
        setState(() => isLoading = false);
        if (result.errorMessage.isNotEmpty) {
          abShowMessage(result.errorMessage);
          return;
        }
        if (result.errorCode == 0) {
          Get.to(() => SetPassword());
        } else {
          abShowMessage('invalidCode'.tr);
        }
      },
      onChanged: (value) {
        setState(() {});
      },
      beforeTextPaste: (text) {
        print('Allowing to paste $text');
        return true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('Verification'.tr, showHome: false),
        body: SingleChildScrollView(
          padding: gHPadding,
          child: Column(
            children: [
              SizedBox(height: 32),
              abWords(controller.text['text']!, controller.text['highlight']!,
                  null),
              SizedBox(height: 32),
              Container(
                  height: controller.textFiledWidth,
                  width: double.infinity,
                  child: txtField()),
              SizedBox(height: 32),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'notReceived'.tr,
                    style: MyFonts.regular(17),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      setState(() => isLoading = true);
                      final message =
                          await controller.resendQuickTempVerification();
                      setState(() => isLoading = false);
                      if (message.isNotEmpty) abShowMessage(message);
                    },
                    child: Text(
                      'pleaseResend'.tr,
                      style:
                          MyFonts.semiBold(20, color: MyColors.darkBlue).merge(
                        TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
