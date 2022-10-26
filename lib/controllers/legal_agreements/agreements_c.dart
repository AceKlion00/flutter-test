import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:image_picker/image_picker.dart';

class AgreementsController extends GetxController {
  String txt = '';
  int currentIndex = 1;
  List<String> status = [];

  final allAgreements = [
    KeyValue('1', 'Extrastaff Pension'),
    KeyValue('2', 'Now Pension'),
    KeyValue('3', 'GDPR / Privacy Statement'),
    KeyValue('4', 'Code of Conduct'),
    KeyValue('5', 'Manual Handling'),
  ];

  nextAgreement() async {
    if (currentIndex < allAgreements.length) {
      currentIndex += 1;
    }
  }

  bool allAccepted() {
    status = [
      ...{...status}
    ];
    return status.length == allAgreements.length;
  }

  Future<String> updateTempAgreementInfo() async {
    final response =
        await Services.shared.updateTempAgreementInfo('$currentIndex');
    return response.errorMessage;
  }

  Future<String> getTempAgreementInfo() async {
    final response = await Services.shared.getTempAgreementInfo();
    if (response.result is List) {
      status = [];
      for (var i in response.result) {
        if (i is Map) {
          if (i['document_type'] is String) {
            status.add(i['document_type']);
          }
        }
      }
    }
    return response.errorMessage;
  }

  Future<String> getAgreementInfo() async {
    final response = await Services.shared.getAgreementInfo('$currentIndex');
    if (response.result is Map) {
      if (response.result['document_type'] is String) {
        txt = response.result['document_type'];
      }
    }
    return response.errorMessage;
  }

  Future<String> putSignature(XFile img) async {
    try {
      return await Services.shared.putSignature(img);
    } catch (e) {
      print(e.toString());
      return 'error'.tr;
    }
  }
}
