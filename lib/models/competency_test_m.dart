import 'package:extra_staff/utils/ab.dart';

class CompetencyTestModel {
  String questionId;
  String question;
  String questionImg;
  String optionA;
  String optionB;
  String optionC;
  String optionD;
  String optionE;
  int answer;
  int selectedAnswer;

  CompetencyTestModel(
    this.questionId,
    this.question,
    this.questionImg,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.optionE,
    this.answer,
    this.selectedAnswer,
  );

  factory CompetencyTestModel.fromJson(Map<String, dynamic> json) {
    var answerIndex = -1;
    var answer = ab(json['answer'], fallback: '');
    switch (answer) {
      case 'option_a':
        answerIndex = 1;
        break;
      case 'option_b':
        answerIndex = 2;
        break;
      case 'option_c':
        answerIndex = 3;
        break;
      case 'option_d':
        answerIndex = 4;
        break;
      default:
        answerIndex = 5;
    }
    return CompetencyTestModel(
      ab(json['question_id'], fallback: ''),
      ab(json['question'], fallback: ''),
      ab(json['question_img'], fallback: ''),
      ab(json['option_a'], fallback: ''),
      ab(json['option_b'], fallback: ''),
      ab(json['option_c'], fallback: ''),
      ab(json['option_d'], fallback: ''),
      ab(json['option_e'], fallback: ''),
      answerIndex,
      -1,
    );
  }

  List<String> getAllOptions() => <String>[
        if (optionA.isNotEmpty) optionA,
        if (optionB.isNotEmpty) optionB,
        if (optionC.isNotEmpty) optionC,
        if (optionD.isNotEmpty) optionD,
        if (optionE.isNotEmpty) optionE,
      ];
}
