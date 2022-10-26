import 'package:extra_staff/controllers/about_you/bank_details_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/about_you/equality_monitoring_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  _BankDetails createState() => _BankDetails();
}

class _BankDetails extends State<BankDetails> {
  final controller = BankDetailsController();
  Map<String, dynamic> allData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller.data = Get.arguments['aboutYou'];
    controller.dropDowns = Get.arguments['dropDowns'];
    allData = {'aboutYou': controller.data, 'dropDowns': controller.dropDowns};
  }

  Widget top() {
    return Container(
      padding: gHPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          abTitle('bankName'.tr),
          SizedBox(height: 8),
          abTextField(controller.data.bankName, (text) {
            controller.data.bankName = text;
          }, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }),
          SizedBox(height: 16),
          abTitle('sortCode'.tr),
          SizedBox(height: 8),
          abTextField(controller.data.bankSortcode, (text) {
            controller.data.bankSortcode = text;
          }, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            if (!RegExp(r'[0-9]{6}$').hasMatch(value)) {
              return 'bankSortCode'.tr;
            }
            return null;
          }, maxLength: 6, keyboardType: TextInputType.phone),
          SizedBox(height: 16),
          abTitle('bankAccountNumber'.tr),
          SizedBox(height: 8),
          abTextField(controller.data.bankAccount, (text) {
            controller.data.bankAccount = text;
          }, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            if (!RegExp(r'[0-9]{8}$').hasMatch(value)) {
              return 'validBankAccountNumber'.tr;
            }
            return null;
          }, keyboardType: TextInputType.number, maxLength: 8),
          SizedBox(height: 16),
          abTitle('bankHolderName'.tr),
          SizedBox(height: 8),
          abTextField(controller.data.bankHolderName, (text) {
            controller.data.bankHolderName = text;
          }, validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterText'.tr;
            }
            return null;
          }),
          SizedBox(height: 16),
          abTitle('bankReference'.tr),
          SizedBox(height: 8),
          abTextField(controller.data.bankReference, (text) {
            controller.data.bankReference = text;
          }, validator: (value) {
            return null;
          }, onFieldSubmitted: (e) => next()),
          SizedBox(height: 16),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('payingYou'.tr),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: top())),
              abBottom(onTap: (i) async {
                if (i == 0) {
                  next();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  next() async {
    if (!controller.formKey.currentState!.validate()) {
      abShowMessage('error'.tr);
      return;
    }
    setState(() {
      isLoading = true;
    });
    final message = await controller.updateTempInfo();
    setState(() {
      isLoading = false;
    });
    if (message.isEmpty) {
      await Resume.shared.setDone();
      Get.to(() => EqualityMonitoring(), arguments: allData);
    } else {
      abShowMessage(message);
    }
  }
}
