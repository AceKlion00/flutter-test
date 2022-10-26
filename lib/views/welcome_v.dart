import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/login_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: abHeader('howCanWeHelp'.tr, showHome: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Spacer(),
          Container(
            padding: gHPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // abSimpleButton(
                //   'applyForaJob'.tr.toUpperCase(),
                //   onTap: () => Get.to(() => QuestionsView()),
                // ),
                SizedBox(height: 32),
                // abSimpleButton(
                //   'alreadySignedUp'.tr.toUpperCase(),
                //   onTap: () => Get.to(() => AlreadySignedUp()),
                // ),
                abSimpleButton(
                  'signIn'.tr.toUpperCase(),
                  onTap: () => Get.to(() => LoginView(), arguments: false),
                ),
                SizedBox(height: 32),
                abSimpleButton(
                  'signUp'.tr.toUpperCase(),
                  onTap: () => Get.to(() => LoginView(), arguments: true),
                ),
              ],
            ),
          ),
          Spacer(),
          abBottom(top: null),
        ],
      ),
    );
  }
}
