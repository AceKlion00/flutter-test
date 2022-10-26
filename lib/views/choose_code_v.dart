import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/choose_code2_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChooseCode extends StatefulWidget {
  const ChooseCode({Key? key}) : super(key: key);

  @override
  _ChooseCodeState createState() => _ChooseCodeState();
}

class _ChooseCodeState extends State<ChooseCode> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('chooseCode'.tr, showHome: false),
        body: Container(
          padding: gHPadding,
          child: Column(
            children: [
              SizedBox(height: 64),
              PinCodeTextField(
                appContext: context,
                textStyle: MyFonts.semiBold(32, color: MyColors.darkBlue),
                pastedTextStyle: MyFonts.bold(32, color: MyColors.darkBlue),
                length: 4,
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  return null;
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 64,
                  fieldWidth: 64,
                  selectedFillColor: MyColors.white,
                  inactiveFillColor: MyColors.white,
                  activeFillColor: Colors.grey[200],
                  selectedColor: MyColors.darkBlue,
                  inactiveColor: MyColors.lightGrey,
                  activeColor: MyColors.lightGrey,
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
                  Get.to(() => ChooseCode2(), arguments: v);
                },
                onChanged: (value) {},
                beforeTextPaste: (text) {
                  print('Allowing to paste $text');
                  return true;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
