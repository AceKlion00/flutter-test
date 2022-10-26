import 'package:extra_staff/controllers/login_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/login_v.dart';
import 'package:extra_staff/views/registration_progress_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterCode extends StatefulWidget {
  final bool isFromStart;
  const EnterCode({Key? key, required this.isFromStart}) : super(key: key);

  @override
  _EnterCodeState createState() => _EnterCodeState(isFromStart: isFromStart);
}

class _EnterCodeState extends State<EnterCode> {
  _EnterCodeState({required this.isFromStart});
  bool isLoading = false;
  bool isFromStart;
  int pinLength = 4;
  String pin = '';
  TextEditingController controller = TextEditingController(text: '');
  final loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar:
            abHeader('enterCode'.tr, showHome: false, showBack: !isFromStart),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: gHPadding,
                      child: Center(
                        child: PinCodeTextField(
                          controller: controller,
                          appContext: context,
                          textStyle:
                              MyFonts.semiBold(32, color: MyColors.darkBlue),
                          pastedTextStyle:
                              MyFonts.bold(32, color: MyColors.darkBlue),
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
                          keyboardType: TextInputType.none,
                          boxShadows: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) async {
                            final code =
                                localStorage?.getString('passcode') ?? '';
                            if (code == v) {
                              Get.to(() => RegistrationProgress());
                            } else {
                              abShowMessage('passcodeNotMathcing'.tr);
                            }
                          },
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            print('Allowing to paste $text');
                            return true;
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: gHPadding,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          textStyle: MyFonts.semiBold(17),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Get.to(() => LoginView(), arguments: true);
                        },
                        child: Text('Forgot passcode'.toUpperCase()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: Get.height / 2,
              padding: EdgeInsets.all(16),
              color: MyColors.lightGrey.withAlpha(80),
              child: GridView.count(
                childAspectRatio: 1.5,
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: loginController.allItems
                    .map(
                      (item) => GridTile(
                        child: Container(
                          color: MyColors.white,
                          child: create(item),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget create(item) {
    if (item == '-1') {
      return IconButton(
        onPressed: () {
          setState(() {
            if (pin.isNotEmpty) {
              pin = pin.substring(0, pin.length - 1);
            }
            controller.text = pin;
          });
        },
        icon: Icon(
          Icons.backspace_outlined,
          size: 35,
          color: MyColors.black,
        ),
      );
    } else if (item == '+1') {
      return IconButton(
        onPressed: () async {
          final isBiomatricAvaliable =
              await loginController.isBiometricsAvaliable();
          if (isBiomatricAvaliable) {
            final isAuth = await loginController.checkAuth();
            if (isAuth) {
              Get.to(() => RegistrationProgress());
            } else {
              abShowMessage('passcodeNotMathcing'.tr);
            }
          } else {
            abShowMessage('error'.tr);
          }
        },
        icon: Image.asset('lib/images/face.png'),
      );
    } else {
      return TextButton(
        onPressed: () {
          setState(() {
            pin += item;
            controller.text = pin;
          });
        },
        child: Text(
          item,
          textAlign: TextAlign.center,
          style: MyFonts.medium(40, color: MyColors.black),
        ),
      );
    }
  }
}
