import 'package:extra_staff/models/upload_documents_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/save_photo_v.dart';
import 'package:extra_staff/views/upload_documents_v.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'analysing_docs.v.dart';
import 'package:image_picker/image_picker.dart';
import 'package:extra_staff/controllers/list_to_upload_c.dart';

class ListToUploadView extends StatefulWidget {
  const ListToUploadView({Key? key}) : super(key: key);

  @override
  _ListToUploadViewState createState() => _ListToUploadViewState();
}

class _ListToUploadViewState extends State<ListToUploadView> {
  final controller = ListToUploadController();

  final ImagePicker picker = ImagePicker();

  var isLoading = false;

  @override
  void initState() {
    super.initState();
    fallBackTimer(false);
    setData();
  }

  setData() async {
    controller.data = controller.data.map((e) {
      e.selected = e.data.first;
      return e;
    }).toList();
    setState(() => isLoading = true);
    await controller.getUploadDocDropdownInfo();
    await controller.getTempPhotoInfo();
    await controller.getTempCompDocInfo();
    await controller.getTempDeskInfo();
    setState(() => isLoading = false);
  }

  Widget dropDonwButton(int index) {
    if (controller.data.isEmpty) {
      return Container();
    }
    final status = controller.data[index].status;
    final color = status != null
        ? status
            ? MyColors.green
            : MyColors.ornage
        : MyColors.lightGrey;
    final icon = status != null
        ? status
            ? Icons.check_circle
            : Icons.cancel
        : null;
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        abDropDownButton(
            controller.data[index].selected, controller.data[index].data,
            (value) async {
          if (index == 1 && value.id.isNotEmpty) {
            controller.notHaveNi = false;
          }
          setState(() {
            if (index == 0) {
              controller.passportExpDate = null;
            }
            controller.type = value;
            controller.selectedIndex = index;
            controller.data[index].selected = value;
          });
          if (value.id.isNotEmpty) {
            final data =
                await Get.to(() => UploadDocumentsView(controller: controller));
            setState(() => controller.data[index].status = data);
            if (controller.showAnalyzer && data == true) {
              await controller.getTempCompDocInfo();
              setState(() {});
            }
            await allDocsUploaded(false);
          } else {
            setState(() => controller.data[index].status = null);
          }
        }, bordercolor: color),
        Positioned(top: 43, right: -11, child: Icon(icon, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final value = controller.data.isEmpty
        ? true
        : controller.data[1].selected.id.isNotEmpty;
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('documents'.tr),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: gHPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 32),
                    abTitle('entitledProof'.tr),
                    SizedBox(height: 16),
                    dropDonwButton(0),
                    if (controller.showExpiryDate) ...[
                      SizedBox(height: 16),
                      abTitle(
                          '${controller.data[0].selected.value} Expiry date'),
                      SizedBox(height: 16),
                      abStatusButton(
                          controller.passportExpDate != null
                              ? formatDate(controller.passportExpDate!)
                              : '',
                          null, () async {
                        final now = getNow;
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.passportExpDate ?? now,
                          firstDate: controller.passportExpDate ?? now,
                          lastDate: DateTime(now.year + 10),
                        );
                        if (picked != null &&
                            picked != controller.passportExpDate) {
                          setState(() {
                            controller.passportExpDate = picked;
                          });
                          await controller.tempPassportExpiryInfo();
                        }
                      }, hideStatus: true),
                    ],
                    SizedBox(height: 16),
                    abTitle('insuranceProof'.tr),
                    SizedBox(height: 16),
                    dropDonwButton(1),
                    SizedBox(height: 16),
                    CheckboxListTile(
                      title: abTitle('notHaveNi'.tr),
                      contentPadding: EdgeInsets.zero,
                      value: controller.notHaveNi,
                      onChanged: value
                          ? null
                          : (newValue) async {
                              if (newValue != null) {
                                controller.notHaveNi = newValue;
                                setState(() {});
                              }
                            },
                    ),
                    SizedBox(height: 16),
                    if (controller.notHaveNi) ...[
                      abTitle('whyNotNI'.tr),
                      SizedBox(height: 16),
                      abTextField(controller.reasonForNotHaveNi, (e) {
                        controller.reasonForNotHaveNi = e;
                      }),
                      SizedBox(height: 16),
                    ],
                    abTitle('addressProof'.tr + ' (${'optional'.tr})'),
                    SizedBox(height: 16),
                    dropDonwButton(2),
                    SizedBox(height: 16),
                    abTitle('photoOfYou'.tr),
                    SizedBox(height: 16),
                    abStatusButton(
                        'profilePicture'.tr, controller.profilePicture,
                        () async {
                      final value = await Get.to(() => SavePhoto());
                      if (value == true) {
                        await controller.getTempPhotoInfo();
                        setState(() {});
                      }
                      await allDocsUploaded(false);
                    }),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            abBottom(onTap: (i) async {
              if (i == 0) {
                await allDocsUploaded(true);
              }
            }),
          ],
        ),
      ),
    );
  }

  Documents fetchDoc(String id) {
    return controller.data.firstWhere((element) => element.id == id);
  }

  showValidation(String str, bool showMessage) {
    if (showMessage) {
      abShowMessage(str);
    }
  }

  allDocsUploaded(bool showMessage) async {
    if (controller.notHaveNi && controller.reasonForNotHaveNi.isEmpty) {
      showValidation('whyNotNI'.tr, showMessage);
      return;
    }
    final d1 = fetchDoc('work_id');
    final d2 = fetchDoc('ni_proof');

    if (d1.status != true) {
      showValidation('uploadAllDocuments'.tr, showMessage);
      return;
    }

    if (controller.showExpiryDate) {
      if (controller.passportExpDate == null) {
        showValidation(
            '${controller.data[0].selected.value} Expiry date', showMessage);
        return;
      }
    }

    if (!controller.notHaveNi && d2.status != true) {
      showValidation('uploadAllDocuments'.tr, showMessage);
      return;
    }

    if (controller.profilePicture != true) {
      showValidation('uploadAllDocuments'.tr, showMessage);
      return;
    }

    await controller.updateTempComplianceDocExpiry();

    await localStorage?.setBool('isDocumentsUploaded', true);
    await Resume.shared.setDone();
    Get.to(() => AnalysingDocs());
  }
}
