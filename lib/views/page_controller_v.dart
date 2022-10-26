import 'package:dots_indicator/dots_indicator.dart';
import 'package:extra_staff/views/new_info_v.dart';
import 'package:extra_staff/views/welcome_v.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/controllers/page_controller_c.dart';
import 'package:get/get.dart';

class PageControllerView extends StatefulWidget {
  const PageControllerView({Key? key}) : super(key: key);

  @override
  _PageControllerViewState createState() => _PageControllerViewState();
}

class _PageControllerViewState extends State<PageControllerView> {
  final controller = PageControllerController();
  double currentPage = 0;
  bool isSkipped = false;

  Widget viewToShow(int index) {
    return NewInfoView(index, () {
      Get.to(() => WelcomeView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          PageView(
            onPageChanged: (e) => setState(() => currentPage = e.toDouble()),
            controller: controller.pageController,
            children: [
              // viewToShow(0),
              viewToShow(1),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: DotsIndicator(
              position: currentPage,
              dotsCount: 2,
            ),
          ),
        ],
      ),
    );
  }
}
