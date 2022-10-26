import 'dart:async';
import 'package:extra_staff/views/confirm_code_v.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:extra_staff/views/registration_progress_v.dart';

T ab<T>(dynamic x, {required T fallback}) => x is T ? x : fallback;

class ABBottom extends GetxController {
  bool hideBottom = false;
}

final objABBottom = ABBottom();

Timer? timer;

fallBackTimer(bool stop) {
  timer?.cancel();
  if (stop) {
    timer = null;
    return;
  }
  timer = Timer(Duration(minutes: 3), () {
    timer = null;
    Get.offAll(() => EnterCode(isFromStart: true));
  });
}

PreferredSize abQuestions(
    BuildContext context, bool showHome, int current, int total) {
  final width = MediaQuery.of(context).size.width;
  final indent = ((width - 56) / total) * current;
  return PreferredSize(
    preferredSize: Size.fromHeight(80),
    child: SafeArea(
      child: Container(
        padding: gHPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  total == 0
                      ? Container()
                      : Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                (current <= 9 ? '0' : '') + '$current',
                                textAlign: TextAlign.center,
                                style: MyFonts.medium(28),
                              ),
                              Text(
                                '/ ${(total <= 9 ? '0' : '')}$total',
                                textAlign: TextAlign.center,
                                style: MyFonts.medium(18, color: MyColors.grey),
                              ),
                            ],
                          ),
                        ),
                  Container(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: MyColors.grey,
                      ),
                    ),
                  ),
                  showHome
                      ? Container(
                          height: 40,
                          alignment: AlignmentDirectional.centerEnd,
                          child: IconButton(
                            onPressed: () {
                              Get.to(() => RegistrationProgress());
                            },
                            icon: Icon(
                              Icons.home,
                              size: 30,
                              color: MyColors.lightBlue,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Spacer(),
            total == 0
                ? Container(height: 10)
                : SizedBox(
                    height: 10,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Divider(
                          height: 0,
                          thickness: 2,
                          color: MyColors.grey,
                        ),
                        AnimatedContainer(
                          color: MyColors.darkBlue,
                          height: 8,
                          width: indent,
                          duration: duration,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}

Widget abSimpleButton(String title,
    {required Function() onTap, Color? backgroundColor}) {
  final frontColor =
      backgroundColor != null ? MyColors.white : MyColors.darkBlue;
  final borderWidth = backgroundColor == null ? 2.0 : 0.0;
  return InkWell(
    onTap: () async => onTap(),
    child: AnimatedContainer(
      duration: duration,
      constraints: BoxConstraints(minHeight: buttonHeight),
      padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? MyColors.white,
        border: Border.all(
            color: backgroundColor ?? MyColors.darkBlue, width: borderWidth),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: MyFonts.regular(24, color: frontColor)),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, color: frontColor),
        ],
      ),
    ),
  );
}

Widget abDropDownButton(
    KeyValue selected, List<KeyValue> options, Function(KeyValue) onChange,
    {Color? bordercolor}) {
  return Container(
    height: buttonHeight,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: abOutline(borderColor: bordercolor),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        icon: RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.arrow_forward_ios, color: MyColors.darkBlue),
        ),
        value: selected,
        onChanged: (KeyValue? newValue) async => onChange(newValue!),
        items: options
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.value,
                    style: MyFonts.regular(17, color: MyColors.black),
                  ),
                ))
            .toList(),
      ),
    ),
  );
}

Widget abStatusButton(String title, bool? status, Function() onTap,
    {bool hideStatus = false, bool expanded = false, double? borderWidth}) {
  final color = status != null
      ? status
          ? MyColors.green
          : MyColors.ornage
      : MyColors.lightGrey;
  final icon = status != null
      ? status
          ? Icons.check_circle
          : Icons.cancel
      : Icons.add_circle;
  return InkWell(
    onTap: onTap,
    child: Container(
      height: expanded ? null : buttonHeight,
      padding:
          expanded ? EdgeInsets.all(16) : EdgeInsets.symmetric(horizontal: 16),
      decoration: abOutline(borderColor: color, width: borderWidth),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(title,
                style: MyFonts.regular(17, color: MyColors.black),
                textAlign: expanded ? TextAlign.center : null),
          ),
          if (!hideStatus)
            Positioned(
              top: 43,
              right: -27,
              child: Icon(icon, color: color),
            ),
        ],
      ),
    ),
  );
}

Widget abDownButton(String title) {
  return Container(
    height: buttonHeight,
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: abOutline(),
    child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: MyFonts.regular(17, color: MyColors.black)),
          RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.arrow_forward_ios, color: MyColors.darkBlue),
          ),
        ],
      ),
    ),
  );
}

