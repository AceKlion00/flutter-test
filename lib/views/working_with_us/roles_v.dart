import 'package:extra_staff/controllers/working_with_us/roles_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/working_with_us/skills_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RolesView extends StatefulWidget {
  const RolesView({Key? key}) : super(key: key);

  @override
  _RolesViewState createState() => _RolesViewState();
}

class _RolesViewState extends State<RolesView> {
  final controller = RolesViewController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    setState(() => isLoading = true);
    await controller.apiCalls();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('rolesForYou'.tr),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: gHPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    Text(
                      'topRoles'.tr,
                      style: MyFonts.regular(18, color: MyColors.lightBlue),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.roles.length,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, position) {
                        return Column(
                          children: [
                            CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              value: controller.isSelected(position),
                              onChanged: (v) => setState(() {
                                controller.addOrRemoveRole(position);
                              }),
                              title: abTitle(controller.roles[position].value),
                            ),
                            Divider(thickness: 2, color: MyColors.offWhite),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            abBottom(onTap: (i) async {
              if (i == 0) {
                final message = await controller.updateTempRolesInfo();
                if (message.isNotEmpty) {
                  abShowMessage(message);
                  return;
                }
                await controller.setDataInStorage();
                await Resume.shared.setDone();
                Get.to(() => SkillsView());
              } else {
                Get.back(result: true);
              }
            }),
          ],
        ),
      ),
    );
  }
}
