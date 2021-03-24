import 'package:idealog/global/strings.dart';
import 'package:idealog/sqlite-db/ideasDbColumn.dart';
import 'package:idealog/sqlite-db/scheduleDbColumn.dart';

const String createScheduleTableSqlCommand = 'create table if not exists $scheduleTableName ($Column_uniqueId INTEGER PRIMARY_KEY,$Column_scheduleDetails TEXT,$Column_scheduleDate TEXT,$Column_startTime TEXT,$Column_endTime TEXT,$Column_repeatSchedule TEXT)';
const String createIdeasTableSqlCommand = 'create table if not exists $ideasTableName ($Column_uniqueId INTEGER PRIMARY_KEY,$Column_ideaTitle TEXT,$Column_moreDetails TEXT,$Column_uncompletedTasks TEXT,$Column_completedTasks TEXT)';