import 'dart:convert';

import 'package:extra_staff/models/key_value_m.dart';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';

class SkillsViewController extends GetxController {
  List<KeyValue> skills = [];
  String selectedSkills = '';
  String selectedRoles = '';

  bool isSelected(int position) {
    return selectedSkills.split(',').contains(skills[position].id);
  }

  addOrRemoveRole(int index) {
    List<String> allValues =
        selectedSkills.isEmpty ? [] : selectedSkills.split(',');
    final id = skills[index].id;
    if (allValues.contains(id)) {
      final removeIndex = allValues.indexOf(id);
      allValues.removeAt(removeIndex);
    } else {
      allValues.add(id);
    }
    selectedSkills = allValues.join(',');
  }

  getDataFromStorage() {
    final storedData = localStorage?.getString('RolesView') ?? '';
    final map = json.decode(storedData);
    selectedRoles = map['selectedRoles'];
  }

  Future apiCalls() async {
    String message = '';
    message = await getSkillsDropdownInfo();
    if (message.isNotEmpty) abShowMessage(message);
    message = await getTempSkillsInfo();
    if (message.isNotEmpty) abShowMessage(message);
  }

  Future<String> getSkillsDropdownInfo() async {
    final response = await Services.shared.getSkillsDropdownInfo(selectedRoles);
    if (response.result is Map && response.result['skills'] is List) {
      for (var i in response.result['skills']) {
        final value = KeyValue.fromJson(i);
        value.id = '${i['id']}';
        skills.add(value);
      }
    }
    return response.errorMessage;
  }

  Future<String> getTempSkillsInfo() async {
    final response = await Services.shared.getTempSkillsInfo();
    if (response.result is Map && response.result['skills'] is String) {
      selectedSkills = response.result['skills'];
    }
    return response.errorMessage;
  }

  Future<String> updateTempSkillsInfo() async {
    if (selectedSkills.isEmpty) {
      return 'Please select at least one Skill';
    }
    final response = await Services.shared.updateTempSkillsInfo(selectedSkills);
    return response.errorMessage;
  }
}
