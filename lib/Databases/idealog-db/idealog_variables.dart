// Table names
const String ideasTableName = "ideasTable"; 
const String completedTable = "CompletedTable";
const String uncompletedTable = "UncompletedTable";

// Column names
const String Column_ideaPrimaryKey = 'ideaPrimaryKey';
const String Column_ideaTitle = 'ideaTitle';
const String Column_moreDetails = 'moreDetails';
const String Column_tasks = 'tasks';
const String Column_taskOrder = 'taskOrder';
const String Column_taskPrimaryKey = 'taskPrimaryKey';


// Sql execution strings
const String createIdeasTableSqlCommand = 'create table if not exists $ideasTableName ($Column_ideaPrimaryKey INTEGER PRIMARY_KEY,$Column_ideaTitle TEXT,$Column_moreDetails TEXT)'; 
const String createCompletedTableSqlCommand = 'create table if not exists $completedTable ($Column_taskPrimaryKey INTEGER PRIMARY_KEY,$Column_ideaPrimaryKey INTEGER, $Column_tasks Text, $Column_taskOrder INTEGER)';
const String createUncompletedTableSqlCommand = 'create table if not exists $uncompletedTable ($Column_taskPrimaryKey INTEGER PRIMARY_KEY, $Column_ideaPrimaryKey INTEGER, $Column_tasks Text, $Column_taskOrder INTEGER)';

