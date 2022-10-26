import 'package:flutter/material.dart';
import 'package:extra_staff/utils/constants.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: gHPadding,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: MyColors.white,
        border: Border.all(color: MyColors.ornage),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 8),
          IconButton(
            iconSize: 44,
            color: MyColors.ornage,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
          SizedBox(height: 24),
          Text(
            'This form is optional and will be treated in confidence.',
            textAlign: TextAlign.center,
            style: MyFonts.regular(18, color: MyColors.black),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
