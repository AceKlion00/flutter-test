import 'package:get/get.dart';
import 'package:extra_staff/models/company.dart';
import 'package:extra_staff/utils/services.dart';

class EmploymentHistoryController extends GetxController {
  List<Company> companies = [];

  Future<String> getTempEmployeeInfo() async {
    companies.removeWhere((element) => true);
    final response = await Services.shared.getTempEmployeeInfo();
    if (response.errorCode == 0) {
      if (response.result is List) {
        for (var i in response.result) {
          companies.add(Company.fromJson(i));
        }
      }
    }
    return response.errorMessage;
  }
}
