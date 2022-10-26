import 'package:extra_staff/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:extra_staff/views/welcome_v.dart';

import 'package:get/get.dart';

class PageControllerController {
  final pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  var data = {
    '1': {
      'text': 'orisq'.tr,
      'highlight': 'super',
    },
    '2': {
      'text': 'orisq'.tr,
      'highlight': 'super',
    },
    '3': {
      'text': 'orisq'.tr,
      'highlight': 'super',
    },
  };

  onChange(bool forward) {
    int nextPage = pageController.page!.toInt() + (forward ? 1 : -1);
    if (nextPage >= data.length) {
      nextPage = 0;
      Get.to(() => WelcomeView());
    }

    pageController.animateToPage(nextPage,
        duration: duration, curve: Curves.easeIn);
  }
}
