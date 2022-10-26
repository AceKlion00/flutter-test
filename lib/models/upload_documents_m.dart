import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Documents {
  String id;
  List<KeyValue> data;
  KeyValue selected;
  bool? status;

  Documents(this.id, this.data, this.selected, this.status);

  factory Documents.fromJson(String key, List<dynamic> data) {
    List<KeyValue> allData = [];
    KeyValue selected = KeyValue.fromJson({});
    allData.add(KeyValue('', 'pleaseSelect'.tr));
    for (var d in data) {
      if (d is Map<String, dynamic>) {
        allData.add(KeyValue.fromJson(d));
      }
    }
    if (allData.isNotEmpty) {
      selected = allData.first;
    }
    return Documents(
      ab(key, fallback: ''),
      ab(allData, fallback: []),
      ab(selected, fallback: KeyValue.fromJson({})),
      null,
    );
  }
}
