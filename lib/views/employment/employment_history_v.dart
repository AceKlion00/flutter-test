import 'package:extra_staff/controllers/employment/employment_history_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/employment/company_details_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EmploymentHistory extends StatefulWidget {
  const EmploymentHistory({Key? key}) : super(key: key);

  @override
  _EmploymentHistoryState createState() => _EmploymentHistoryState();
}

class _EmploymentHistoryState extends State<EmploymentHistory> {
  final controller = EmploymentHistoryController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserTempData();
  }

  Future getUserTempData() async {
    try {
      setState(() => isLoading = true);
      await controller.getTempEmployeeInfo();
      setState(() => isLoading = false);
    } catch (error) {
      print(error.toString());
    }
  }

  Widget companyButton(String title, int position) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompanyDetails()),
        ).then((value) async {
          Future.delayed(duration, () async {
            await getUserTempData();
          });
        });
        Get.to(() => CompanyDetails(),
            arguments: controller.companies[position]);
      },
      child: Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: abOutline(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: MyFonts.regular(17, color: MyColors.grey)),
            Icon(Icons.edit, color: MyColors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('employment'.tr),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: gHPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    Icon(
                      Icons.history,
                      size: 125,
                      color: MyColors.lightBlue,
                    ),
                    SizedBox(height: 32),
                    abWords('yourEmploymentHistory'.tr, 'history',
                        WrapAlignment.start),
                    SizedBox(height: 32),
                    abTitle('company'.tr),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.companies.length,
                      itemBuilder: (context, position) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: companyButton(
                              controller.companies[position].company, position),
                        );
                      },
                    ),
                    abSimpleButton('addCompany'.tr.toUpperCase(),
                        onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyDetails()),
                      ).then((value) async {
                        Future.delayed(duration, () async {
                          await getUserTempData();
                        });
                      });
                      Get.to(() => CompanyDetails());
                    }),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            if (controller.companies.isNotEmpty)
              abBottom(onTap: (i) async {
                if (i == 0) {
                  if (controller.companies.isEmpty) {
                    abShowMessage('addCompanyMessage'.tr);
                  } else {
                    await Resume.shared.setDone();
                    Get.back(result: true);
                  }
                }
              }),
          ],
        ),
      ),
    );
  }
}
