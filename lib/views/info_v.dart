import 'package:flutter/material.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/controllers/info_c.dart';
import 'package:get/get.dart';

class InfoView extends StatelessWidget {
  InfoView(this.index, this.onTap) : controller = InfoController(index);

  final int index;
  final Function() onTap;
  final InfoController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (index == 0 || index == 1)
              Padding(
                padding: EdgeInsets.only(right: gHPadding.right),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: onTap,
                    child: Text(
                      index == 0 ? 'skip'.tr : 'start'.tr,
                      style: MyFonts.regular(24, color: MyColors.grey),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: gHPadding,
                  child: Column(
                    children: [
                      SizedBox(height: 32),
                      Image(
                        image: AssetImage(
                            'lib/images/${controller.current.image}.png'),
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(height: 32),
                      Text(
                        controller.current.title,
                        textAlign: TextAlign.center,
                        style: MyFonts.regular(36, color: MyColors.darkBlue),
                      ),
                      SizedBox(height: 32),
                      Text(
                        controller.current.details,
                        textAlign: TextAlign.center,
                        style: MyFonts.regular(20, color: MyColors.grey),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            if (index > 1) ...[
              Container(
                padding: gHPadding,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    onTap();
                  },
                  child: Text('NEXT', style: MyFonts.regular(20)),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.infinity, 60),
                    primary: MyColors.darkBlue,
                    onPrimary: MyColors.white,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }
}
