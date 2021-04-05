import 'package:idealog/analytics/analyticsColumn.dart';

String createAnalyticsTable = 'create table if not exists $Analytics_Table_Name ($Column_Completed_Analytics_Task TEXT PRIMARY_KEY,$Column_Year INTEGER,$Column_Month INTEGER,$Column_day INTEGER)';