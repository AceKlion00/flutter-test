import 'package:extra_staff/utils/ab.dart';

class Company {
  String id;
  String contactPersonName;
  String company;
  String contactPersonEmail;
  String contactNumber;
  String leavingReason;
  String suggestedStartDate;
  String suggestedEndDate;
  String jobTitle;

  Company({
    required this.id,
    required this.contactPersonName,
    required this.company,
    required this.contactPersonEmail,
    required this.contactNumber,
    required this.leavingReason,
    required this.suggestedEndDate,
    required this.suggestedStartDate,
    required this.jobTitle,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: ab(json['id'], fallback: ''),
      contactPersonName: ab(json['fao_name'], fallback: ''),
      company: ab(json['fao_company'], fallback: ''),
      contactPersonEmail: ab(json['fao_email'], fallback: ''),
      contactNumber: ab(json['contact_number'], fallback: ''),
      leavingReason: ab(json['leaving_reason'], fallback: ''),
      suggestedStartDate: ab(json['suggested_start_date'], fallback: ''),
      suggestedEndDate: ab(json['suggested_end_date'], fallback: ''),
      jobTitle: ab(json['job_title'], fallback: ''),
    );
  }
}
