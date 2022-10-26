import 'package:extra_staff/utils/ab.dart';

class DrivingTestModel {
  String driverName;
  String licenseCategory;
  String licenseDate;
  String maxDriHours;
  String breakMinutes;
  String repBreakMinutes;
  String folBreakMinutes;
  String dayHours;
  String weekOcca;
  String maxHour;
  String weekMaxHour;
  String exceedHour;
  String dayMinHours;
  String dayRestMinHours;
  String weekRestHour;
  String weekRedRestHour;
  String trainingHours;
  String maxHourLim;
  String minBreakMinutes;
  String totalBreakMin;
  String breakMin;
  String totalHours;
  String weekMaxHourLim;

  DrivingTestModel({
    required this.driverName,
    required this.licenseCategory,
    required this.licenseDate,
    required this.maxDriHours,
    required this.breakMinutes,
    required this.repBreakMinutes,
    required this.folBreakMinutes,
    required this.dayHours,
    required this.weekOcca,
    required this.maxHour,
    required this.weekMaxHour,
    required this.exceedHour,
    required this.dayMinHours,
    required this.dayRestMinHours,
    required this.weekRestHour,
    required this.weekRedRestHour,
    required this.trainingHours,
    required this.maxHourLim,
    required this.minBreakMinutes,
    required this.totalBreakMin,
    required this.breakMin,
    required this.totalHours,
    required this.weekMaxHourLim,
  });

  factory DrivingTestModel.fromJson(Map<String, dynamic> json) {
    return DrivingTestModel(
      driverName: ab(json['driver_name'], fallback: ''),
      licenseCategory: ab(json['license_category'], fallback: ''),
      licenseDate: ab(json['license_date'], fallback: ''),
      maxDriHours: ab(json['max_dri_hours'], fallback: ''),
      breakMinutes: ab(json['break_minutes'], fallback: ''),
      repBreakMinutes: ab(json['rep_break_minutes'], fallback: ''),
      folBreakMinutes: ab(json['fol_break_minutes'], fallback: ''),
      dayHours: ab(json['day_hours'], fallback: ''),
      weekOcca: ab(json['week_occa'], fallback: ''),
      maxHour: ab(json['max_hour'], fallback: ''),
      weekMaxHour: ab(json['week_max_hour'], fallback: ''),
      exceedHour: ab(json['exceed_hour'], fallback: ''),
      dayMinHours: ab(json['day_min_hours'], fallback: ''),
      dayRestMinHours: ab(json['day_rest_min_hours'], fallback: ''),
      weekRestHour: ab(json['week_rest_hour'], fallback: ''),
      weekRedRestHour: ab(json['week_red_rest_hour'], fallback: ''),
      trainingHours: ab(json['training_hours'], fallback: ''),
      maxHourLim: ab(json['max_hour_lim'], fallback: ''),
      minBreakMinutes: ab(json['min_break_minutes'], fallback: ''),
      totalBreakMin: ab(json['total_break_min'], fallback: ''),
      breakMin: ab(json['break_min'], fallback: ''),
      totalHours: ab(json['total_hours'], fallback: ''),
      weekMaxHourLim: ab(json['week_max_hour_lim'], fallback: ''),
    );
  }
}
