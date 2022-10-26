import 'package:extra_staff/utils/ab.dart';
import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/models/competency_test_m.dart';

class OnboardingWizardController extends GetxController {
  int selection = -1;
  int? lastIndex;
  CompetencyTestModel question = CompetencyTestModel.fromJson({});
  bool isCompleted = false;
  List<CompetencyTestModel> questions = [];

  Future<String> updateTempCompetancyInfo() async {
    Map<String, String> uuu = {};
    for (var q in questions) {
      uuu['q_${q.questionId}'] =
          '${q.selectedAnswer == -1 ? '' : q.selectedAnswer == q.answer ? 1 : 2}';
    }
    final index = questions.indexOf(question);
    if (index < 10) {
      final response = await Services.shared.updateTempCompetancyInfo(uuu);
      return response.errorMessage;
    } else {
      final response2 = await Services.shared.updateTempCompetancyInfoOne(uuu);
      return response2.errorMessage;
    }
  }

  getCompetancyInfo() async {
    final response = await Services.shared.getCompetancyInfo();
    if (response.result is List) {
      questions.removeWhere((element) => true);
      for (var item in response.result) {
        questions.add(CompetencyTestModel.fromJson(item));
      }
    }
    if (response.errorMessage.isNotEmpty) {
      abShowMessage(response.errorMessage);
    }
    final response2 = await Services.shared.getTempCompetancyInfo();
    if (response2.result is List) {
      isCompleted =
          (response2.result as List).length == (response.result as List).length;
      lastIndex = (response2.result as List).length - 1;
    }
    if (response2.errorMessage.isNotEmpty) {
      abShowMessage(response2.errorMessage);
    }
  }
}
