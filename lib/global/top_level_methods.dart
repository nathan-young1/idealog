  import 'package:intl/intl.dart';

/// Converts a date time object to a formatted string.
  String convertDateTimeObjToAFormattedString(DateTime dateTime){
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formattedDateString = formatter.format(dateTime);
    return formattedDateString;
  }