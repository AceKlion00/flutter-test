import 'dart:io';
import 'package:extra_staff/controllers/save_photo_c.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SavePhoto extends StatefulWidget {
  const SavePhoto({Key? key}) : super(key: key);

  @override
  _SavePhotoState createState() => _SavePhotoState();
}

class _SavePhotoState extends State<SavePhoto> {
  final ImagePicker picker = ImagePicker();
  final controller = SavePhotoController();
  var isLoading = false;

  Widget showImage() {
    if (controller.image != null) {
      return Image.file(File(controller.image!.path), fit: BoxFit.contain);
    } else {
      return Column(
        children: [
          Image(
            image: AssetImage('lib/images/face.png'),
            height: 125,
            width: 125,
          ),
          SizedBox(height: 32),
          abWords('photoOfYourself'.tr, 'hPhotoOfYourself'.tr, null),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = controller.image == null
        ? 'gallery'.tr.toUpperCase()
        : 'usePhoto'.tr.toUpperCase();
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('Upload'.tr),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: gHPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 32),
                    showImage(),
                    SizedBox(height: 32),
                    ...[
                      if (controller.image == null)
                        simpleButton('takePhoto'.tr, 'camera.png', 1),
                      if (controller.image == null) SizedBox(height: 16),
                      simpleButton(title, 'upload.png', 2),
                      if (controller.image != null) SizedBox(height: 16),
                      if (controller.image != null)
                        simpleButton('retakePhoto'.tr, 'retake.png', 3),
                    ],
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            abBottom(
              top: 'save'.tr,
              bottom: null,
              onTap: (i) async {
                if (i == 0) {
                  await next();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  next() async {
    setState(() => isLoading = true);
    final message = await controller.profileUploadUrl();
    setState(() => isLoading = false);
    if (message.isNotEmpty) {
      abShowMessage(message);
    } else {
      await Resume.shared.setDone();
      Get.back(result: true);
    }
  }

  Widget simpleButton(String title, String image, int index) {
    final borderWidth = 2.0;
    final backColor = controller.image == null ? null : MyColors.green;
    final frontColor = backColor != null ? MyColors.white : MyColors.darkBlue;
    return InkWell(
      onTap: () async {
        if (index == 2) {
          if (controller.image == null) {
            final img = await picker.pickImage(source: ImageSource.gallery);
            if (img != null) {
              setState(() => controller.image = img);
            }
          } else {
            await next();
          }
        } else {
          final img = await picker.pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.front,
          );
          if (img != null) {
            setState(() => controller.image = img);
          }
        }
      },
      child: AnimatedContainer(
        duration: duration,
        constraints: BoxConstraints(minHeight: buttonHeight),
        padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        decoration: BoxDecoration(
          color: backColor ?? MyColors.white,
          border: Border.all(
              color: backColor ?? MyColors.darkBlue, width: borderWidth),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 8),
            Image(
              image: AssetImage('lib/images/$image'),
              width: 24,
              height: 24,
              color: frontColor,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(title.toUpperCase(),
                  style: MyFonts.regular(24, color: frontColor)),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: frontColor),
          ],
        ),
      ),
    );
  }
}
