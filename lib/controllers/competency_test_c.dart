import 'package:get/get.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:extra_staff/models/competency_test_m.dart';

class CompetencyTestController extends GetxController {
  int? score;
  List<CompetencyTestModel> questions = [];

  String scoreText() {
    return score != null
        ? '${'yourScoreIs'.tr} ${score! <= 9 ? '0' : ''}$score/${questions.length}'
        : '';
  }

  Future<String> getCompetancyInfo() async {
    final response = await Services.shared.getCompetancyInfo();
    if (response.result is List) {
      score = null;
      questions.removeWhere((element) => true);
      for (var item in response.result) {
        questions.add(CompetencyTestModel.fromJson(item));
      }
    }
    final response2 = await Services.shared.getTempCompetancyInfo();
    if (response2.result is List) {
      for (var i in response2.result) {
        if (i is Map<String, dynamic>) {
          score = score ??= 0;
          final value = i['answer'] == '1';
          if (value) {
            score = score! + (value ? 1 : 0);
          }
        }
      }
    }
    return response.errorMessage;
  }
}
