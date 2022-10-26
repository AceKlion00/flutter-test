import 'dart:convert';

import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/constants.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';

class RolesViewController extends GetxController {
  List<KeyValue> roles = [];
  String selectedRoles = '';
  bool get isForklift => selectedRoles.contains('24');
  bool get isOnly35T {
    if (selectedRoles.isNotEmpty) {
      final values = selectedRoles.split(',');
      is35T = values.contains('4');
      if (values.length == 1 && values.first == '4') {
        return true;
      }
    }
    return false;
  }

  bool isSelected(int position) {
    return selectedRoles.split(',').contains(roles[position].id);
  }

  addOrRemoveRole(int index) {
    List<String> allValues =
        selectedRoles.isEmpty ? [] : selectedRoles.split(',');
    final id = roles[index].id;
    if (allValues.contains(id)) {
      final removeIndex = allValues.indexOf(id);
      allValues.removeAt(removeIndex);
    } else {
      allValues.add(id);
    }
    selectedRoles = allValues.join(',');
  }

  setDataInStorage() async {
    final arguments = {
      'isForklift': isForklift,
      'selectedRoles': selectedRoles,
      'isOnly35T': isOnly35T,
    };
    final map = json.encode(arguments);
    await localStorage?.setString('RolesView', map);
  }

  Future apiCalls() async {
    String message = '';
    message = await getRolesDropdownInfo();
    if (message.isNotEmpty) abShowMessage(message);
    message = await getTempRolesInfo();
    if (message.isNotEmpty) abShowMessage(message);
  }

  Future<String> getRolesDropdownInfo() async {
    final response = await Services.shared.getRolesDropdownInfo();
    if (response.result is Map && response.result['roles'] is List) {
      for (var i in response.result['roles']) {
        final value = KeyValue.fromJson(i);
        value.id = '${i['id']}';
        roles.add(value);
      }
    }
    return response.errorMessage;
  }

  Future<String> getTempRolesInfo() async {
    final response = await Services.shared.getTempRolesInfo();
    if (response.result is Map && response.result['roles'] is String) {
      selectedRoles = response.result['roles'];
    }
    return response.errorMessage;
  }

  Future<String> updateTempRolesInfo() async {
    if (selectedRoles.isEmpty) {
      return 'Please select at least one Role';
    }
    final response = await Services.shared.updateTempRolesInfo(selectedRoles);
    return response.errorMessage;
  }
}
