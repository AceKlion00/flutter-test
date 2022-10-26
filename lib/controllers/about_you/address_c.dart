import 'package:extra_staff/models/address_m.dart';
import 'package:extra_staff/models/drop_donws_m.dart';
import 'package:extra_staff/utils/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extra_staff/models/user_data_m.dart';

class AddressController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserData data = UserData.fromJson({});
  DropDowns dropDowns = DropDowns.fromJson({});
  String searchByPostcode = '';
  List<AddressModel> allAddresses = [];
  AddressModel selectedAddress = AddressModel.fromJson({});

  Future<String> updateTempInfo() async {
    data.nationalInsuranceYes = 'no';
    final response = await Services.shared.updateTempInfo(data);
    return response.errorMessage;
  }

  setValues(AddressModel newValue) {
    selectedAddress = newValue;
    data.addressPostCode = newValue.postcode;
    data.address_1 = newValue.addressLine1;
    data.address_2 = newValue.addressLine2;
    data.addressTown = newValue.town;
    data.addressCounty = newValue.county;
  }
}
