import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/legal_agreements/agreements_v.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/controllers/legal_agreements/hmrc_checklist_c.dart';
import 'package:loading_overlay/loading_overlay.dart';

class HMRCChecklistView extends StatefulWidget {
  const HMRCChecklistView({Key? key}) : super(key: key);

  @override
  _HMRCChecklistViewState createState() => _HMRCChecklistViewState();
}

class _HMRCChecklistViewState extends State<HMRCChecklistView>
    with SingleTickerProviderStateMixin {
  final controller = HMRCCheckListController();
  bool isLoading = false;

  late final AnimationController aController =
      AnimationController(duration: duration, vsync: this);

  @override
  void initState() {
    super.initState();
    controller.answers[0] = Get.arguments['answers'];
    aController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    aController.dispose();
  }

  apiCall() async {
    setState(() => isLoading = true);
    final message = await controller.updateTempHMRCInfo();
    setState(() => isLoading = false);
    if (message.isNotEmpty) {
      abShowMessage(message);
      return;
    }
    await localStorage?.setBool('isHMRCCompleted', true);
    await Resume.shared.setDone();
    Get.to(() => AgreementsView(), arguments: Get.arguments);
  }

  Widget question() {
    final data = controller.startingData[controller.selectedIndex];
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
          .animate(aController),
      child: FadeTransition(
        opacity: aController,
        child: abWords(data['text']!, data['highlight']!, null),
      ),
    );
  }

  Widget showPlans(Map<String, List<String>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        if (!controller.isOption1)
          Text(
            data.keys.first,
            style: MyFonts.regular(20),
          ),
        SizedBox(height: 16),
        for (var i in data[data.keys.first]!)
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Icon(Icons.arrow_forward, color: MyColors.lightBlue),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(i, style: MyFonts.regular(20)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(height: 2, color: MyColors.lightBlue),
              SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abQuestions(context, true, controller.selectedIndex + 1,
            controller.startingData.length),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: gHPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    question(),
                    if (controller.isOption4 || controller.isOption1) ...[
                      SizedBox(height: 32),
                      Text(
                        'Student Loan Plans',
                        style: MyFonts.bold(24, color: MyColors.darkBlue),
                      ),
                      for (var i in controller.option4Display) showPlans(i),
                    ],
                    if (controller.isOption5) ...[
                      for (var i in controller.option5Display) showPlans(i),
                    ],
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            abBottom(
              top: null,
              multiple: controller.bottomOptions,
              onTap: (i) async {
                if (i == 2) {
                  controller.answers[controller.selectedIndex + 1].value = '1';
                  controller.nextQuestion();
                } else if (i == 3) {
                  controller.answers[controller.selectedIndex + 1].value = '2';
                  if (controller.selectedIndex < 4) {
                    controller.jumpQuestion();
                  } else {
                    if (controller.selectedIndex ==
                        controller.startingData.length - 2) {
                      await apiCall();
                    } else {
                      await apiCall();
                    }
                  }
                } else if (i == 4) {
                  controller.answers[controller.selectedIndex + 1].value =
                      '1,2';
                  controller.nextQuestion();
                }
                setState(() {});
                if (controller.selectedIndex ==
                    controller.startingData.length) {
                  controller.selectedIndex -= 1;
                  await apiCall();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