BoxDecoration abOutline({Color? borderColor, Color? color, double? width}) {
  double borderWidth = borderColor == MyColors.transparent ? 0 : width ?? 1;
  return BoxDecoration(
    color: color ?? MyColors.white,
    border: Border.all(
        color: borderColor ?? MyColors.lightGrey, width: borderWidth),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(color: MyColors.lightGrey, spreadRadius: 0, blurRadius: 2),
    ],
  );
}

Widget abPasswordField(String title, Function(String) onChanged,
    {TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    int? clearAndEdit,
    Function(int)? onTap,
    String? Function(String?)? validator,
    Function(String)? onFieldSubmitted}) {
  return Container(
    decoration: abOutline(borderColor: MyColors.transparent),
    child: TextFormField(
      validator: validator,
      initialValue: title,
      style: MyFonts.regular(16),
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      textCapitalization: TextCapitalization.sentences,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (e) => onChanged(e),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (e) =>
          onFieldSubmitted == null ? null : onFieldSubmitted(e),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.all(16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.skyBlue, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.lightGrey, width: 1),
        ),
        suffixIcon: clearAndEdit == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (clearAndEdit == 1)
                    IconButton(
                      onPressed: () => onTap == null ? null : onTap(1),
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.clear),
                    ),
                  if (clearAndEdit == 2)
                    IconButton(
                      onPressed: () => onTap == null ? null : onTap(2),
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.edit),
                    ),
                ],
              ),
      ),
    ),
  );
}

Widget abTextField(String title, Function(String) onChanged,
    {TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    int? clearAndEdit,
    String? hintText,
    Function(int)? onTap,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Function(String)? onFieldSubmitted}) {
  return Container(
    decoration: abOutline(borderColor: MyColors.transparent),
    child: TextFormField(
      inputFormatters: inputFormatters,
      validator: validator,
      initialValue: title,
      style: MyFonts.regular(16),
      textCapitalization: TextCapitalization.sentences,
      maxLength: maxLength ?? (maxLines == 1 ? 45 : 256),
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (e) => onChanged(e),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (e) =>
          onFieldSubmitted == null ? null : onFieldSubmitted(e),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        contentPadding: EdgeInsets.all(16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.skyBlue, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.lightGrey, width: 1),
        ),
        suffixIcon: clearAndEdit == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (clearAndEdit == 1)
                    IconButton(
                      onPressed: () => onTap == null ? null : onTap(1),
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.clear),
                    ),
                  if (clearAndEdit == 2)
                    IconButton(
                      onPressed: () => onTap == null ? null : onTap(2),
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.edit),
                    ),
                ],
              ),
      ),
    ),
  );
}

Widget abBottomBar(BuildContext context, int current, int total) {
  final width = MediaQuery.of(context).size.width;
  final indent = ((width - (gHPadding.left * 2)) / total) * current;
  return Stack(
    alignment: Alignment.bottomLeft,
    children: [
      Divider(height: 0, thickness: 3, color: MyColors.grey),
      AnimatedContainer(
        height: 8,
        width: indent,
        duration: duration,
        color: MyColors.darkBlue,
      ),
    ],
  );
}

Widget abCounts(int current, int total) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      Text(
        (current <= 9 ? '0' : '') + '$current',
        style: MyFonts.semiBold(28, color: MyColors.black),
      ),
      Text(
        '/ ${(total <= 9 ? '0' : '')}$total',
        style: MyFonts.semiBold(18, color: MyColors.grey),
      ),
    ],
  );
}

PreferredSize abHeader(
  String title, {
  Function(int)? onTap,
  Widget? center,
  Widget? bottom,
  bool showHome = true,
  bool showBack = true,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(80),
    child: SafeArea(
      child: Container(
        height: double.infinity,
        padding: gHPadding,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: showBack,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainSemantics: true,
                    child: IconButton(
                      onPressed: () => onTap == null ? Get.back() : onTap(1),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: MyColors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: center ??
                        Text(
                          title,
                          style: MyFonts.medium(25),
                          textAlign: TextAlign.center,
                        ),
                  ),
                  Visibility(
                    visible: showHome,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainSemantics: true,
                    child: IconButton(
                      onPressed: () => onTap == null
                          ? Get.to(() => RegistrationProgress())
                          : onTap(2),
                      icon: Icon(
                        Icons.home,
                        size: 30,
                        color: MyColors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom ?? Divider(height: 3, color: MyColors.grey),
          ],
        ),
      ),
    ),
  );
}

Widget abRadioButtons(bool? groupValue, Function(bool?) onChanged,
    {bool showIcon = false}) {
  return Row(
    children: [
      Row(
        children: [
          Radio(
            value: true,
            groupValue: groupValue,
            fillColor: MaterialStateProperty.all(MyColors.darkBlue),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (bool? value) => onChanged(value),
          ),
          Text('yes'.tr, style: MyFonts.semiBold(16, color: MyColors.darkBlue)),
          SizedBox(width: 16),
          Radio(
            value: false,
            groupValue: groupValue,
            fillColor: MaterialStateProperty.all(MyColors.darkBlue),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (bool? value) => onChanged(value),
          ),
          Text('no'.tr, style: MyFonts.semiBold(16, color: MyColors.darkBlue)),
        ],
      ),
      Spacer(),
      if (showIcon && groupValue != null)
        Icon(Icons.check_circle, color: MyColors.green),
    ],
  );
}

Widget abWords(String text, String highlight, WrapAlignment? alignment,
    {Color? textColor, double? size}) {
  final allWords = text.split(' ');
  final words = highlight.split(' ');
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        alignment: alignment ?? WrapAlignment.start,
        children: [
          for (var word in allWords)
            Text(
              word + ' ',
              style: words.contains(word)
                  ? MyFonts.bold(size ?? 28,
                      color: textColor ?? MyColors.darkBlue)
                  : MyFonts.regular(size ?? 28,
                      color: textColor ?? MyColors.black),
            ),
        ],
      ),
    ],
  );
}

