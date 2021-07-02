// Table names
const String ideasTable = "ideasTable"; 
const String completedTable = "CompletedTable";
const String uncompletedTable = "UncompletedTable";

// Column names
const String Column_ideaId = 'ideaId';
const String Column_ideaTitle = 'ideaTitle';
const String Column_moreDetails = 'moreDetails';
const String Column_tasks = 'tasks';
const String Column_taskOrder = 'taskOrder';
const String Column_taskId = 'taskId';


// Sql execution strings
const String createIdeasTableSqlCommand = 'create table if not exists $ideasTable ($Column_ideaId INTEGER PRIMARY_KEY NOT NULL,$Column_ideaTitle TEXT,$Column_moreDetails TEXT)'; 
const String createCompletedTableSqlCommand = 'create table if not exists $completedTable ($Column_taskId INTEGER PRIMARY_KEY NOT NULL,$Column_ideaId INTEGER NOT NULL, $Column_tasks Text, $Column_taskOrder INTEGER)';
const String createUncompletedTableSqlCommand = 'create table if not exists $uncompletedTable ($Column_taskId INTEGER PRIMARY_KEY NOT NULL, $Column_ideaId INTEGER NOT NULL, $Column_tasks Text, $Column_taskOrder INTEGER)';
const String createLastSyncTable = "create table if not exists LastSync (id_no Integer Primary Key, time Text Not Null)";

