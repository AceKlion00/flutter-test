import 'package:extra_staff/models/drop_donws_m.dart';
import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/models/user_data_m.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BankDetailsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  KeyValue selectedItem = KeyValue.fromJson({});
  UserData data = UserData.fromJson({});
  DropDowns dropDowns = DropDowns.fromJson({});

  Future<String> updateTempInfo() async {
    final response = await Services.shared.updateTempInfo(data);
    return response.errorMessage;
  }
}
