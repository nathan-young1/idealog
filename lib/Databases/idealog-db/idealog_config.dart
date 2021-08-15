// Table names
const String ideaTable = "ideaTable"; 
const String completedTable = "CompletedTable";
const String uncompletedTable = "UncompletedTable";

// Column names
const String Column_ideaId = 'ideaId';
const String Column_ideaTitle = 'ideaTitle';
const String Column_moreDetails = 'moreDetails';
const String Column_favorite = 'favorite';
// Task Column names
const String Column_task = 'task';
const String Column_taskOrder = 'taskOrder';
const String Column_taskId = 'taskId';
const String Column_taskPriority = 'taskPriority';

// IsFavorite idea
const String Favorite_Yes = 'true'; 
const String Favorite_No = 'false';

// Task Priority
const int Priority_High = 1;
const int Priority_Medium = 2;
const int Priority_Low = 3;

// Sql execution strings
const String createIdeasTableSqlCommand = "create table if not exists $ideaTable ($Column_ideaId INTEGER PRIMARY_KEY NOT NULL,$Column_ideaTitle TEXT,$Column_moreDetails TEXT,$Column_favorite TEXT DEFAULT '$Favorite_No')"; 
const String createCompletedTableSqlCommand = 'create table if not exists $completedTable ($Column_taskId INTEGER PRIMARY_KEY NOT NULL,$Column_ideaId INTEGER NOT NULL, $Column_task Text, $Column_taskOrder INTEGER, $Column_taskPriority INTEGER NOT NULL)';
const String createUncompletedTableSqlCommand = 'create table if not exists $uncompletedTable ($Column_taskId INTEGER PRIMARY_KEY NOT NULL, $Column_ideaId INTEGER NOT NULL, $Column_task Text, $Column_taskOrder INTEGER, $Column_taskPriority INTEGER NOT NULL)';

