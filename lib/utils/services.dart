import 'dart:developer';
import 'package:extra_staff/models/address_m.dart';
import 'package:extra_staff/models/company.dart';
import 'package:extra_staff/models/driving_test_m.dart';
import 'package:extra_staff/models/hmrc_checklist.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/models/medical_history.dart';
import 'package:extra_staff/models/user_data_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/resume_navigation.dart';
import 'package:extra_staff/views/welcome_v.dart';
import 'package:mime/mime.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final awsUploadURL = 'https://77cllr8ym7.execute-api.eu-west-2.amazonaws.com/';
final baseUrl = 'https://development.services.extrastaff.com/';
final staticDigestKey = '52b83c32cf03fe5a2888758d73a27ca6';

class AWSApiResponse {
  final int status;
  final String message;
  final dynamic data;

  AWSApiResponse(this.status, this.message, this.data);

  factory AWSApiResponse.fromJson(Map<String, dynamic> json) =>
      AWSApiResponse(json['status'], json['message'], json['data']);
}

Future<AWSApiResponse> awsApi(Response value) async {
  log('URL -> ${value.request?.url}');
  log('StatusCode -> ${value.statusCode}');
  log('Response -> ${value.body}');
  try {
    final response = AWSApiResponse.fromJson(value.body);
    if (response.status == 3) {
      await localStorage?.setString('passcode', '');
      Get.offAll(() => WelcomeView());
      return AWSApiResponse.fromJson({});
    }
    return response;
  } catch (e) {
    print(e);
    return AWSApiResponse(-1, 'error'.tr, null);
  }
}

class BaseApiResponse {
  final int errorCode;
  final String errorMessage;
  final dynamic result;

  BaseApiResponse(this.errorCode, this.errorMessage, this.result);

  factory BaseApiResponse.fromJson(dynamic json) => BaseApiResponse(
      ab(json['errorCode'], fallback: -1),
      ab(json['errorMessage'], fallback: ''),
      json['result']);
}

Future<BaseApiResponse> safeDecode(Response value) async {
  log('Response -> ${value.body}');
  log('===========================API===========================');
  try {
    final json = jsonDecode(value.body);
    final response = BaseApiResponse.fromJson(json);
    if (response.errorCode == 3) {
      await localStorage?.setString('passcode', '');
      Get.offAll(() => WelcomeView());
      return BaseApiResponse.fromJson('');
    }
    return response;
  } catch (e) {
    print(e);
    return BaseApiResponse(-1, 'error'.tr, null);
  }
}

class Services extends GetConnect {
  Services._privateConstructor();
  static final Services shared = Services._privateConstructor();

  Map<String, String> headers = {
    'X-LANG': 'english',
    'X-API-HEADER': '123abc456def789ghi',
    'X-CLIENT-ID': '1',
    'DEVICE': device
  };

  int tid = -1;
  int userId = -1;
  int tempTid = -1;
  int tempUserId = -1;
  String completed = 'No'; //'Yes' or 'No' Whole process completed or not
  List<KeyValue> screens = [
    KeyValue('updateTempComplianceDocExpiry', '1'),
    KeyValue('profileUploadUrl', '3'),
    KeyValue('updateTempInfo', '5'),
    KeyValue('updateTempEqualityInfo', '8'),
    KeyValue('TempCompDoc', '11'),
    KeyValue('updateTempEmployeeInfo', '11'),
    KeyValue('updateTempRolesInfo', '12'),
    KeyValue('updateTempSkillsInfo', '13'),
    KeyValue('updateTempLicenseAdditionalInfo', '14'),
    KeyValue('updateTempWorkInfo', '15'),
    KeyValue('updateTempDrivingTestInfo', '16'),
    KeyValue('updateTempCompetancyInfo', '17'),
    KeyValue('updateTempCompetancyInfoOne', '17'),
    KeyValue('updateTempHMRCInfo', '20'),
    KeyValue('updateTempAgreementInfo', '21'),
    KeyValue('putSignature', '23'),
    KeyValue('updateTempInterviewInfo', '24'),
    KeyValue('updateTempMedicalInfo', '27'),
  ];

