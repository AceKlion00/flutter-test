import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:extra_staff/views/quick_temp_add_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionsView extends StatefulWidget {
  @override
  _QuestionsView createState() => _QuestionsView();
}

class _QuestionsView extends State<QuestionsView> {
  var left = 0.0;
  var right = 0.0;
  var top = 0.0;
  var bottom = 0.0;
  var opacity = 0.0;
  var finalWidth = 0.0;
  var finalHeight = 100.0;
  var selection = '';
  var anime = 0.0;
  var question = {};
  var counter = -1;
  bool isCompleted = true;
  List<bool?> answers = [];

  final data = [
    {'text': 'q1'.tr, 'highlight': 'h1'.tr, 'key': 'k1'.tr},
    {'text': 'q2'.tr, 'highlight': 'h2'.tr, 'key': 'k2'.tr},
    {'text': 'q3'.tr, 'highlight': 'h3'.tr, 'key': 'k3'.tr},
    {'text': 'q4'.tr, 'highlight': 'h4'.tr, 'key': 'k4'.tr},
    {'text': 'q5'.tr, 'highlight': 'h5'.tr, 'key': 'k5'.tr},
  ];

  @override
  void initState() {
    super.initState();
    for (var _ in data) {
      answers.add(null);
    }
    reset();
  }

  Widget questions() {
    final double size = (MediaQuery.of(context).size.width * 25) / 375;
    return Expanded(
      child: Container(
        padding: gHPadding,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: duration,
              top: top,
              bottom: bottom,
              left: left,
              right: right,
              child: AnimatedOpacity(
                duration: duration,
                opacity: opacity,
                child: question.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          abWords(question['text'], question['highlight'], null,
                              size: size),
                          SizedBox(height: 16),
                          Text(
                            question['key'],
                            style:
                                MyFonts.medium(size - 10, color: MyColors.grey),
                          ),
                          SizedBox(height: 16),
                        ],
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget answer() {
    final t1 = counter == 0 ? 'driving'.tr : 'yes'.tr;
    final t2 = counter == 0 ? 'industrial'.tr : 'no'.tr;
    return Container(
      padding: gHPadding,
      height: (buttonHeight * 2) + (3 * 16),
      color: MyColors.darkBlue,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: duration,
            top: top,
            bottom: bottom,
            left: left,
            right: right,
            child: AnimatedOpacity(
              duration: duration,
              opacity: opacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () => action(true),
                    child: questionButton(t1, selection == 'yes'.tr),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      if (counter == 0) {
                        action(false);
                      } else {
                        abShowAlert(context, 'pleaseSelectYes'.tr, 'yes'.tr);
                      }
                    },
                    child: questionButton(t2, selection == 'no'.tr),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget questionButton(String title, bool clicked) {
    return Container(
      height: buttonHeight,
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(clicked ? anime : 0),
        duration: duration,
        child: Stack(
          children: [
            Container(
              color: MyColors.white,
            ),
            AnimatedContainer(
              duration: duration,
              color: MyColors.lightBlue,
              margin: EdgeInsets.only(left: clicked ? finalWidth : 5),
            ),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedDefaultTextStyle(
                  child: Text(title),
                  duration: duration,
                  style: MyFonts.regular(28,
                      color: clicked ? MyColors.lightBlue : MyColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = counter + 1;
    return Scaffold(
      appBar: abHeader(
        '',
        showHome: false,
        onTap: (i) {
          setState(() {
            selection = '';
            if (counter > 0) {
              counter -= 1;
            } else {
              Get.back();
            }
            left = finalWidth;
            right = -finalWidth;
          });
          Future.delayed(duration, () {
            setState(() {
              question = data[counter];
              top = 0;
              bottom = 0;
              left = 0;
              right = 0;
              opacity = 1;
            });
          });
        },
        center: abCounts(current, data.length),
        bottom: abBottomBar(context, current, data.length),
      ),
      body: Column(
        children: [questions(), answer(), bottomImage()],
      ),
    );
  }

  Widget bottomImage() {
    final value = answers.isNotEmpty && answers.first == true;
    final image = 'lib/images/${value ? 'driving' : 'warehouse'}.png';
    return Image(image: AssetImage(image), fit: BoxFit.fitWidth);
  }

  void action(bool isYes) {
    if (!isCompleted) return;
    setState(() {
      anime = 5;
      isCompleted = false;
      selection = isYes ? 'yes'.tr : 'no'.tr;
    });
    answers[counter] = isYes;
    Future.delayed(duration, () => setState(() => anime = 0)).then((value) {
      Future.delayed(duration, () {
        setState(() {
          opacity = 0;
          if (counter == data.length - 1) {
            top = -finalHeight;
            bottom = finalHeight;
          } else {
            left = -finalWidth;
            right = finalWidth;
          }
        });
      }).then((value) => reset()).then((value) {
        Future.delayed(duration * 2, () => setState(() => isCompleted = true));
        if (counter == data.length - 1) {
          Future.delayed(duration, () async {
            await localStorage?.setBool('isDriver', answers.first!);
            Get.bottomSheet(
              NewInfoView(2, () {
                Get.bottomSheet(
                  NewInfoView(3, () {
                    Get.to(() => QuickTempAdd(), arguments: answers);
                  }),
                  enableDrag: false,
                  isDismissible: false,
                  isScrollControlled: true,
                );
              }),
              enableDrag: false,
              isDismissible: false,
              isScrollControlled: true,
            );
          });
        }
      });
    });
  }

  reset() {
    Future.delayed(duration, () {
      setState(() {
        selection = '';
        counter = counter < data.length - 1 ? counter + 1 : 0;
        question = data[counter];
        finalWidth = MediaQuery.of(context).size.width - (gHPadding.left * 2);
        finalHeight = (MediaQuery.of(context).size.height - 100) / 2;
        left = finalWidth;
        right = -finalWidth;
      });
    }).then((value) {
      Future.delayed(duration, () {
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
}
