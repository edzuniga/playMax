import 'package:flutter/material.dart';

class FormattedTime {
  //Format TimeOfDay to easy readable time
  static String getFormattedTime(TimeOfDay time) {
    String amOrPm = 'am';
    String formattedHour = '${time.hour}';
    String formattedMinute = '${time.minute}';
    if (time.hour > 12) {
      formattedHour = (time.hour - 12).toString();
    }
    if (time.hour > 11) {
      amOrPm = 'pm';
    }
    if (time.minute < 10) {
      formattedMinute = '0${time.minute}';
    }
    return "$formattedHour:$formattedMinute$amOrPm";
  }

  //Check if end time is greater than start time
  static bool checkSelectedTimeOfDay(TimeOfDay startTime, TimeOfDay endTime) {
    int startTimeInMinutes = startTime.hour * 60 + startTime.minute;
    int endTimeInMinutes = endTime.hour * 60 + endTime.minute;
    return endTimeInMinutes > startTimeInMinutes;
  }
}