  setData() async {
    tid = localStorage?.getInt('tid') ?? -1;
    userId = localStorage?.getInt('userId') ?? -1;
    tempTid = localStorage?.getInt('tempTid') ?? -1;
    tempUserId = localStorage?.getInt('tempUserId') ?? -1;
    completed = localStorage?.getString('completed') ?? 'No';
    print(
        'tid -> $tid, userId -> $userId, tempTid -> $tempTid, tempUserId -> $tempUserId, completed -> $completed');
  }

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      T Function(dynamic)? decoder}) {
    log('Get:===========================API===========================');
    log('Headers -> $headers');
    log('URL -> $url');
    log('Body -> $query');
    return super.get(url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder);
  }

  @override
  Future<Response<T>> post<T>(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      T Function(dynamic)? decoder,
      dynamic Function(double)? uploadProgress}) {
    body['completed'] = completed;
    body['progress'] = '${Resume.shared.progress}';
    final str = url?.split('/').last ?? '';
    final index = screens.indexWhere((element) => element.id.contains(str));
    if (index > 0) {
      body['screen_id'] = screens[index].value;
    }
    log('Post:===========================API===========================');
    log('Headers -> $headers');
    log('URL -> $url');
    log('Body -> $body');
    return super.post(url, body,
        contentType: contentType,
        headers: headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress);
  }

  String generateMd5(String input) =>
      md5.convert(utf8.encode(input)).toString();

  Future<BaseApiResponse> postLogin(
          String email, String password, int type) async =>
      await post(
        baseUrl + 'login',
        {
          'email': email,
          'password': password,
          'type': type,
          'digest': generateMd5(staticDigestKey + email),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<AWSApiResponse> profileUploadUrl(String fileName) async => await get(
        awsUploadURL + 'profileUploadUrl',
        query: {
          'userId': '$tid',
          'fileName': fileName,
        },
        headers: headers,
      ).then((value) => awsApi(value));

  // Get data for file uploading
  Future<BaseApiResponse> getUploadDocDropdownInfo() async => await get(
        baseUrl + 'getUploadDocDropdownInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempPhotoInfo() async => await get(
        baseUrl + 'getTempPhotoInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  // File Uploading
  Future<AWSApiResponse> getUploadUrl(String type, String fileName) async =>
      await get(
        awsUploadURL + 'uploadUrl',
        query: {
          'userId': '$tid',
          'type': type,
          'fileName': fileName,
          'completed': completed,
        },
        headers: headers,
      ).then((value) => awsApi(value));

  Future<String> putImage(String url, XFile image) async => await http
      .put(Uri.parse(url),
          headers: {
            ...headers,
            'Content-Type': lookupMimeType(image.path)?.split('/').last ?? ''
          },
          body: await image.readAsBytes())
      .then((value) => value.statusCode == 200 ? 'OK' : 'Error');

  Future<BaseApiResponse> tempCompDoc(
          String type, String docType, String docName, bool isBack,
          {String? drivingDExp,
          String? drivingDIssue,
          String? tachoDExp,
          String? tachoCt,
          String? digiDExp,
          String? digiCt}) async =>
      await post(
        baseUrl + 'TempCompDoc',
        {
          'user_id': '$userId',
          'type': type,
          'isBack': isBack ? '1' : '2',
          'doc_type': docType,
          'doc_name': docName,
          'tid': '$tid',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'driving_date_expiry': drivingDExp ?? '',
          'driving_issue_date': drivingDIssue ?? '',
          'tacho_date_expiry': tachoDExp ?? '',
          'tacho_country': tachoCt ?? '',
          'digicard_date_expiry': digiDExp ?? '',
          'digicard_country': digiCt ?? '',
        },
        headers: headers,
      ).then((value) => safeDecode(value));
  // File Uploading

  Future<AWSApiResponse> extractedData() async => await get(
        awsUploadURL + 'extractedData/$userId',
        headers: headers,
      ).then((value) => awsApi(value));

  Future<BaseApiResponse> getTempUserData() async => await get(
        baseUrl + 'getTempInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getBranchInfo(
          double latitude, double longitude) async =>
      await get(
        baseUrl + 'getBranchInfo',
        query: {
          'latitude': '$latitude',
          'longitude': '$longitude',
          'digest': generateMd5(staticDigestKey),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getEqualityOptionInfo() async => await get(
        baseUrl + 'getEqualityOptionInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempEqualityInfo() async => await get(
        baseUrl + 'getTempEqualityInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getDropdownInfo() async => await get(
        baseUrl + 'getDropdownInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempMedicalInfo() async => await get(
        baseUrl + 'getTempMedicalInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempEmployeeInfo() async => await get(
        baseUrl + 'getTempEmployeeInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getCompetancyInfo() async => await get(
        baseUrl + 'getCompetancyInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempCompetancyInfo() async => await get(
        baseUrl + 'getTempCompetancyInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempHMRCInfo() async => await get(
        baseUrl + 'getTempHMRCInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getQuickTempVerification(
          String code, String uniqueid) async =>
      await get(
        baseUrl + 'getQuickTempVerification',
        query: {
          'user_id': '$tempUserId',
          'digest': generateMd5(staticDigestKey + '$tempUserId'),
          'code': code,
          'uniqueid': uniqueid,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> resendQuickTempVerification(
          String code, String uniqueid) async =>
      await get(
        baseUrl + 'resendQuickTempVerification',
        query: {
          'user_id': '$tempUserId',
          'digest': generateMd5(staticDigestKey + '$tempUserId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> addQuickTemp(
    String email,
    String firstName,
    String lastName,
    String deskId,
    String branchId,
    String device,
    String mobile,
    String salutation,
  ) async =>
      await post(
        baseUrl + 'addQuickTemp',
        {
          'salutation': salutation,
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'desk_id': deskId,
          'branch_id': branchId,
          'mobile': mobile,
          'device': device,
          'digest': generateMd5(staticDigestKey + email),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> addPassword(
          String password, String rePassword) async =>
      await post(
        baseUrl + 'addupdatepassword',
        {
          'repassword': rePassword,
          'password': password,
          'tid': '$tempTid',
          'user_id': '$tempUserId',
          'digest': generateMd5(staticDigestKey + '$tempUserId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempEqualityInfo(UserData userData) async =>
      await post(
        baseUrl + 'updateTempEqualityInfo',
        {
          'user_id': userData.userId,
          'digest': generateMd5(staticDigestKey + userData.userId),
          'tid': '$tid',
          'national_identity': userData.nationalIdentity,
          'ethnic': userData.ethnic,
          'temp_gender': userData.tempGender,
          'religion': userData.religion,
          'sex_ori': userData.sexOri,
          'temp_dob': userData.tempDob,
          'married': userData.married,
          'temp_disability': userData.tempDisability,
          'temp_disability_desc': userData.tempDisabilityDesc,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempInfo(UserData userData) async => await post(
        baseUrl + 'updateTempInfo',
        {
          'digest': generateMd5(staticDigestKey + userData.userId),
          'tid': '$tid',
          'user_id': userData.userId,
          'employee_id_efos': userData.employeeIdEfos,
          'temp_id': userData.tempId,
          'status': userData.status,
          'contract': userData.contract,
          'house_number': userData.houseNumber,
          'address_1': userData.address_1,
          'address_2': userData.address_2,
          'address_town': userData.addressTown,
          'address_county': userData.addressCounty,
          'address_post_code': userData.addressPostCode,
          'dob': userData.dob,
          'criminal': userData.criminal,
          'criminal_desc': userData.criminalDesc,
          'branch_id': userData.branchId,
          'desk_id': userData.deskId,
          'hear_es': userData.hearAboutUS,
          'national_insurance_yes': userData.nationalInsuranceYes,
          'national_insurance': userData.nationalInsurance,
          'next_of_kin': userData.emergencyContact,
          'next_of_kin_number': userData.emergencyContactNumber,
          'next_of_kin_relationship': userData.emergencyContactRelationship,
          'bank_name': userData.bankName,
          'bank_sortcode': userData.bankSortcode,
          'bank_account': userData.bankAccount,
          'bank_holdername': userData.bankHolderName,
          'bank_reference': userData.bankReference,
          'national_identity': userData.nationalIdentity,
          'ethnic': userData.ethnic,
          'temp_gender': userData.tempGender,
          'religion': userData.religion,
          'sex_ori': userData.sexOri,
          'temp_dob': userData.tempDob,
          'married': userData.married,
          'temp_disability': userData.tempDisability,
          'temp_disability_desc': userData.tempDisabilityDesc,
          'eu_national': userData.euNational,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempMedicalInfo(
          MedicalHistory medicalHistory) async =>
      await post(
        baseUrl + 'updateTempMedicalInfo',
        {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'tid': '$tid',
          'medical_con': medicalHistory.medicalCondition,
          'diabetes': medicalHistory.diabetes,
          'heart': medicalHistory.heart,
          'stomach': medicalHistory.stomach,
          'sleep': medicalHistory.sleep,
          'chest': medicalHistory.chest,
          'blood': medicalHistory.blood,
          'fits': medicalHistory.fits,
          'other': medicalHistory.other,
          'medical_desc': medicalHistory.medicalDesc,
          'treatment': medicalHistory.treatment,
          'treatment_deta': medicalHistory.treatmentData,
          'drug': medicalHistory.drug,
          'drug_deta': medicalHistory.drugData,
          'illness_deta': medicalHistory.illnessData,
          'doctor_name': medicalHistory.doctorName,
          'doctor_address': medicalHistory.doctorAddress,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempEmployeeInfo(Company company) async =>
      await post(
        baseUrl + 'updateTempEmployeeInfo',
        {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'tid': '$tid',
          'id': company.id,
          'fao_company': company.company,
          'fao_name': company.contactPersonName,
          'fao_email': company.contactPersonEmail,
          'contact_number': company.contactNumber,
          'leaving_reason': company.leavingReason,
          'suggested_start_date': company.suggestedStartDate,
          'suggested_end_date': company.suggestedEndDate,
          'job_title': company.jobTitle,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempCompetancyInfo(data) async => await post(
        baseUrl + 'updateTempCompetancyInfo',
        {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'tid': '$tid',
          ...data
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempCompetancyInfoOne(data) async => await post(
        baseUrl + 'updateTempCompetancyInfoOne',
        {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'tid': '$tid',
          ...data
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempHMRCInfo(HMRCChecklist company) async =>
      await post(
        baseUrl + 'updateTempHMRCInfo',
        {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'tid': '$tid',
          'statement': company.statement.value,
          'q_9': company.q_9.value,
          'q_10': company.q_10.value,
          'q_11': company.q_11.value,
          'q_12': company.q_12.value,
          'q_13': company.q_13.value,
          'q_14': company.q_14.value,
          'q_15': company.q_15.value,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempPhotoInfo(String photo) async => await post(
        baseUrl + 'updateTempPhotoInfo',
        {
          'tid': '$tid',
          'photo': photo,
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempAgreementInfo(String documentType) async =>
      await post(
        baseUrl + 'updateTempAgreementInfo',
        {
          'tid': '$tid',
          'document_type': documentType,
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempAgreementInfo() async => await get(
        baseUrl + 'getTempAgreementInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getAgreementInfo(String typeId) async => await get(
        baseUrl + 'getAgreementInfo',
        query: {
          'type_id': typeId,
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getInterviewDropdownInfo() async => await get(
        baseUrl + 'getInterviewDropdownInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempInterviewInfo(String interviewMethod,
          String interviewDate, String interviewTime) async =>
      await post(
        baseUrl + 'updateTempInterviewInfo',
        {
          'tid': '$tid',
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'interview_method': interviewMethod,
          'interview_date': interviewDate,
          'interview_time': interviewTime,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<String> putSignature(XFile image) async => await post(
        baseUrl + 'putSignature',
        {
          'tid': '$tid',
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'Content-Type': '.png',
          'image': await image.readAsBytes(),
        },
        headers: headers,
      ).then((value) => value.statusCode == 200 ? 'OK' : 'Error');

  Future<BaseApiResponse> getSafetyDropdownInfo() async => await get(
        baseUrl + 'getSafetyDropdownInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempWorkInfo(UserData userData) async =>
      await post(
        baseUrl + 'updateTempWorkInfo',
        {
          'tid': '$tid',
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'own_transport': userData.ownTrasport,
          'hi_vis': userData.hiVis,
          'safety_boot': userData.requireSafetyBoot,
          'safety_boot_size': userData.safetyBootSize,
          'sunday': userData.sunday,
          'monday': userData.monday,
          'tuesday': userData.tuesday,
          'wednesday': userData.wednesday,
          'thursday': userData.thursday,
          'friday': userData.friday,
          'saturday': userData.saturday,
          'night_work': userData.nightWork,
          'hour_output': userData.hourOutput,
          'dbs_check': userData.dbsCheck,
          'dbs_date': userData.dbsDate,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getRolesDropdownInfo() async => await get(
        baseUrl + 'getRolesDropdownInfo',
        query: {
          'user_id': '$userId',
          'tid': '$tid',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getSkillsDropdownInfo(String roles) async =>
      await get(
        baseUrl + 'getSkillsDropdownInfo',
        query: {
          'user_id': '$userId',
          'roles': roles,
          'tid': '$tid',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempRolesInfo() async => await get(
        baseUrl + 'getTempRolesInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempSkillsInfo() async => await get(
        baseUrl + 'getTempSkillsInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempRolesInfo(String roles) async => await post(
        baseUrl + 'updateTempRolesInfo',
        {
          'user_id': '$userId',
          'tid': '$tid',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'roles': roles,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempSkillsInfo(String skills) async =>
      await post(
        baseUrl + 'updateTempSkillsInfo',
        {
          'user_id': '$userId',
          'tid': '$tid',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'skills': skills,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempLogInfo() async => await post(
        baseUrl + 'updateTempLogInfo',
        {
          'user_id': '$userId',
          'tid': '$tid',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'log': 'Yes',
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> tempVerificationByEmail(String email) async =>
      await get(
        baseUrl + 'tempVerificationByEmail',
        query: {
          'email': email,
          'digest': generateMd5(staticDigestKey + email),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempDrivingTestInfo() async => await get(
        baseUrl + 'getTempDrivingTestInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempDrivingTestInfo(
          DrivingTestModel data) async =>
      await post(
        baseUrl + 'updateTempDrivingTestInfo',
        {
          'user_id': '$userId',
          'tid': '$tid',
          'digest': generateMd5(staticDigestKey + '$userId'),
          'driver_name': data.driverName,
          'license_category': data.licenseCategory,
          'license_date': data.licenseDate,
          'max_dri_hours': data.maxDriHours,
          'break_minutes': data.breakMinutes,
          'rep_break_minutes': data.repBreakMinutes,
          'fol_break_minutes': data.folBreakMinutes,
          'day_hours': data.dayHours,
          'week_occa': data.weekOcca,
          'max_hour': data.maxHour,
          'week_max_hour': data.weekMaxHour,
          'exceed_hour': data.exceedHour,
          'day_min_hours': data.dayMinHours,
          'day_rest_min_hours': data.dayRestMinHours,
          'week_rest_hour': data.weekRestHour,
          'week_red_rest_hour': data.weekRedRestHour,
          'training_hours': data.trainingHours,
          'max_hour_lim': data.maxHourLim,
          'min_break_minutes': data.minBreakMinutes,
          'total_break_min': data.totalBreakMin,
          'break_min': data.breakMin,
          'total_hours': data.totalHours,
          'week_max_hour_lim': data.weekMaxHourLim,
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<List<AddressModel>> getAddress(String text) async => await get(
        'https://api.getAddress.io/find/$text',
        query: {
          'api-key': 'tEp3J2EbE0u2dAboKkKrZw10811',
          'sort': 'true',
          'expand': 'true',
        },
        headers: headers,
      ).then((value) {
        log('Get:===========================API===========================');
        log('URL -> ${value.request?.url}');
        log('Response -> ${value.body}');
        log('===========================API===========================');
        List<AddressModel> allData = [];
        final addresses = value.body['addresses'];
        final postCode = value.body['postcode'];
        if (addresses is List) {
          for (var address in addresses) {
            final add = AddressModel.fromJson(address);
            add.postcode = postCode;
            allData.add(add);
          }
        }
        if (value.body is Map && value.body['Message'] is String) {
          abShowMessage('postcodeNotFound'.tr);
        }
        return allData;
      });

  Future<BaseApiResponse> getCountryDropdownInfo() async => await get(
        baseUrl + 'getCountryDropdownInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getSalutationDropdownInfo() async => await get(
        baseUrl + 'getSalutationDropdownInfo',
        query: {'digest': generateMd5(staticDigestKey)},
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempPwdInfo() async => await post(
        baseUrl + 'updateTempPwdInfo',
        {
          'pwd_set': 1,
          'tid': '$tempTid',
          'user_id': '$tempUserId',
          'digest': generateMd5(staticDigestKey + '$tempUserId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempBioInfo() async => await post(
        baseUrl + 'updateTempBioInfo',
        {
          'bio_set': 1,
          'tid': '$tid',
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$tempUserId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempPassInfo() async => await post(
        baseUrl + 'updateTempPassInfo',
        {
          'pass_set': 1,
          'tid': '$tid',
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempCompDocInfo() async => await get(
        baseUrl + 'getTempCompDocInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempComplianceDocExpiry(String? passExp,
          String? immiExp, bool isHaveNi, String niReason) async =>
      await post(
        baseUrl + 'updateTempComplianceDocExpiry',
        {
          'tid': '$tid',
          'user_id': '$userId',
          'is_have_ni': isHaveNi ? '1' : '2',
          'is_have_ni_reason': isHaveNi ? niReason : '',
          'passport_expiry': passExp ?? '',
          'immi_expiry': immiExp ?? '',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempCVInfo() async => await get(
        baseUrl + 'getTempCVInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempLicenseInfo() async => await get(
        baseUrl + 'getTempLicenseInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempProgressInfo() async => await get(
        baseUrl + 'getTempProgressInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> getTempDeskInfo() async => await get(
        baseUrl + 'getTempDeskInfo',
        query: {
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> updateTempLicenseAdditionalInfo(
    String type,
    String docId,
    String drivingDateExpiry,
    String drivingIssueDate,
    String tachoDateExpiry,
    String tachoCountry,
    String digicardDateExpiry,
    String digicardCountry,
  ) async =>
      await post(
        baseUrl + 'updateTempLicenseAdditionalInfo',
        {
          'type': type,
          'doc_id': docId,
          'driving_date_expiry': drivingDateExpiry,
          'driving_issue_date': drivingIssueDate,
          'tacho_date_expiry': tachoDateExpiry,
          'tacho_country': tachoCountry,
          'digicard_date_expiry': digicardDateExpiry,
          'digicard_country': digicardCountry,
          'tid': '$tid',
          'user_id': '$userId',
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> addDeviceDetails(String email, String device) async =>
      await post(
        baseUrl + 'addDeviceDetails',
        {
          'email': email,
          'device': device,
          'digest': generateMd5(staticDigestKey + email),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> tempPassportExpiryInfo(String date) async =>
      await post(
        baseUrl + 'tempPassportExpiryInfo',
        {
          'user_id': '$userId',
          'expiry_date': date,
          'completed': completed,
          'digest': generateMd5(staticDigestKey + '$userId'),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> verifyUserFromEmailPwd(
          String email, String password) async =>
      await post(
        baseUrl + 'verifyUserFromEmailPwd',
        {
          'email': email,
          'password': password,
          'digest': generateMd5(staticDigestKey + email),
        },
        headers: headers,
      ).then((value) => safeDecode(value));

  Future<BaseApiResponse> verifyUserFromEmailPhone(
          String email, String password) async =>
      await post(
        baseUrl + 'verifyUserFromEmailPhone',
        {
          'email': email,
          'password': password,
          'digest': generateMd5(staticDigestKey + email),
        },
        headers: headers,
      ).then((value) => safeDecode(value));
}
