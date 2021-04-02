import 'package:idealog/global/strings.dart';
import 'package:idealog/sqlite-db/ideasDbColumn.dart';

const String createIdeasTableSqlCommand = 'create table if not exists $ideasTableName ($Column_uniqueId INTEGER PRIMARY_KEY,$Column_ideaTitle TEXT,$Column_moreDetails TEXT,$Column_uncompletedTasks TEXT,$Column_completedTasks TEXT)';