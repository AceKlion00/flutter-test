import 'package:extra_staff/models/key_value_m.dart';

class HMRCChecklist {
  KeyValue statement;
  KeyValue q_9;
  KeyValue q_10;
  KeyValue q_11;
  KeyValue q_12;
  KeyValue q_13;
  KeyValue q_14;
  KeyValue q_15;

  HMRCChecklist(
    this.statement,
    this.q_9,
    this.q_10,
    this.q_11,
    this.q_12,
    this.q_13,
    this.q_14,
    this.q_15,
  );

  HMRCChecklist fromJson(Map<String, dynamic> json) {
    return HMRCChecklist(
      statement = KeyValue('statement', json['statement'] ?? ''),
      q_9 = KeyValue('q_9', json['q_9'] ?? ''),
      q_10 = KeyValue('q_10', json['q_10'] ?? ''),
      q_11 = KeyValue('q_11', json['q_11'] ?? ''),
      q_12 = KeyValue('q_12', json['q_12'] ?? ''),
      q_13 = KeyValue('q_13', json['q_13'] ?? ''),
      q_14 = KeyValue('q_14', json['q_14'] ?? ''),
      q_15 = KeyValue('q_15', json['q_15'] ?? ''),
    );
  }
}
