// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idealog_Db_Moor.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Idea extends DataClass implements Insertable<Idea> {
  final int uniqueId;
  final String ideaTitle;
  final String? moreDetails;
  final String? completedTasks;
  final String? uncompletedTasks;
  Idea(
      {required this.uniqueId,
      required this.ideaTitle,
      this.moreDetails,
      this.completedTasks,
      this.uncompletedTasks});
  factory Idea.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Idea(
      uniqueId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unique_id'])!,
      ideaTitle: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}idea_title'])!,
      moreDetails: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}more_details']),
      completedTasks: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}completed_tasks']),
      uncompletedTasks: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uncompleted_tasks']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['unique_id'] = Variable<int>(uniqueId);
    map['idea_title'] = Variable<String>(ideaTitle);
    if (!nullToAbsent || moreDetails != null) {
      map['more_details'] = Variable<String?>(moreDetails);
    }
    if (!nullToAbsent || completedTasks != null) {
      map['completed_tasks'] = Variable<String?>(completedTasks);
    }
    if (!nullToAbsent || uncompletedTasks != null) {
      map['uncompleted_tasks'] = Variable<String?>(uncompletedTasks);
    }
    return map;
  }

  IdeasCompanion toCompanion(bool nullToAbsent) {
    return IdeasCompanion(
      uniqueId: Value(uniqueId),
      ideaTitle: Value(ideaTitle),
      moreDetails: moreDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(moreDetails),
      completedTasks: completedTasks == null && nullToAbsent
          ? const Value.absent()
          : Value(completedTasks),
      uncompletedTasks: uncompletedTasks == null && nullToAbsent
          ? const Value.absent()
          : Value(uncompletedTasks),
    );
  }

  factory Idea.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Idea(
      uniqueId: serializer.fromJson<int>(json['uniqueId']),
      ideaTitle: serializer.fromJson<String>(json['ideaTitle']),
      moreDetails: serializer.fromJson<String?>(json['moreDetails']),
      completedTasks: serializer.fromJson<String?>(json['completedTasks']),
      uncompletedTasks: serializer.fromJson<String?>(json['uncompletedTasks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uniqueId': serializer.toJson<int>(uniqueId),
      'ideaTitle': serializer.toJson<String>(ideaTitle),
      'moreDetails': serializer.toJson<String?>(moreDetails),
      'completedTasks': serializer.toJson<String?>(completedTasks),
      'uncompletedTasks': serializer.toJson<String?>(uncompletedTasks),
    };
  }

  Idea copyWith(
          {int? uniqueId,
          String? ideaTitle,
          String? moreDetails,
          String? completedTasks,
          String? uncompletedTasks}) =>
      Idea(
        uniqueId: uniqueId ?? this.uniqueId,
        ideaTitle: ideaTitle ?? this.ideaTitle,
        moreDetails: moreDetails ?? this.moreDetails,
        completedTasks: completedTasks ?? this.completedTasks,
        uncompletedTasks: uncompletedTasks ?? this.uncompletedTasks,
      );
  @override
  String toString() {
    return (StringBuffer('Idea(')
          ..write('uniqueId: $uniqueId, ')
          ..write('ideaTitle: $ideaTitle, ')
          ..write('moreDetails: $moreDetails, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('uncompletedTasks: $uncompletedTasks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      uniqueId.hashCode,
      $mrjc(
          ideaTitle.hashCode,
          $mrjc(moreDetails.hashCode,
              $mrjc(completedTasks.hashCode, uncompletedTasks.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Idea &&
          other.uniqueId == this.uniqueId &&
          other.ideaTitle == this.ideaTitle &&
          other.moreDetails == this.moreDetails &&
          other.completedTasks == this.completedTasks &&
          other.uncompletedTasks == this.uncompletedTasks);
}

class IdeasCompanion extends UpdateCompanion<Idea> {
  final Value<int> uniqueId;
  final Value<String> ideaTitle;
  final Value<String?> moreDetails;
  final Value<String?> completedTasks;
  final Value<String?> uncompletedTasks;
  const IdeasCompanion({
    this.uniqueId = const Value.absent(),
    this.ideaTitle = const Value.absent(),
    this.moreDetails = const Value.absent(),
    this.completedTasks = const Value.absent(),
    this.uncompletedTasks = const Value.absent(),
  });
  IdeasCompanion.insert({
    this.uniqueId = const Value.absent(),
    required String ideaTitle,
    this.moreDetails = const Value.absent(),
    this.completedTasks = const Value.absent(),
    this.uncompletedTasks = const Value.absent(),
  }) : ideaTitle = Value(ideaTitle);
  static Insertable<Idea> custom({
    Expression<int>? uniqueId,
    Expression<String>? ideaTitle,
    Expression<String?>? moreDetails,
    Expression<String?>? completedTasks,
    Expression<String?>? uncompletedTasks,
  }) {
    return RawValuesInsertable({
      if (uniqueId != null) 'unique_id': uniqueId,
      if (ideaTitle != null) 'idea_title': ideaTitle,
      if (moreDetails != null) 'more_details': moreDetails,
      if (completedTasks != null) 'completed_tasks': completedTasks,
      if (uncompletedTasks != null) 'uncompleted_tasks': uncompletedTasks,
    });
  }

  IdeasCompanion copyWith(
      {Value<int>? uniqueId,
      Value<String>? ideaTitle,
      Value<String?>? moreDetails,
      Value<String?>? completedTasks,
      Value<String?>? uncompletedTasks}) {
    return IdeasCompanion(
      uniqueId: uniqueId ?? this.uniqueId,
      ideaTitle: ideaTitle ?? this.ideaTitle,
      moreDetails: moreDetails ?? this.moreDetails,
      completedTasks: completedTasks ?? this.completedTasks,
      uncompletedTasks: uncompletedTasks ?? this.uncompletedTasks,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uniqueId.present) {
      map['unique_id'] = Variable<int>(uniqueId.value);
    }
    if (ideaTitle.present) {
      map['idea_title'] = Variable<String>(ideaTitle.value);
    }
    if (moreDetails.present) {
      map['more_details'] = Variable<String?>(moreDetails.value);
    }
    if (completedTasks.present) {
      map['completed_tasks'] = Variable<String?>(completedTasks.value);
    }
    if (uncompletedTasks.present) {
      map['uncompleted_tasks'] = Variable<String?>(uncompletedTasks.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdeasCompanion(')
          ..write('uniqueId: $uniqueId, ')
          ..write('ideaTitle: $ideaTitle, ')
          ..write('moreDetails: $moreDetails, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('uncompletedTasks: $uncompletedTasks')
          ..write(')'))
        .toString();
  }
}

class $IdeasTable extends Ideas with TableInfo<$IdeasTable, Idea> {
  final GeneratedDatabase _db;
  final String? _alias;
  $IdeasTable(this._db, [this._alias]);
  final VerificationMeta _uniqueIdMeta = const VerificationMeta('uniqueId');
  @override
  late final GeneratedIntColumn uniqueId = _constructUniqueId();
  GeneratedIntColumn _constructUniqueId() {
    return GeneratedIntColumn('unique_id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _ideaTitleMeta = const VerificationMeta('ideaTitle');
  @override
  late final GeneratedTextColumn ideaTitle = _constructIdeaTitle();
  GeneratedTextColumn _constructIdeaTitle() {
    return GeneratedTextColumn(
      'idea_title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _moreDetailsMeta =
      const VerificationMeta('moreDetails');
  @override
  late final GeneratedTextColumn moreDetails = _constructMoreDetails();
  GeneratedTextColumn _constructMoreDetails() {
    return GeneratedTextColumn(
      'more_details',
      $tableName,
      true,
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
      true,
    );
  }

  final VerificationMeta _uncompletedTasksMeta =
      const VerificationMeta('uncompletedTasks');
  @override
  late final GeneratedTextColumn uncompletedTasks =
      _constructUncompletedTasks();
  GeneratedTextColumn _constructUncompletedTasks() {
    return GeneratedTextColumn(
      'uncompleted_tasks',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [uniqueId, ideaTitle, moreDetails, completedTasks, uncompletedTasks];
  @override
  $IdeasTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'ideas';
  @override
  final String actualTableName = 'ideas';
  @override
  VerificationContext validateIntegrity(Insertable<Idea> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unique_id')) {
      context.handle(_uniqueIdMeta,
          uniqueId.isAcceptableOrUnknown(data['unique_id']!, _uniqueIdMeta));
    }
    if (data.containsKey('idea_title')) {
      context.handle(_ideaTitleMeta,
          ideaTitle.isAcceptableOrUnknown(data['idea_title']!, _ideaTitleMeta));
    } else if (isInserting) {
      context.missing(_ideaTitleMeta);
    }
    if (data.containsKey('more_details')) {
      context.handle(
          _moreDetailsMeta,
          moreDetails.isAcceptableOrUnknown(
              data['more_details']!, _moreDetailsMeta));
    }
    if (data.containsKey('completed_tasks')) {
      context.handle(
          _completedTasksMeta,
          completedTasks.isAcceptableOrUnknown(
              data['completed_tasks']!, _completedTasksMeta));
    }
    if (data.containsKey('uncompleted_tasks')) {
      context.handle(
          _uncompletedTasksMeta,
          uncompletedTasks.isAcceptableOrUnknown(
              data['uncompleted_tasks']!, _uncompletedTasksMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uniqueId};
  @override
  Idea map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Idea.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $IdeasTable createAlias(String alias) {
    return $IdeasTable(_db, alias);
  }
}

abstract class _$IdealogDb extends GeneratedDatabase {
  _$IdealogDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $IdeasTable ideas = $IdeasTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [ideas];
}
