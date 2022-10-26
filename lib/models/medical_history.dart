import 'package:extra_staff/utils/ab.dart';

class MedicalHistory {
  String medicalCondition;
  String diabetes;
  String heart;
  String stomach;
  String sleep;
  String chest;
  String blood;
  String fits;
  String skeletal;
  String other;
  String medicalDesc;
  String treatment;
  String treatmentData;
  String drug;
  String drugData;
  String illnessData;
  String doctorName;
  String doctorAddress;

  MedicalHistory({
    required this.medicalCondition,
    required this.diabetes,
    required this.heart,
    required this.stomach,
    required this.sleep,
    required this.chest,
    required this.blood,
    required this.fits,
    required this.skeletal,
    required this.other,
    required this.medicalDesc,
    required this.treatment,
    required this.treatmentData,
    required this.drug,
    required this.drugData,
    required this.illnessData,
    required this.doctorName,
    required this.doctorAddress,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      medicalCondition: ab(json['medical_con'], fallback: ''),
      diabetes: ab(json['diabetes'], fallback: ''),
      heart: ab(json['heart'], fallback: ''),
      stomach: ab(json['stomach'], fallback: ''),
      sleep: ab(json['sleep'], fallback: ''),
      chest: ab(json['chest'], fallback: ''),
      blood: ab(json['blood'], fallback: ''),
      fits: ab(json['fits'], fallback: ''),
      skeletal: ab(json['skeletal'], fallback: ''),
      other: ab(json['other'], fallback: ''),
      medicalDesc: ab(json['medical_desc'], fallback: ''),
      treatment: ab(json['treatment'], fallback: ''),
      treatmentData: ab(json['treatment_deta'], fallback: ''),
      drug: ab(json['drug'], fallback: ''),
      drugData: ab(json['drug_deta'], fallback: ''),
      illnessData: ab(json['illness_deta'], fallback: ''),
      doctorName: ab(json['doctor_name'], fallback: ''),
      doctorAddress: ab(json['doctor_address'], fallback: ''),
    );
  }
}
