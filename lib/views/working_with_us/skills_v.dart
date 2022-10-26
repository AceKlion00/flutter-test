import 'package:extra_staff/controllers/working_with_us/skills_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/working_with_us/licences_upload_v.dart';
import 'package:extra_staff/views/working_with_us/availability2_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SkillsView extends StatefulWidget {
  const SkillsView({Key? key}) : super(key: key);

  @override
  _SkillsViewState createState() => _SkillsViewState();
}

class _SkillsViewState extends State<SkillsView> {
  final controller = SkillsViewController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    setState(() => isLoading = true);
    controller.getDataFromStorage();
    await controller.apiCalls();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('skillsForYou'.tr),
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
                      'topSkills'.tr,
                      style: MyFonts.regular(18, color: MyColors.lightBlue),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.skills.length,
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
                              title: abTitle(controller.skills[position].value),
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
                final message = await controller.updateTempSkillsInfo();
                if (message.isNotEmpty) {
                  abShowMessage(message);
                  return;
                }
                await Resume.shared.setDone();
                Get.to(() => isDriver ? LicencesUploadView() : Availability2());
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
