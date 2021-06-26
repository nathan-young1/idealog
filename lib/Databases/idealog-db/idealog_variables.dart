// Table names
const String ideasTableName = "ideasTable"; 
const String completedTable = "CompletedTable";
const String uncompletedTable = "UncompletedTable";

// Column names
const String Column_uniqueId = 'uniqueId';
const String Column_ideaTitle = 'ideaTitle';
const String Column_moreDetails = 'moreDetails';
const String Column_tasks = 'tasks';
const String Column_taskOrder = 'taskOrder';


// Sql execution strings
const String createIdeasTableSqlCommand = 'create table if not exists $ideasTableName ($Column_uniqueId INTEGER PRIMARY_KEY,$Column_ideaTitle TEXT,$Column_moreDetails TEXT)'; 
const String createCompletedTableSqlCommand = 'create table if not exists $completedTable ($Column_uniqueId INTEGER, $Column_tasks Text, $Column_taskOrder Serial)';
const String createUncompletedTableSqlCommand = 'create table if not exists $uncompletedTable ($Column_uniqueId INTEGER, $Column_tasks Text, $Column_taskOrder Serial)';

