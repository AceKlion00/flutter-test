import 'package:extra_staff/controllers/list_to_upload_c.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/analysing_docs.v.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:video_player/video_player.dart';

class UploadDocumentsView extends StatefulWidget {
  final ListToUploadController controller;
  const UploadDocumentsView({required this.controller});

  @override
  _UploadDocumentsViewState createState() =>
      _UploadDocumentsViewState(controller: controller);
}

class _UploadDocumentsViewState extends State<UploadDocumentsView> {
  _UploadDocumentsViewState({required this.controller});

  ListToUploadController controller;
  final scrollController = ScrollController();
  bool isLoading = false;
  var isCompleted = [false, false];
  final ImagePicker picker = ImagePicker();
  VideoPlayerController? _controller;
  bool isVisiable = false;
  bool isPdfOrDocSelected = false;

  @override
  void initState() {
    super.initState();

    controller.isCV = Get.arguments?['isCV'] ?? false;
    controller.isForklift = Get.arguments?['isForklift'] ?? false;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller = VideoPlayerController.asset(controller.videoToPlay);
    _controller!.initialize().then((_) {
      initialize();
    });
  }

  initialize() async {
    Future.delayed(duration, () {
      setState(() {
        _controller!.play();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  Widget words(int index) {
    final isDriving = controller.type.value == 'drivinglicence'.tr;
    if (index == 0) {
      if (isDriving) {
        return abWords('frontDriving'.tr, 'frontDrivingH'.tr, null);
      } else {
        return abWords('frontVisaBrp'.tr, 'frontVisaBrpH'.tr, null);
      }
    } else {
      if (isDriving) {
        return abWords('backDriving'.tr, 'backDrivingH'.tr, null);
      } else {
        return abWords('backVisaBrp'.tr, 'backVisaBrpH'.tr, null);
      }
    }
  }

  Widget content(int index) {
    final upload = controller.isCV
        ? 'CV'
        : controller.isForklift
            ? 'Forklift licence'
            : controller.type.value;
    final isUploaded = isCompleted[index];
    final backColor = isPdfOrDocSelected
        ? null
        : isUploaded
            ? MyColors.green
            : null;
    final first = isUploaded ? 'retakePhoto'.tr : 'useCamera'.tr;
    final second = isUploaded ? 'uploadNewPhoto'.tr : 'gallery'.tr;
    return Column(
      children: [
        controller.isSingleImage()
            ? abWords('upload'.tr + ' ' + upload, upload, null)
            : words(index),
        SizedBox(height: 32),
        if (controller.isSingleImage()) SizedBox(height: 32),
        abSimpleButton(
          first.toUpperCase(),
          onTap: () async => getImageFrom(ImageSource.camera, index),
          backgroundColor: backColor,
        ),
        SizedBox(height: 16),
        abSimpleButton(
          second.toUpperCase(),
          onTap: () async => getImageFrom(ImageSource.gallery, index),
          backgroundColor: backColor,
        ),
        SizedBox(height: 32),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: abHeader('Upload'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: gHPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    controller.isCV || controller.isForklift
                        ? Icon(
                            Icons.upload_file_sharp,
                            color: MyColors.darkBlue,
                            size: 125,
                          )
                        : AspectRatio(
                            aspectRatio: 192 / 108,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    setState(() => isVisiable = true);
                                    Future.delayed(Duration(seconds: 3), () {
                                      setState(() => isVisiable = false);
                                    });
                                  },
                                  child: VideoPlayer(_controller!),
                                ),
                                Visibility(
                                  visible: isVisiable,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: MyColors.black.withAlpha(50),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _controller!.value.isPlaying
                                              ? _controller!.pause()
                                              : _controller!.play();
                                        });
                                      },
                                      icon: Icon(
                                        _controller!.value.isPlaying
                                            ? Icons.pause_circle
                                            : Icons.play_circle,
                                        color: MyColors.darkBlue,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                    SizedBox(height: 32),
                    content(0),
                    if (!controller.isSingleImage())
                      Divider(thickness: 2, color: MyColors.offWhite),
                    if (!controller.isSingleImage()) SizedBox(height: 32),
                    if (!controller.isSingleImage()) content(1),
                    if (controller.isCV) ...[
                      openFilesForCV(),
                      SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            ),
            abBottom(
              top: controller.isCV || controller.isForklift ? 'skip'.tr : null,
              onTap: (e) {
                if (e == 0) {
                  Get.back(result: true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget openFilesForCV() {
    return abSimpleButton(
      'Add PDF or DOC',
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'docx'],
        );
        setState(() => isPdfOrDocSelected = result != null);
        if (result != null) {
          controller.image = XFile(result.files.single.path!);
          await getImageFrom(ImageSource.camera, 0, isDoc: true);
        } else {
          print('User canceled the picker');
        }
      },
      backgroundColor: isPdfOrDocSelected ? MyColors.green : null,
    );
  }

  getImageFrom(ImageSource source, int index, {bool? isDoc}) async {
    try {
      if (isDoc != true) {
        controller.image = await picker.pickImage(source: source);
      }
      if (controller.image == null) {
        return;
      }

      isCompleted[index] = true;
      controller.isBack = index != 0;
      setState(() => isLoading = true);
      final message = await controller.uploadImages();
      setState(() => isLoading = false);
      if (!controller.isSingleImage() && isCompleted[index] == true) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: duration, curve: Curves.ease);
      }
      if (controller.isSingleImage() && isCompleted.first ||
          (!controller.isSingleImage() &&
              isCompleted.first &&
              isCompleted.last)) {
        await Resume.shared.setDone();
        if (controller.showAnalyzer) {
          await Get.to(() => AnalysingDocs(seconds: Duration(seconds: 6)));
          Future.delayed(duration * 2, () {
            Get.back(result: message == '');
          });
        } else {
          Get.back(result: message == '');
        }
      }
    } catch (error) {
      print(error.toString());
      setState(() => isLoading = false);
    }
  }
}
