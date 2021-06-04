// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analyticsSql.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Analytic extends DataClass implements Insertable<Analytic> {
  final int key;
  final int year;
  final int month;
  final int day;
  final String completedTasks;
  Analytic(
      {required this.key,
      required this.year,
      required this.month,
      required this.day,
      required this.completedTasks});
  factory Analytic.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Analytic(
      key: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key'])!,
      year: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}year'])!,
      month: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}month'])!,
      day: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}day'])!,
      completedTasks: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}completed_tasks'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<int>(key);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['day'] = Variable<int>(day);
    map['completed_tasks'] = Variable<String>(completedTasks);
    return map;
  }

  AnalyticsSqlCompanion toCompanion(bool nullToAbsent) {
    return AnalyticsSqlCompanion(
      key: Value(key),
      year: Value(year),
      month: Value(month),
      day: Value(day),
      completedTasks: Value(completedTasks),
    );
  }

  factory Analytic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Analytic(
      key: serializer.fromJson<int>(json['key']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      day: serializer.fromJson<int>(json['day']),
      completedTasks: serializer.fromJson<String>(json['completedTasks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<int>(key),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'day': serializer.toJson<int>(day),
      'completedTasks': serializer.toJson<String>(completedTasks),
    };
  }

  Analytic copyWith(
          {int? key,
          int? year,
          int? month,
          int? day,
          String? completedTasks}) =>
      Analytic(
        key: key ?? this.key,
        year: year ?? this.year,
        month: month ?? this.month,
        day: day ?? this.day,
        completedTasks: completedTasks ?? this.completedTasks,
      );
  @override
  String toString() {
    return (StringBuffer('Analytic(')
          ..write('key: $key, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('day: $day, ')
          ..write('completedTasks: $completedTasks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      key.hashCode,
      $mrjc(
          year.hashCode,
          $mrjc(
              month.hashCode, $mrjc(day.hashCode, completedTasks.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Analytic &&
          other.key == this.key &&
          other.year == this.year &&
          other.month == this.month &&
          other.day == this.day &&
          other.completedTasks == this.completedTasks);
}

class AnalyticsSqlCompanion extends UpdateCompanion<Analytic> {
  final Value<int> key;
  final Value<int> year;
  final Value<int> month;
  final Value<int> day;
  final Value<String> completedTasks;
  const AnalyticsSqlCompanion({
    this.key = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.day = const Value.absent(),
    this.completedTasks = const Value.absent(),
  });
  AnalyticsSqlCompanion.insert({
    this.key = const Value.absent(),
    required int year,
    required int month,
    required int day,
    required String completedTasks,
  })  : year = Value(year),
        month = Value(month),
        day = Value(day),
        completedTasks = Value(completedTasks);
  static Insertable<Analytic> custom({
    Expression<int>? key,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? day,
    Expression<String>? completedTasks,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (day != null) 'day': day,
      if (completedTasks != null) 'completed_tasks': completedTasks,
    });
  }

  AnalyticsSqlCompanion copyWith(
      {Value<int>? key,
      Value<int>? year,
      Value<int>? month,
      Value<int>? day,
      Value<String>? completedTasks}) {
    return AnalyticsSqlCompanion(
      key: key ?? this.key,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<int>(key.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (completedTasks.present) {
      map['completed_tasks'] = Variable<String>(completedTasks.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalyticsSqlCompanion(')
          ..write('key: $key, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('day: $day, ')
          ..write('completedTasks: $completedTasks')
          ..write(')'))
        .toString();
  }
}

class $AnalyticsSqlTable extends AnalyticsSql
    with TableInfo<$AnalyticsSqlTable, Analytic> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AnalyticsSqlTable(this._db, [this._alias]);
  final VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedIntColumn key = _constructKey();
  GeneratedIntColumn _constructKey() {
    return GeneratedIntColumn('key', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedIntColumn year = _constructYear();
  GeneratedIntColumn _constructYear() {
    return GeneratedIntColumn(
      'year',
      $tableName,
      false,
    );
  }

  final VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedIntColumn month = _constructMonth();
  GeneratedIntColumn _constructMonth() {
    return GeneratedIntColumn(
      'month',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedIntColumn day = _constructDay();
  GeneratedIntColumn _constructDay() {
    return GeneratedIntColumn(
      'day',
      $tableName,
      false,
    );
  }

  final VerificationMeta _completedTasksMeta =
      const VerificationMeta('completedTasks');
  @override
  late final GeneratedTextColumn completedTasks = _constructCompletedTasks();
  GeneratedTextColumn _constructCompletedTasks() {
    return GeneratedTextColumn(
      'completed_tasks',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [key, year, month, day, completedTasks];
  @override
  $AnalyticsSqlTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'analytics_sql';
  @override
  final String actualTableName = 'analytics_sql';
  @override
  VerificationContext validateIntegrity(Insertable<Analytic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('completed_tasks')) {
      context.handle(
          _completedTasksMeta,
          completedTasks.isAcceptableOrUnknown(
              data['completed_tasks']!, _completedTasksMeta));
    } else if (isInserting) {
      context.missing(_completedTasksMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Analytic map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Analytic.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AnalyticsSqlTable createAlias(String alias) {
    return $AnalyticsSqlTable(_db, alias);
  }
}

abstract class _$AnalyticDB extends GeneratedDatabase {
  _$AnalyticDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $AnalyticsSqlTable analyticsSql = $AnalyticsSqlTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [analyticsSql];
}
