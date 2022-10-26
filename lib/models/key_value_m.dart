import 'package:extra_staff/utils/ab.dart';

class KeyValue {
  String id;
  String value;

  KeyValue(this.id, this.value);

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(
        ab(json['id'], fallback: ''), ab(json['value'], fallback: ''));
  }
}
