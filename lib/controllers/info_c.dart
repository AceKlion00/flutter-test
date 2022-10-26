import 'package:extra_staff/models/info_m.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class InfoController extends GetxController {
  InfoController(int index) {
    current = allData[index];
  }

  InfoModel current = InfoModel('', '', '');

  final List<InfoModel> allData = [
    InfoModel(
      '1',
      'Welcome to Extrastaff',
      "Hi, welcome to Extrastaff, in order to work with us you need to complete a simple registration. It's a straight forward process that we need to carry out to make sure we can put you in the best possible jobs. It takes on average 20 minutes. Any questions, please call your local Extrastaff representative.",
    ),
    InfoModel(
      '2',
      'Registration',
      "We have 1000's of vacancies at any time. We focus on driving and industrial jobs. We have jobs available 24 hours a day, 7 days a week throughout the country. We pay weekly. The more you work the more you earn. Simple!",
    ),
    InfoModel(
      '3',
      'Not bad!',
      "We think you would be great as part of our team. Let's get some details.",
    ),
    InfoModel(
      '4',
      'Let us locate you',
      "Let Extrastaff locate you to help us post relevant jobs to you.",
    ),
    InfoModel(
      '5',
      'Superb',
      "You are one step closer to working with us. A few more sections to go and we are all done.",
    ),
    InfoModel(
      '6',
      'Show me the money',
      "We need your bank details so we can pay you. When you work with us, you will be paid weekly.",
    ),
    InfoModel(
      '7',
      'Keep up the good work',
      "We like to know who you are. If you want to know more about us, check out www.extrastaff.com.",
    ),
    InfoModel(
      '8',
      'Health & Safety',
      "Health & Safety is in all lives, and we want to ensure you recognise some signs you will see dotted around where you will work. This is no race. Please take your time.",
    ),
    InfoModel(
      '9',
      'Congratulations',
      "We have everything we need to continue your registration. We will need to arrange a quick interview with you, to ask a couple of questions. Don't worry it's not scary. We are one happy family here at Extrastaff. We will be in contact shortly to get this arranged.",
    ),
  ];
}
