import 'package:extra_staff/models/key_value_m.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/models/hmrc_checklist.dart';

class HMRCCheckListController extends GetxController {
  HMRCChecklist data = HMRCChecklist(
    KeyValue('statement', ''),
    KeyValue('q_9', ''),
    KeyValue('q_10', ''),
    KeyValue('q_11', ''),
    KeyValue('q_12', ''),
    KeyValue('q_13', ''),
    KeyValue('q_14', ''),
    KeyValue('q_15', ''),
  );

  int selectedIndex = 0;
  var question = {};
  List<KeyValue> answers = [
    KeyValue('statement', ''),
    KeyValue('q_9', ''),
    KeyValue('q_10', ''),
    KeyValue('q_11', ''),
    KeyValue('q_12', ''),
    KeyValue('q_13', ''),
    KeyValue('q_14', ''),
    KeyValue('q_15', ''),
  ];
  bool get isOption1 => selectedIndex == 0;
  bool get isOption4 => selectedIndex == 3;
  bool get isOption5 => selectedIndex == 4;

  List<String> get bottomOptions {
    return isOption4
        ? ['plan1'.tr, 'plan2'.tr, 'both'.tr]
        : ['yes'.tr, 'no'.tr];
  }

  var option4Display = [
    {
      "You'll have a Plan 1 Student Loan if:": [
        'you lived in Scotland or Northern Ireland when you started your course (undergraduate or postgraduate)',
        'you lived in England or Wales and started your undergraduate course before 1 September 2012'
      ]
    },
    {
      "You'll have a Plan 2 Student Loan if:": [
        'you lived in England or Wales and started your undergraduate course on or after 1 September 2012',
        'your loan is a Part Time Maintenance Loan',
        'your loan is an Advanced Learner Loan',
        'your loan is a Postgraduate Healthcare Loan',
      ]
    },
  ];

  var option5Display = [
    {
      "": [
        "you lived in England and started your Postgraduate Master's course on or after 1 August 2016",
        "you lived in Wales and started your Postgraduate Master's course on or after 1 August 2017",
        'you lived in England or Wales and started your Postgraduate Doctoral course on or after 1 August 2018',
      ]
    },
  ];

  final startingData = [
    {
      'text':
          'Do you have one of the Student Loan Plans described below which is not fully repaid?'
              .tr,
      'highlight': 'Student Loan Plans',
    },
    {
      'text': 'Did you complete or leave your Studies before 6th April?'.tr,
      'highlight': 'Studies',
    },
    {
      'text':
          'Are you repaying your Student Loans directly to the Student Loans data by direct debit?'
              .tr,
      'highlight': 'Student Loans',
    },
    {
      'text': 'What type of Student Loan do you have?'.tr,
      'highlight': 'Student Loan',
    },
    {
      'text': "You'll have a Postgraduate Loan if:".tr,
      'highlight': 'Postgraduate Loan',
    },
    {
      'text':
          'Did you complete or leave your Postgraduate studies before 6th April?'
              .tr,
      'highlight': 'Student Loan',
    },
    {
      'text':
          'Are you repaying your Postgraduate Loan direct to the Student Loans data by direct debit?'
              .tr,
      'highlight': 'Student Loan',
    },
  ];

  final options = [
    "This is my first job since 6 April and I've not been receiving taxable Jobseeker's Allowance, Employment and Support Allowance, taxable Incapacity Benefit, State or Occupational Pension.",
    "This is now my only job but since 6 April I've had another job, or received taxable Jobseeker's Allowance, Employment and Support Allowance or taxable Incapacity Benefit. I do not receive a State or Occupational Pension.",
    "As well as my new job, I have another job or receive a State or Occupational Pension."
  ];

  nextQuestion() {
    if (selectedIndex < startingData.length) {
      selectedIndex += 1;
    }
  }

  jumpQuestion() {
    selectedIndex = 4;
  }

  Future<String> getTempHMRCInfo() async {
    final response = await Services.shared.getTempHMRCInfo();
    data = data.fromJson(response.result);
    answers[0].value = data.statement.value;
    answers[1].value = data.q_9.value;
    answers[2].value = data.q_10.value;
    answers[3].value = data.q_11.value;
    answers[4].value = data.q_12.value;
    answers[5].value = data.q_13.value;
    answers[6].value = data.q_14.value;
    answers[7].value = data.q_15.value;
    return response.errorMessage;
  }

  Future<String> updateTempHMRCInfo() async {
    data.statement.value = answers[0].value;
    data.q_9.value = answers[1].value;
    data.q_10.value = answers[2].value;
    data.q_11.value = answers[3].value;
    data.q_12.value = answers[4].value;
    data.q_13.value = answers[5].value;
    data.q_14.value = answers[6].value;
    data.q_15.value = answers[7].value;

    final response = await Services.shared.updateTempHMRCInfo(data);
    return response.errorMessage;
  }
}
