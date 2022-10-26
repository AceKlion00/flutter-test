import 'package:extra_staff/utils/ab.dart';

class UserData {
  String id;
  String userId;
  String employeeIdEfos;
  String firstName;
  String lastName;
  String email;
  String tempId;
  String salutation;
  String status;
  String contract;
  String houseNumber;
  String address_1;
  String address_2;
  String addressTown;
  String addressCounty;
  String addressPostCode;
  String mobile;
  String dob;
  String branchId;
  String deskId;
  String hearAboutUS;
  String ownTrasport;
  String hiVis;
  String requireSafetyBoot;
  String safetyBootSize;
  String nationalInsurance;
  String sunday;
  String monday;
  String tuesday;
  String wednesday;
  String thursday;
  String friday;
  String saturday;
  String nightWork;
  String emergencyContact;
  String emergencyContactNumber;
  String emergencyContactRelationship;
  String bankName;
  String bankSortcode;
  String bankAccount;
  String bankHolderName;
  String bankReference;
  String nationalIdentity;
  String ethnic;
  String tempGender;
  String religion;
  String sexOri;
  String tempDob;
  String married;
  String tempDisability;
  String tempDisabilityDesc;
  String euNational;
  String criminal;
  String criminalDesc;
  String hourOutput;
  String dbsCheck;
  String dbsDate;
  String nationalInsuranceYes;
  String quizTest;

  UserData({
    required this.id,
    required this.userId,
    required this.employeeIdEfos,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.tempId,
    required this.salutation,
    required this.status,
    required this.contract,
    required this.houseNumber,
    required this.address_1,
    required this.address_2,
    required this.addressTown,
    required this.addressCounty,
    required this.addressPostCode,
    required this.mobile,
    required this.dob,
    required this.branchId,
    required this.deskId,
    required this.hearAboutUS,
    required this.ownTrasport,
    required this.hiVis,
    required this.requireSafetyBoot,
    required this.safetyBootSize,
    required this.nationalInsurance,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.nightWork,
    required this.emergencyContact,
    required this.emergencyContactNumber,
    required this.emergencyContactRelationship,
    required this.bankName,
    required this.bankSortcode,
    required this.bankAccount,
    required this.bankHolderName,
    required this.bankReference,
    required this.nationalIdentity,
    required this.ethnic,
    required this.tempGender,
    required this.religion,
    required this.sexOri,
    required this.tempDob,
    required this.married,
    required this.tempDisability,
    required this.tempDisabilityDesc,
    required this.euNational,
    required this.criminal,
    required this.criminalDesc,
    required this.hourOutput,
    required this.dbsCheck,
    required this.dbsDate,
    required this.nationalInsuranceYes,
    required this.quizTest,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: ab(json['id'], fallback: ''),
      userId: ab(json['user_id'], fallback: ''),
      employeeIdEfos: ab(json['employee_id_efos'], fallback: ''),
      firstName: ab(json['first_name'], fallback: ''),
      lastName: ab(json['last_name'], fallback: ''),
      email: ab(json['email'], fallback: ''),
      tempId: ab(json['temp_id'], fallback: ''),
      salutation: ab(json['salutation'], fallback: ''),
      status: ab(json['status'], fallback: ''),
      contract: ab(json['contract'], fallback: ''),
      houseNumber: ab(json['house_number'], fallback: ''),
      address_1: ab(json['address_1'], fallback: ''),
      address_2: ab(json['address_2'], fallback: ''),
      addressTown: ab(json['address_town'], fallback: ''),
      addressCounty: ab(json['address_county'], fallback: ''),
      addressPostCode: ab(json['address_post_code'], fallback: ''),
      mobile: ab(json['mobile'], fallback: ''),
      dob: ab(json['dob'], fallback: ''),
      branchId: ab(json['branch_id'], fallback: ''),
      deskId: ab(json['desk_id'], fallback: ''),
      hearAboutUS: ab(json['hear_es'], fallback: ''),
      ownTrasport: ab(json['own_transport'], fallback: ''),
      hiVis: ab(json['hi_vis'], fallback: ''),
      requireSafetyBoot: ab(json['safety_boot'], fallback: ''),
      safetyBootSize: ab(json['safety_boot_size'], fallback: ''),
      nationalInsurance: ab(json['national_insurance'], fallback: ''),
      sunday: ab(json['sunday'], fallback: ''),
      monday: ab(json['monday'], fallback: ''),
      tuesday: ab(json['tuesday'], fallback: ''),
      wednesday: ab(json['wednesday'], fallback: ''),
      thursday: ab(json['thursday'], fallback: ''),
      friday: ab(json['friday'], fallback: ''),
      saturday: ab(json['saturday'], fallback: ''),
      nightWork: ab(json['night_work'], fallback: ''),
      emergencyContact: ab(json['next_of_kin'], fallback: ''),
      emergencyContactNumber: ab(json['next_of_kin_number'], fallback: ''),
      emergencyContactRelationship:
          ab(json['next_of_kin_relationship'], fallback: ''),
      bankName: ab(json['bank_name'], fallback: ''),
      bankSortcode: ab(json['bank_sortcode'], fallback: ''),
      bankAccount: ab(json['bank_account'], fallback: ''),
      bankHolderName: ab(json['bank_holdername'], fallback: ''),
      bankReference: ab(json['bank_reference'], fallback: ''),
      nationalIdentity: ab(json['national_identity'], fallback: ''),
      ethnic: ab(json['ethnic'], fallback: ''),
      tempGender: ab(json['temp_gender'], fallback: ''),
      religion: ab(json['religion'], fallback: ''),
      sexOri: ab(json['sex_ori'], fallback: ''),
      tempDob: ab(json['temp_dob'], fallback: ''),
      married: ab(json['married'], fallback: ''),
      tempDisability: ab(json['temp_disability'], fallback: ''),
      tempDisabilityDesc: ab(json['temp_disability_desc'], fallback: ''),
      euNational: ab(json['eu_national'], fallback: ''),
      criminal: ab(json['criminal'], fallback: ''),
      criminalDesc: ab(json['criminal_desc'], fallback: ''),
      hourOutput: ab(json['hour_output'], fallback: ''),
      dbsCheck: ab(json['dbs_check'], fallback: ''),
      dbsDate: ab(json['dbs_date'], fallback: ''),
      nationalInsuranceYes: ab(json['national_insurance_yes'], fallback: ''),
      quizTest: ab(json['quiz_test'], fallback: ''),
    );
  }
}
