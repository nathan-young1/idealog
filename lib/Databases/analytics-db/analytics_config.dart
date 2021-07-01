// Column names
const String Column_key = 'key';
const String Column_year = 'year';
const String Column_month = 'month';
const String Column_day = 'day';
const String Column_completedTasks = 'completedTasks';

// Table name
const String analyticsTable = 'analytics';

// Analytics Sql statements
const String createAnalyticsTable = 'create table if not exists $analyticsTable ($Column_key INTEGER PRIMARY_KEY NOT NULL, $Column_year INTEGER, $Column_month INTEGER, $Column_day INTEGER, $Column_completedTasks TEXT)';