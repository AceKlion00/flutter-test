import 'package:extra_staff/models/user_data_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/views/biometric_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChooseCode2 extends StatefulWidget {
  const ChooseCode2({Key? key}) : super(key: key);

  @override
  _ChooseCode2State createState() => _ChooseCode2State();
}

class _ChooseCode2State extends State<ChooseCode2> {
  bool isLoading = false;
  String code = '';

  @override
  initState() {
    super.initState();
    code = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('confirmCode'.tr, showHome: false),
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
                  if (v == code) {
                    setState(() => isLoading = true);
                    final name = userName;
                    final post = isDriver;
                    final storedDevice = device;
                    await removeAllSharedPref();
                    await localStorage?.setString('device', storedDevice);
                    await localStorage?.setString('userName', name);
                    await localStorage?.setBool('isDriver', post);
                    await localStorage?.setInt(
                        'userId', Services.shared.tempUserId);
                    await localStorage?.setInt('tid', Services.shared.tempTid);
                    await Services.shared.setData();
                    await localStorage?.setString('passcode', v);
                    final message = await Services.shared.updateTempLogInfo();
                    final message2 = await Services.shared.updateTempPassInfo();
                    final message3 =
                        await Services.shared.getTempProgressInfo();
                    final deskInfo = await Services.shared.getTempDeskInfo();
                    await getTempUserData();
                    setState(() => isLoading = false);
                    if (message.errorMessage.isNotEmpty ||
                        message2.errorMessage.isNotEmpty ||
                        message3.errorMessage.isNotEmpty) {
                      abShowMessage(
                          '${message.errorMessage} ${message2.errorMessage} ${message3.errorMessage}');
                    } else {
                      if (deskInfo.errorMessage.isNotEmpty) {
                        abShowMessage(deskInfo.errorMessage);
                      } else {
                        if (deskInfo.result['isDriver'] is bool) {
                          await localStorage?.setBool(
                              'isDriver', deskInfo.result['isDriver']);
                        }
                      }
                      await Resume.shared
                          .completedProgress(message3.result['screen_id']);
                      await localStorage?.setString(
                          'completed', message3.result['completed']);
                      await Services.shared.setData();
                      Get.to(() => BiometricView(true));
                    }
                  } else {
                    abShowMessage('passcodeNotMathcing'.tr);
                  }
                },
                onChanged: (value) {
                  setState(() {});
                },
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

  Future getTempUserData() async {
    await Services.shared.setData();
    final response = await Services.shared.getTempUserData();
    UserData data = UserData.fromJson({});
    if (response.result is Map) data = UserData.fromJson(response.result);
    if (response.errorMessage.isEmpty) {
      await localStorage?.setString(
          'userName', data.firstName + ' ' + data.lastName);
    } else {
      abShowMessage(response.errorMessage);
    }
  }
}
