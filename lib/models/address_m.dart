import 'package:extra_staff/utils/ab.dart';

class AddressModel {
  String postcode;
  String addressLine1;
  String addressLine2;
  String town;
  String county;

  String fullAddress() {
    return '$addressLine1 $addressLine2 $town $county $postcode';
  }

  AddressModel({
    required this.postcode,
    required this.addressLine1,
    required this.addressLine2,
    required this.town,
    required this.county,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      postcode: ab(json['postcode'], fallback: ''),
      addressLine1: ab(json['line_1'], fallback: ''),
      addressLine2: ab(json['line_2'], fallback: ''),
      town: ab(json['town_or_city'], fallback: ''),
      county: ab(json['district'], fallback: ''),
    );
  }
}