Widget abAnimatedButton(String title, IconData? rightImage,
    {bool disabled = false, Function()? onTap}) {
  final color = MyColors.white.withAlpha(disabled ? 127 : 255);
  return InkWell(
    onTap: onTap,
    child: Container(
      height: buttonHeight,
      width: double.infinity,
      padding: EdgeInsets.only(left: 4),
      color: MyColors.white,
      child: Container(
        color: MyColors.lightBlue,
        padding: gHPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: MyFonts.regular(24, color: color)),
            Icon(rightImage, color: color, size: 30),
          ],
        ),
      ),
    ),
  );
}

Widget abBottom({
  String? top = '',
  String? bottom = '',
  bool? onlyTopDisabled,
  List<String>? multiple,
  Function(int)? onTap,
}) {
  final isSingleButton = top == null || bottom == null;
  final bottomArrow = (bottom ?? '').isEmpty || bottom == 'back'.tr
      ? Icons.arrow_back_ios_new
      : Icons.arrow_forward_ios;
  final title1 = (top ?? '').isEmpty ? 'proceed'.tr : top!;
  final title2 = (bottom ?? '').isEmpty ? 'back'.tr : bottom!;
  final bottomDisabled = !(onlyTopDisabled ?? true);
  final length = multiple != null
      ? multiple.length + 1
      : isSingleButton
          ? 1
          : 2;
  return GetBuilder(
    init: objABBottom,
    builder: (b) {
      if (objABBottom.hideBottom) {
        return Container();
      }
      return Container(
        height: (length * buttonHeight) + ((length + 1) * 16),
        padding: gHPadding,
        color: MyColors.darkBlue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (multiple != null)
              for (var i in multiple)
                Column(
                  children: [
                    abAnimatedButton(i, null, onTap: () async {
                      onTap!(multiple.indexOf(i) + 2);
                    }),
                    SizedBox(height: 16),
                  ],
                ),
            if (top != null)
              abAnimatedButton(
                title1,
                Icons.arrow_forward_ios,
                disabled: onlyTopDisabled ?? false,
                onTap: () async {
                  onTap!(0);
                },
              ),
            if (!isSingleButton) SizedBox(height: 16),
            if (bottom != null)
              abAnimatedButton(
                title2,
                bottomArrow,
                disabled: bottomDisabled,
                onTap: () async {
                  bottomDisabled
                      ? null
                      : bottom.isEmpty
                          ? Get.back()
                          : onTap!(1);
                },
              ),
          ],
        ),
      );
    },
  );
}

Future abShowAlert(
    BuildContext context, String message, String buttonTitle) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('es'.tr, style: MyFonts.regular(24)),
        content: Text(message, style: MyFonts.regular(17)),
        actions: [
          TextButton(
            child: Text(buttonTitle,
                style: MyFonts.bold(16, color: MyColors.lightBlue)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

Widget abTitle(String title, {Color? color}) =>
    Text(title, style: MyFonts.regular(18, color: color ?? MyColors.black));

Future abShowMessage(String message) async {
  return Get.snackbar(
    'es'.tr,
    message,
    titleText: Text('es'.tr, style: MyFonts.bold(16, color: MyColors.white)),
    messageText:
        Text(message, style: MyFonts.regular(14, color: MyColors.white)),
    borderRadius: 0,
    shouldIconPulse: true,
    onTap: (e) => Get.back(),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.black.withOpacity(0.5),
    leftBarIndicatorColor: MyColors.yellow,
    icon: Icon(Icons.warning_amber_rounded, color: MyColors.yellow),
  );
}

SharedPreferences? localStorage;
Future localStorageInit() async {
  localStorage = await SharedPreferences.getInstance();
}

removeAllSharedPref() async => await localStorage?.clear();
