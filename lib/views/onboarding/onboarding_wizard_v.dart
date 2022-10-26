import 'package:extra_staff/controllers/onboarding_wizard_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/onboarding/competency_test_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class OnboardingWizard extends StatefulWidget {
  const OnboardingWizard({Key? key}) : super(key: key);

  @override
  _OnboardingWizardState createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends State<OnboardingWizard> {
  var counter = -1;
  var left = 0.0;
  var right = 0.0;
  var top = 0.0;
  var bottom = 0.0;
  var opacity = 0.0;
  final duration2 = Duration(milliseconds: 125);
  final duration3 = Duration(milliseconds: 500);

  final controller = OnboardingWizardController();
  var isLoading = false;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() => isLoading = true);
    await controller.getCompetancyInfo();
    setState(() => isLoading = false);
    if (controller.lastIndex != null &&
        controller.lastIndex! < controller.questions.length - 1) {
      counter = controller.lastIndex!;
    }
    reset();
  }

  reset() {
    if (counter == controller.questions.length - 1) return;
    Future.delayed(duration2, () {
      setState(() {
        counter = counter < controller.questions.length - 1 ? counter + 1 : 0;
        controller.question = controller.questions[counter];
        left = MediaQuery.of(context).size.width - 56;
        right = -(MediaQuery.of(context).size.height - 100) / 2;
      });
    }).then((value) {
      Future.delayed(duration2, () {
        setState(() {
          top = 0;
          bottom = 0;
          left = 0;
          right = 0;
          opacity = 1;
        });
      });
    });
  }

  Widget questions() {
    final noImage = controller.question.questionImg.isEmpty;
    double height =
        (controller.question.question.length * 4) + (noImage ? 0 : 116);
    return Container(
      height: height,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: duration2,
            top: top,
            bottom: bottom,
            left: left,
            right: right,
            child: AnimatedOpacity(
              duration: duration2,
              opacity: opacity,
              child: controller.question.question.isEmpty
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        abWords(controller.question.question,
                            controller.question.question, WrapAlignment.start),
                        if (!noImage) SizedBox(height: 16),
                        if (!noImage)
                          Image.network(
                            controller.question.questionImg,
                            height: 100,
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft,
                            errorBuilder: (context, exception, stackTrace) {
                              return Container();
                            },
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget button(String title, List<String> options) {
    final index = options.indexOf(title);
    final isSelected = index == controller.selection;
    var backColor = isSelected && controller.question.selectedAnswer > 0
        ? controller.question.selectedAnswer == controller.question.answer
            ? Color.fromRGBO(077, 189, 118, 1)
            : Color.fromRGBO(248, 108, 107, 1)
        : isSelected
            ? MyColors.lightBlue
            : null;
    if (controller.isCompleted && index == controller.question.answer - 1) {
      backColor = Color.fromRGBO(077, 189, 118, 1);
    }
    return abSimpleButton(title, backgroundColor: backColor, onTap: () {
      if (!controller.isCompleted && controller.selection < 0) {
        setState(() => controller.selection = index);
        Future.delayed(duration3, () async => await next());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final options = controller.question.getAllOptions();
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abQuestions(
            context, false, counter + 1, controller.questions.length),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: gHPadding,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    questions(),
                    SizedBox(height: 16),
                    for (var item in options) ...[
                      button(item, options),
                      SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
            if (controller.isCompleted)
              abBottom(onTap: (i) async {
                if (i == 0) {
                  await next();
                }
              })
          ],
        ),
      ),
    );
  }

  next() async {
    fallBackTimer(false);
    scrollController.animateTo(0, duration: duration2, curve: Curves.ease);
    if (!controller.isCompleted && controller.selection < 0) {
      abShowMessage('pleaseSelectOption'.tr);
    } else {
      setState(
          () => controller.question.selectedAnswer = controller.selection + 1);
      Future.delayed(duration * 2, () async {
        await Future.delayed(duration3, () {});
        setState(() => controller.selection = -1);
        if (!controller.isCompleted) {
          setState(() => isLoading = true);
          final message = await controller.updateTempCompetancyInfo();
          setState(() => isLoading = false);
          if (message.isNotEmpty) {
            abShowMessage(message);
            return;
          }
        }
        if (counter == controller.questions.length - 1) {
          await localStorage?.setBool('isCompetencyTestCompleted', true);
          await Resume.shared.setDone();
          await Resume.shared.setDone(name: (CompetencyTest).toString());
          Get.to(() => CompetencyTest())?.then((value) => getData());
        }
      }).then((value) => reset());
    }
  }
}
