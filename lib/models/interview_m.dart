import 'package:extra_staff/models/key_value_m.dart';

class InterViewModel {
  List<KeyValue> methods;
  List<KeyValue> times;

  InterViewModel(this.methods, this.times);

  factory InterViewModel.fromJson(Map<String, dynamic> json) {
    List<KeyValue> dMethods = [];
    List<KeyValue> dTimes = [];
    if (json['interviewmethod'] is List) {
      dMethods.add(KeyValue('', 'Please select method'));
      for (var i in json['interviewmethod']) {
        dMethods.add(KeyValue.fromJson(i));
      }
    }
    if (json['interview_time'] is List) {
      dTimes.add(KeyValue('', 'Please select time'));
      for (var i in json['interview_time']) {
        dTimes.add(KeyValue.fromJson(i));
      }
    }
    return InterViewModel(dMethods, dTimes);
  }
}
