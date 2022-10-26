import 'package:extra_staff/models/key_value_m.dart';

class DropDowns {
  List<KeyValue> salutation;
  List<KeyValue> safetyBootSize;
  List<KeyValue> hearEs;
  List<KeyValue> nationalIdentity;
  List<KeyValue> ethnic;
  List<KeyValue> tempGender;
  List<KeyValue> religion;
  List<KeyValue> sexOri;
  List<KeyValue> euNational;

  DropDowns(
      this.salutation,
      this.safetyBootSize,
      this.hearEs,
      this.nationalIdentity,
      this.ethnic,
      this.tempGender,
      this.religion,
      this.sexOri,
      this.euNational);

  factory DropDowns.fromJson(Map<String, dynamic> json) {
    List<KeyValue> salutation = [];
    List<KeyValue> safetyBootSize = [];
    List<KeyValue> hearEs = [];
    List<KeyValue> nationalIdentity = [];
    List<KeyValue> ethnic = [];
    List<KeyValue> tempGender = [];
    List<KeyValue> religion = [];
    List<KeyValue> sexOri = [];
    List<KeyValue> euNational = [];

    if (json['eu_national'] is List) {
      euNational.add(KeyValue('', 'Please select'));
      for (var i in json['eu_national']) {
        euNational.add(KeyValue.fromJson(i));
      }
    }

    if (json['salutation'] is List) {
      salutation.add(KeyValue('', 'Please select option'));
      for (var i in json['salutation']) {
        salutation.add(KeyValue.fromJson(i));
      }
    }

    if (json['safety_boot_size'] is List) {
      safetyBootSize.add(KeyValue('', 'Please select option'));
      for (var i in json['safety_boot_size']) {
        safetyBootSize.add(KeyValue.fromJson(i));
      }
    }

    if (json['hear_es'] is List) {
      hearEs.add(KeyValue('', 'Please select option'));
      for (var i in json['hear_es']) {
        hearEs.add(KeyValue.fromJson(i));
      }
    }

    if (json['national_identity'] is List) {
      nationalIdentity.add(KeyValue('', 'Please select option'));
      for (var i in json['national_identity']) {
        nationalIdentity.add(KeyValue.fromJson(i));
      }
    }

    if (json['ethnic'] is List) {
      ethnic.add(KeyValue('', 'Please select option'));
      for (var i in json['ethnic']) {
        ethnic.add(KeyValue.fromJson(i));
      }
    }

    if (json['temp_gender'] is List) {
      tempGender.add(KeyValue('', 'Please select option'));
      for (var i in json['temp_gender']) {
        tempGender.add(KeyValue.fromJson(i));
      }
    }

    if (json['religion'] is List) {
      religion.add(KeyValue('', 'Please select option'));
      for (var i in json['religion']) {
        religion.add(KeyValue.fromJson(i));
      }
    }

    if (json['sex_ori'] is List) {
      for (var i in json['sex_ori']) {
        sexOri.add(KeyValue.fromJson(i));
      }
    }
    return DropDowns(salutation, safetyBootSize, hearEs, nationalIdentity,
        ethnic, tempGender, religion, sexOri, euNational);
  }
}
