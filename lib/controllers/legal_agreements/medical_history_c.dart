import 'package:extra_staff/models/drop_donws_m.dart';
import 'package:extra_staff/models/medical_history.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';

class MedicalHistoryController extends GetxController {
  MedicalHistory data = MedicalHistory.fromJson({});
  bool? hasMedicalCondition;
  bool? treatment;
  bool? drug;
  Map<String, bool> values = {};

  DropDowns dropDowns = DropDowns.fromJson({});
  Future<String> getTempMedicalInfo() async {
    final response = await Services.shared.getTempMedicalInfo();
    if (response.errorCode == 0 && response.result is Map) {
      data = MedicalHistory.fromJson(response.result);
    }
    updateData(data);
    return response.errorMessage;
  }

  updateData(MedicalHistory data) {
    hasMedicalCondition =
        data.medicalCondition == '' ? null : data.medicalCondition == '1';
    values = {
      'diabetes'.tr: data.diabetes == '1',
      'hcDisorders'.tr: data.heart == '1',
      'siDisorders'.tr: data.stomach == '1',
      'mcDisorders'.tr: data.sleep == '1',
      'ccDisorders'.tr: data.chest == '1',
      'hbp'.tr: data.blood == '1',
      'fb'.tr: data.fits == '1',
      'msp'.tr: data.skeletal == '1',
      'aomc'.tr: data.other == '1',
    };
    treatment = data.treatment == '' ? null : data.treatment == '1';
    drug = data.drug == '' ? null : data.drug == '1';
  }

  setValues(int position, String newValue) {
    switch (position) {
      case 0:
        data.diabetes = newValue;
        break;
      case 1:
        data.heart = newValue;
        break;
      case 2:
        data.stomach = newValue;
        break;
      case 3:
        data.sleep = newValue;
        break;
      case 4:
        data.chest = newValue;
        break;
      case 5:
        data.blood = newValue;
        break;
      case 6:
        data.fits = newValue;
        break;
      case 7:
        data.skeletal = newValue;
        break;
      case 8:
        data.other = newValue;
        break;
      default:
        print('Nope');
    }
  }

  Future<String> updateTempMedicalInfo() async {
    final response = await Services.shared.updateTempMedicalInfo(data);
    return response.errorMessage;
  }

  String validate1() {
    if (hasMedicalCondition == null) {
      return 'medicalPhysicalMental'.tr;
    }
    return '';
  }

  String validate2() {
    if (hasMedicalCondition == true) {
      if (!values.values.contains(true)) {
        return 'youSuffer?'.tr;
      } else if (data.medicalDesc.isEmpty) {
        return 'furtherDetails'.tr;
      }
    }
    return '';
  }

  String validate3() {
    if (hasMedicalCondition == true) {
      if (treatment == null) {
        return 'receivingMedicalTreatment?'.tr;
      } else if (treatment == true && data.treatmentData.isEmpty) {
        return 'furtherDetails'.tr;
      } else if (drug == null) {
        return 'takenAnyDrugsMedicines?'.tr;
      } else if (drug == true && data.drugData.isEmpty) {
        return 'furtherDetails'.tr;
      }
    }
    return '';
  }
}
