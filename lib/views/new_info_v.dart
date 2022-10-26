import 'package:extra_staff/models/info_m.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NewInfoView extends StatelessWidget {
  NewInfoView(this.index, this.onTap);

  final int index;
  final Function() onTap;
  final Uri url = Uri.parse('https://www.extrastaff.com/');

  final List<InfoModel> allData = [
    InfoModel(
      '1',
      'Welcome to Extrastaff',
      "We are the UK driving and industrial specialists, and we have 1000's of people working each day.These jobs are based throughout our countrywide network and we have various types of shiftsWe pay weekly every Friday",
    ),
    InfoModel(
      '2',
      'Registration',
      "Our registration is super quick and split into 5 parts.\nYou will be asked to upload your documents and go through the agreements before completing.\n\nIf you have any issues or are looking for work, please contact your local branch.",
    ),
    InfoModel(
      '3',
      "You're one step closer",
      "Let's get some more details.",
    ),
    InfoModel(
      '4',
      'Let us locate you',
      'Let Extrastaff locate you to help us post relevant jobs to you.',
    ),
    InfoModel(
      '5',
      'Superb',
      'Thank you for uploading your documents, we now need to complete a further 4 sections.',
    ),
    InfoModel(
      '6',
      'Your bank details',
      "We ask for this information so we can pay you every week into the correct account \n\n Please make sure you input a valid bank account that is your own",
    ),
    InfoModel(
      '7',
      'Brilliant',
      "We like to know about our temps. If you want to know more about us checkout www.extrastaff.com.",
    ),
    InfoModel(
      '8',
      'Health & Safety',
      "Health & Safety is important to us, and we want to ensure you recognise some signs you will see dotted around where you will work. \n\n Please complete the following questions",
    ),
    InfoModel(
      '9',
      'Congratulations',
      'We have everything we need to continue your registration. We now need to organise an interview with you \n\n We will be in contact shortly to get this arranged.',
    ),
    InfoModel(
      'comingSoon',
      'Coming Soon ...',
      'This is only the start of our app, stay tuned for new updates including ability to view your pay information/payslips, latest Extrastaff news, ability to check in and out of work and book your holidays all by the click of a button!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (index == 0 || index == 1)
            ? SafeArea(bottom: false, child: startInfoWindow())
            : normalInfoWindow());
  }

  Widget startInfoWindow() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: gHPadding.right),
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: onTap,
              child: Text(
                index == 0 ? 'skip'.tr : 'start'.tr,
                style: MyFonts.regular(24, color: MyColors.grey),
              ),
            ),
          ),
        ),
        if (index == 0)
          Padding(
            padding: EdgeInsets.all(50),
            child: Image(
              image: AssetImage('lib/images/logo2.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 44),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  allData[index].title,
                  textAlign: TextAlign.center,
                  style: MyFonts.regular(30, color: MyColors.darkBlue),
                ),
                Text(
                  allData[index].details,
                  textAlign: TextAlign.center,
                  style: MyFonts.regular(20, color: MyColors.grey),
                ),
                if (index == 1)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      textStyle: MyFonts.semiBold(17),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () async {
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text('www.extrastaff.com'),
                  ),
              ],
            ),
          ),
        ),
        Image(
          image: AssetImage('lib/images/${allData[index].image}.png'),
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }

  Widget normalInfoWindow() {
    return Column(
      children: [
        Image(
          image: AssetImage('lib/images/${allData[index].image}.png'),
          fit: BoxFit.fitWidth,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 44),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  allData[index].title,
                  textAlign: TextAlign.center,
                  style: MyFonts.regular(30, color: MyColors.darkBlue),
                ),
                Text(
                  allData[index].details,
                  textAlign: TextAlign.center,
                  style: MyFonts.regular(20, color: MyColors.grey),
                ),
                if (index == 4)
                  Image(
                    image: AssetImage('lib/images/${5.1}.png'),
                    fit: BoxFit.contain,
                    width: 150,
                    height: 150,
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(44, 0, 44, 22),
          child: ElevatedButton(
            onPressed: () {
              Get.back();
              onTap();
            },
            child: Text('NEXT', style: MyFonts.regular(20)),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(Get.size.width, 60),
              primary: MyColors.darkBlue,
              onPrimary: MyColors.white,
              shape: StadiumBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
