import 'package:extra_staff/utils/ab.dart';

class QuickAddTempAdd {
  int userid;
  int tid;
  String code;
  String uniqueid;

  QuickAddTempAdd(this.userid, this.tid, this.code, this.uniqueid);

  factory QuickAddTempAdd.fromJson(Map<String, dynamic> json) {
    return QuickAddTempAdd(
      ab(json['userid'], fallback: -1),
      ab(json['tid'], fallback: -1),
      ab(json['code_new'], fallback: ''),
      ab(json['uniqueid'], fallback: ''),
    );
  }
}
