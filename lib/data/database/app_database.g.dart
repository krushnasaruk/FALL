// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 250),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('medium'));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _hasDueTimeMeta =
      const VerificationMeta('hasDueTime');
  @override
  late final GeneratedColumn<bool> hasDueTime = GeneratedColumn<bool>(
      'has_due_time', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_due_time" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reminderAtMeta =
      const VerificationMeta('reminderAt');
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
      'reminder_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _skillIdMeta =
      const VerificationMeta('skillId');
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
      'skill_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _estimatedMinutesMeta =
      const VerificationMeta('estimatedMinutes');
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
      'estimated_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _actualMinutesMeta =
      const VerificationMeta('actualMinutes');
  @override
  late final GeneratedColumn<int> actualMinutes = GeneratedColumn<int>(
      'actual_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _recurrenceMeta =
      const VerificationMeta('recurrence');
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
      'recurrence', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('none'));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        priority,
        dueDate,
        hasDueTime,
        reminderAt,
        projectId,
        skillId,
        estimatedMinutes,
        actualMinutes,
        recurrence,
        tags,
        isCompleted,
        completedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<TaskEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('has_due_time')) {
      context.handle(
          _hasDueTimeMeta,
          hasDueTime.isAcceptableOrUnknown(
              data['has_due_time']!, _hasDueTimeMeta));
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
          _reminderAtMeta,
          reminderAt.isAcceptableOrUnknown(
              data['reminder_at']!, _reminderAtMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('skill_id')) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta));
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
          _estimatedMinutesMeta,
          estimatedMinutes.isAcceptableOrUnknown(
              data['estimated_minutes']!, _estimatedMinutesMeta));
    }
    if (data.containsKey('actual_minutes')) {
      context.handle(
          _actualMinutesMeta,
          actualMinutes.isAcceptableOrUnknown(
              data['actual_minutes']!, _actualMinutesMeta));
    }
    if (data.containsKey('recurrence')) {
      context.handle(
          _recurrenceMeta,
          recurrence.isAcceptableOrUnknown(
              data['recurrence']!, _recurrenceMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      hasDueTime: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_due_time'])!,
      reminderAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reminder_at']),
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      skillId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skill_id']),
      estimatedMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estimated_minutes'])!,
      actualMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actual_minutes'])!,
      recurrence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskEntry extends DataClass implements Insertable<TaskEntry> {
  final String id;
  final String title;
  final String? description;
  final String priority;
  final DateTime? dueDate;
  final bool hasDueTime;
  final DateTime? reminderAt;
  final String? projectId;
  final String? skillId;
  final int estimatedMinutes;
  final int actualMinutes;
  final String recurrence;
  final String tags;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskEntry(
      {required this.id,
      required this.title,
      this.description,
      required this.priority,
      this.dueDate,
      required this.hasDueTime,
      this.reminderAt,
      this.projectId,
      this.skillId,
      required this.estimatedMinutes,
      required this.actualMinutes,
      required this.recurrence,
      required this.tags,
      required this.isCompleted,
      this.completedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['has_due_time'] = Variable<bool>(hasDueTime);
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || skillId != null) {
      map['skill_id'] = Variable<String>(skillId);
    }
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['actual_minutes'] = Variable<int>(actualMinutes);
    map['recurrence'] = Variable<String>(recurrence);
    map['tags'] = Variable<String>(tags);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      priority: Value(priority),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      hasDueTime: Value(hasDueTime),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      skillId: skillId == null && nullToAbsent
          ? const Value.absent()
          : Value(skillId),
      estimatedMinutes: Value(estimatedMinutes),
      actualMinutes: Value(actualMinutes),
      recurrence: Value(recurrence),
      tags: Value(tags),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      priority: serializer.fromJson<String>(json['priority']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      hasDueTime: serializer.fromJson<bool>(json['hasDueTime']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      skillId: serializer.fromJson<String?>(json['skillId']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      actualMinutes: serializer.fromJson<int>(json['actualMinutes']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      tags: serializer.fromJson<String>(json['tags']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'priority': serializer.toJson<String>(priority),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'hasDueTime': serializer.toJson<bool>(hasDueTime),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'projectId': serializer.toJson<String?>(projectId),
      'skillId': serializer.toJson<String?>(skillId),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'actualMinutes': serializer.toJson<int>(actualMinutes),
      'recurrence': serializer.toJson<String>(recurrence),
      'tags': serializer.toJson<String>(tags),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskEntry copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? priority,
          Value<DateTime?> dueDate = const Value.absent(),
          bool? hasDueTime,
          Value<DateTime?> reminderAt = const Value.absent(),
          Value<String?> projectId = const Value.absent(),
          Value<String?> skillId = const Value.absent(),
          int? estimatedMinutes,
          int? actualMinutes,
          String? recurrence,
          String? tags,
          bool? isCompleted,
          Value<DateTime?> completedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TaskEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        priority: priority ?? this.priority,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        hasDueTime: hasDueTime ?? this.hasDueTime,
        reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
        projectId: projectId.present ? projectId.value : this.projectId,
        skillId: skillId.present ? skillId.value : this.skillId,
        estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
        actualMinutes: actualMinutes ?? this.actualMinutes,
        recurrence: recurrence ?? this.recurrence,
        tags: tags ?? this.tags,
        isCompleted: isCompleted ?? this.isCompleted,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TaskEntry copyWithCompanion(TasksCompanion data) {
    return TaskEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      hasDueTime:
          data.hasDueTime.present ? data.hasDueTime.value : this.hasDueTime,
      reminderAt:
          data.reminderAt.present ? data.reminderAt.value : this.reminderAt,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      actualMinutes: data.actualMinutes.present
          ? data.actualMinutes.value
          : this.actualMinutes,
      recurrence:
          data.recurrence.present ? data.recurrence.value : this.recurrence,
      tags: data.tags.present ? data.tags.value : this.tags,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('hasDueTime: $hasDueTime, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('projectId: $projectId, ')
          ..write('skillId: $skillId, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('recurrence: $recurrence, ')
          ..write('tags: $tags, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      priority,
      dueDate,
      hasDueTime,
      reminderAt,
      projectId,
      skillId,
      estimatedMinutes,
      actualMinutes,
      recurrence,
      tags,
      isCompleted,
      completedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.priority == this.priority &&
          other.dueDate == this.dueDate &&
          other.hasDueTime == this.hasDueTime &&
          other.reminderAt == this.reminderAt &&
          other.projectId == this.projectId &&
          other.skillId == this.skillId &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.actualMinutes == this.actualMinutes &&
          other.recurrence == this.recurrence &&
          other.tags == this.tags &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<TaskEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> priority;
  final Value<DateTime?> dueDate;
  final Value<bool> hasDueTime;
  final Value<DateTime?> reminderAt;
  final Value<String?> projectId;
  final Value<String?> skillId;
  final Value<int> estimatedMinutes;
  final Value<int> actualMinutes;
  final Value<String> recurrence;
  final Value<String> tags;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.hasDueTime = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.skillId = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.actualMinutes = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.tags = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.hasDueTime = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.skillId = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.actualMinutes = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.tags = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TaskEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? priority,
    Expression<DateTime>? dueDate,
    Expression<bool>? hasDueTime,
    Expression<DateTime>? reminderAt,
    Expression<String>? projectId,
    Expression<String>? skillId,
    Expression<int>? estimatedMinutes,
    Expression<int>? actualMinutes,
    Expression<String>? recurrence,
    Expression<String>? tags,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (hasDueTime != null) 'has_due_time': hasDueTime,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (projectId != null) 'project_id': projectId,
      if (skillId != null) 'skill_id': skillId,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (actualMinutes != null) 'actual_minutes': actualMinutes,
      if (recurrence != null) 'recurrence': recurrence,
      if (tags != null) 'tags': tags,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? priority,
      Value<DateTime?>? dueDate,
      Value<bool>? hasDueTime,
      Value<DateTime?>? reminderAt,
      Value<String?>? projectId,
      Value<String?>? skillId,
      Value<int>? estimatedMinutes,
      Value<int>? actualMinutes,
      Value<String>? recurrence,
      Value<String>? tags,
      Value<bool>? isCompleted,
      Value<DateTime?>? completedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      hasDueTime: hasDueTime ?? this.hasDueTime,
      reminderAt: reminderAt ?? this.reminderAt,
      projectId: projectId ?? this.projectId,
      skillId: skillId ?? this.skillId,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      recurrence: recurrence ?? this.recurrence,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (hasDueTime.present) {
      map['has_due_time'] = Variable<bool>(hasDueTime.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (actualMinutes.present) {
      map['actual_minutes'] = Variable<int>(actualMinutes.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('hasDueTime: $hasDueTime, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('projectId: $projectId, ')
          ..write('skillId: $skillId, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('recurrence: $recurrence, ')
          ..write('tags: $tags, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtasksTable extends Subtasks
    with TableInfo<$SubtasksTable, SubtaskEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES tasks (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 250),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, title, isCompleted, orderIndex, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtasks';
  @override
  VerificationContext validateIntegrity(Insertable<SubtaskEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubtaskEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubtaskEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SubtasksTable createAlias(String alias) {
    return $SubtasksTable(attachedDatabase, alias);
  }
}

class SubtaskEntry extends DataClass implements Insertable<SubtaskEntry> {
  final String id;
  final String taskId;
  final String title;
  final bool isCompleted;
  final int orderIndex;
  final DateTime createdAt;
  const SubtaskEntry(
      {required this.id,
      required this.taskId,
      required this.title,
      required this.isCompleted,
      required this.orderIndex,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['title'] = Variable<String>(title);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SubtasksCompanion toCompanion(bool nullToAbsent) {
    return SubtasksCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      isCompleted: Value(isCompleted),
      orderIndex: Value(orderIndex),
      createdAt: Value(createdAt),
    );
  }

  factory SubtaskEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubtaskEntry(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SubtaskEntry copyWith(
          {String? id,
          String? taskId,
          String? title,
          bool? isCompleted,
          int? orderIndex,
          DateTime? createdAt}) =>
      SubtaskEntry(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
        orderIndex: orderIndex ?? this.orderIndex,
        createdAt: createdAt ?? this.createdAt,
      );
  SubtaskEntry copyWithCompanion(SubtasksCompanion data) {
    return SubtaskEntry(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubtaskEntry(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, title, isCompleted, orderIndex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubtaskEntry &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.isCompleted == this.isCompleted &&
          other.orderIndex == this.orderIndex &&
          other.createdAt == this.createdAt);
}

class SubtasksCompanion extends UpdateCompanion<SubtaskEntry> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<bool> isCompleted;
  final Value<int> orderIndex;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SubtasksCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtasksCompanion.insert({
    required String id,
    required String taskId,
    required String title,
    this.isCompleted = const Value.absent(),
    this.orderIndex = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<SubtaskEntry> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<bool>? isCompleted,
    Expression<int>? orderIndex,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? title,
      Value<bool>? isCompleted,
      Value<int>? orderIndex,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SubtasksCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtasksCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Development'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('medium'));
  static const VerificationMeta _techStackMeta =
      const VerificationMeta('techStack');
  @override
  late final GeneratedColumn<String> techStack = GeneratedColumn<String>(
      'tech_stack', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _repositoryUrlMeta =
      const VerificationMeta('repositoryUrl');
  @override
  late final GeneratedColumn<String> repositoryUrl = GeneratedColumn<String>(
      'repository_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timeSpentMinutesMeta =
      const VerificationMeta('timeSpentMinutes');
  @override
  late final GeneratedColumn<int> timeSpentMinutes = GeneratedColumn<int>(
      'time_spent_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        category,
        startDate,
        targetDate,
        status,
        priority,
        techStack,
        repositoryUrl,
        notes,
        timeSpentMinutes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('tech_stack')) {
      context.handle(_techStackMeta,
          techStack.isAcceptableOrUnknown(data['tech_stack']!, _techStackMeta));
    }
    if (data.containsKey('repository_url')) {
      context.handle(
          _repositoryUrlMeta,
          repositoryUrl.isAcceptableOrUnknown(
              data['repository_url']!, _repositoryUrlMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('time_spent_minutes')) {
      context.handle(
          _timeSpentMinutesMeta,
          timeSpentMinutes.isAcceptableOrUnknown(
              data['time_spent_minutes']!, _timeSpentMinutesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      techStack: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tech_stack'])!,
      repositoryUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repository_url']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      timeSpentMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}time_spent_minutes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectEntry extends DataClass implements Insertable<ProjectEntry> {
  final String id;
  final String name;
  final String? description;
  final String category;
  final DateTime startDate;
  final DateTime? targetDate;
  final String status;
  final String priority;
  final String techStack;
  final String? repositoryUrl;
  final String? notes;
  final int timeSpentMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProjectEntry(
      {required this.id,
      required this.name,
      this.description,
      required this.category,
      required this.startDate,
      this.targetDate,
      required this.status,
      required this.priority,
      required this.techStack,
      this.repositoryUrl,
      this.notes,
      required this.timeSpentMinutes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    map['tech_stack'] = Variable<String>(techStack);
    if (!nullToAbsent || repositoryUrl != null) {
      map['repository_url'] = Variable<String>(repositoryUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['time_spent_minutes'] = Variable<int>(timeSpentMinutes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      startDate: Value(startDate),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      status: Value(status),
      priority: Value(priority),
      techStack: Value(techStack),
      repositoryUrl: repositoryUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(repositoryUrl),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      timeSpentMinutes: Value(timeSpentMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProjectEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      techStack: serializer.fromJson<String>(json['techStack']),
      repositoryUrl: serializer.fromJson<String?>(json['repositoryUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      timeSpentMinutes: serializer.fromJson<int>(json['timeSpentMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'startDate': serializer.toJson<DateTime>(startDate),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'techStack': serializer.toJson<String>(techStack),
      'repositoryUrl': serializer.toJson<String?>(repositoryUrl),
      'notes': serializer.toJson<String?>(notes),
      'timeSpentMinutes': serializer.toJson<int>(timeSpentMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProjectEntry copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          String? category,
          DateTime? startDate,
          Value<DateTime?> targetDate = const Value.absent(),
          String? status,
          String? priority,
          String? techStack,
          Value<String?> repositoryUrl = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          int? timeSpentMinutes,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ProjectEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        category: category ?? this.category,
        startDate: startDate ?? this.startDate,
        targetDate: targetDate.present ? targetDate.value : this.targetDate,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        techStack: techStack ?? this.techStack,
        repositoryUrl:
            repositoryUrl.present ? repositoryUrl.value : this.repositoryUrl,
        notes: notes.present ? notes.value : this.notes,
        timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProjectEntry copyWithCompanion(ProjectsCompanion data) {
    return ProjectEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      techStack: data.techStack.present ? data.techStack.value : this.techStack,
      repositoryUrl: data.repositoryUrl.present
          ? data.repositoryUrl.value
          : this.repositoryUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      timeSpentMinutes: data.timeSpentMinutes.present
          ? data.timeSpentMinutes.value
          : this.timeSpentMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('startDate: $startDate, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('techStack: $techStack, ')
          ..write('repositoryUrl: $repositoryUrl, ')
          ..write('notes: $notes, ')
          ..write('timeSpentMinutes: $timeSpentMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      category,
      startDate,
      targetDate,
      status,
      priority,
      techStack,
      repositoryUrl,
      notes,
      timeSpentMinutes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.startDate == this.startDate &&
          other.targetDate == this.targetDate &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.techStack == this.techStack &&
          other.repositoryUrl == this.repositoryUrl &&
          other.notes == this.notes &&
          other.timeSpentMinutes == this.timeSpentMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<ProjectEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> category;
  final Value<DateTime> startDate;
  final Value<DateTime?> targetDate;
  final Value<String> status;
  final Value<String> priority;
  final Value<String> techStack;
  final Value<String?> repositoryUrl;
  final Value<String?> notes;
  final Value<int> timeSpentMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.startDate = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.techStack = const Value.absent(),
    this.repositoryUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.timeSpentMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    required DateTime startDate,
    this.targetDate = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.techStack = const Value.absent(),
    this.repositoryUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.timeSpentMinutes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        startDate = Value(startDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ProjectEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<DateTime>? startDate,
    Expression<DateTime>? targetDate,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<String>? techStack,
    Expression<String>? repositoryUrl,
    Expression<String>? notes,
    Expression<int>? timeSpentMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (startDate != null) 'start_date': startDate,
      if (targetDate != null) 'target_date': targetDate,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (techStack != null) 'tech_stack': techStack,
      if (repositoryUrl != null) 'repository_url': repositoryUrl,
      if (notes != null) 'notes': notes,
      if (timeSpentMinutes != null) 'time_spent_minutes': timeSpentMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? category,
      Value<DateTime>? startDate,
      Value<DateTime?>? targetDate,
      Value<String>? status,
      Value<String>? priority,
      Value<String>? techStack,
      Value<String?>? repositoryUrl,
      Value<String?>? notes,
      Value<int>? timeSpentMinutes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      techStack: techStack ?? this.techStack,
      repositoryUrl: repositoryUrl ?? this.repositoryUrl,
      notes: notes ?? this.notes,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (techStack.present) {
      map['tech_stack'] = Variable<String>(techStack.value);
    }
    if (repositoryUrl.present) {
      map['repository_url'] = Variable<String>(repositoryUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (timeSpentMinutes.present) {
      map['time_spent_minutes'] = Variable<int>(timeSpentMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('startDate: $startDate, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('techStack: $techStack, ')
          ..write('repositoryUrl: $repositoryUrl, ')
          ..write('notes: $notes, ')
          ..write('timeSpentMinutes: $timeSpentMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MilestonesTable extends Milestones
    with TableInfo<$MilestonesTable, MilestoneEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 250),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        title,
        description,
        targetDate,
        isCompleted,
        completedAt,
        orderIndex
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milestones';
  @override
  VerificationContext validateIntegrity(Insertable<MilestoneEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MilestoneEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilestoneEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $MilestonesTable createAlias(String alias) {
    return $MilestonesTable(attachedDatabase, alias);
  }
}

class MilestoneEntry extends DataClass implements Insertable<MilestoneEntry> {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final DateTime? targetDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final int orderIndex;
  const MilestoneEntry(
      {required this.id,
      required this.projectId,
      required this.title,
      this.description,
      this.targetDate,
      required this.isCompleted,
      this.completedAt,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  MilestonesCompanion toCompanion(bool nullToAbsent) {
    return MilestonesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      orderIndex: Value(orderIndex),
    );
  }

  factory MilestoneEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilestoneEntry(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  MilestoneEntry copyWith(
          {String? id,
          String? projectId,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> targetDate = const Value.absent(),
          bool? isCompleted,
          Value<DateTime?> completedAt = const Value.absent(),
          int? orderIndex}) =>
      MilestoneEntry(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        targetDate: targetDate.present ? targetDate.value : this.targetDate,
        isCompleted: isCompleted ?? this.isCompleted,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  MilestoneEntry copyWithCompanion(MilestonesCompanion data) {
    return MilestoneEntry(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilestoneEntry(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('targetDate: $targetDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, title, description, targetDate,
      isCompleted, completedAt, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilestoneEntry &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.description == this.description &&
          other.targetDate == this.targetDate &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.orderIndex == this.orderIndex);
}

class MilestonesCompanion extends UpdateCompanion<MilestoneEntry> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> targetDate;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const MilestonesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MilestonesCompanion.insert({
    required String id,
    required String projectId,
    required String title,
    this.description = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projectId = Value(projectId),
        title = Value(title);
  static Insertable<MilestoneEntry> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? targetDate,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (targetDate != null) 'target_date': targetDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MilestonesCompanion copyWith(
      {Value<String>? id,
      Value<String>? projectId,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime?>? targetDate,
      Value<bool>? isCompleted,
      Value<DateTime?>? completedAt,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return MilestonesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilestonesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('targetDate: $targetDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SkillsTable extends Skills with TableInfo<$SkillsTable, SkillEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('General'));
  static const VerificationMeta _currentLevelMeta =
      const VerificationMeta('currentLevel');
  @override
  late final GeneratedColumn<String> currentLevel = GeneratedColumn<String>(
      'current_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('beginner'));
  static const VerificationMeta _targetLevelMeta =
      const VerificationMeta('targetLevel');
  @override
  late final GeneratedColumn<String> targetLevel = GeneratedColumn<String>(
      'target_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('intermediate'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _learningMinutesMeta =
      const VerificationMeta('learningMinutes');
  @override
  late final GeneratedColumn<int> learningMinutes = GeneratedColumn<int>(
      'learning_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        currentLevel,
        targetLevel,
        notes,
        learningMinutes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skills';
  @override
  VerificationContext validateIntegrity(Insertable<SkillEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('current_level')) {
      context.handle(
          _currentLevelMeta,
          currentLevel.isAcceptableOrUnknown(
              data['current_level']!, _currentLevelMeta));
    }
    if (data.containsKey('target_level')) {
      context.handle(
          _targetLevelMeta,
          targetLevel.isAcceptableOrUnknown(
              data['target_level']!, _targetLevelMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('learning_minutes')) {
      context.handle(
          _learningMinutesMeta,
          learningMinutes.isAcceptableOrUnknown(
              data['learning_minutes']!, _learningMinutesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SkillEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkillEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      currentLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_level'])!,
      targetLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_level'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      learningMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}learning_minutes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SkillsTable createAlias(String alias) {
    return $SkillsTable(attachedDatabase, alias);
  }
}

class SkillEntry extends DataClass implements Insertable<SkillEntry> {
  final String id;
  final String name;
  final String category;
  final String currentLevel;
  final String targetLevel;
  final String? notes;
  final int learningMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SkillEntry(
      {required this.id,
      required this.name,
      required this.category,
      required this.currentLevel,
      required this.targetLevel,
      this.notes,
      required this.learningMinutes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['current_level'] = Variable<String>(currentLevel);
    map['target_level'] = Variable<String>(targetLevel);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['learning_minutes'] = Variable<int>(learningMinutes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SkillsCompanion toCompanion(bool nullToAbsent) {
    return SkillsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      currentLevel: Value(currentLevel),
      targetLevel: Value(targetLevel),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      learningMinutes: Value(learningMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SkillEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkillEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      currentLevel: serializer.fromJson<String>(json['currentLevel']),
      targetLevel: serializer.fromJson<String>(json['targetLevel']),
      notes: serializer.fromJson<String?>(json['notes']),
      learningMinutes: serializer.fromJson<int>(json['learningMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'currentLevel': serializer.toJson<String>(currentLevel),
      'targetLevel': serializer.toJson<String>(targetLevel),
      'notes': serializer.toJson<String?>(notes),
      'learningMinutes': serializer.toJson<int>(learningMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SkillEntry copyWith(
          {String? id,
          String? name,
          String? category,
          String? currentLevel,
          String? targetLevel,
          Value<String?> notes = const Value.absent(),
          int? learningMinutes,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SkillEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        currentLevel: currentLevel ?? this.currentLevel,
        targetLevel: targetLevel ?? this.targetLevel,
        notes: notes.present ? notes.value : this.notes,
        learningMinutes: learningMinutes ?? this.learningMinutes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SkillEntry copyWithCompanion(SkillsCompanion data) {
    return SkillEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      currentLevel: data.currentLevel.present
          ? data.currentLevel.value
          : this.currentLevel,
      targetLevel:
          data.targetLevel.present ? data.targetLevel.value : this.targetLevel,
      notes: data.notes.present ? data.notes.value : this.notes,
      learningMinutes: data.learningMinutes.present
          ? data.learningMinutes.value
          : this.learningMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkillEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('targetLevel: $targetLevel, ')
          ..write('notes: $notes, ')
          ..write('learningMinutes: $learningMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, currentLevel, targetLevel,
      notes, learningMinutes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkillEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.currentLevel == this.currentLevel &&
          other.targetLevel == this.targetLevel &&
          other.notes == this.notes &&
          other.learningMinutes == this.learningMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SkillsCompanion extends UpdateCompanion<SkillEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> currentLevel;
  final Value<String> targetLevel;
  final Value<String?> notes;
  final Value<int> learningMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SkillsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.targetLevel = const Value.absent(),
    this.notes = const Value.absent(),
    this.learningMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SkillsCompanion.insert({
    required String id,
    required String name,
    this.category = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.targetLevel = const Value.absent(),
    this.notes = const Value.absent(),
    this.learningMinutes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SkillEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? currentLevel,
    Expression<String>? targetLevel,
    Expression<String>? notes,
    Expression<int>? learningMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (currentLevel != null) 'current_level': currentLevel,
      if (targetLevel != null) 'target_level': targetLevel,
      if (notes != null) 'notes': notes,
      if (learningMinutes != null) 'learning_minutes': learningMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SkillsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? category,
      Value<String>? currentLevel,
      Value<String>? targetLevel,
      Value<String?>? notes,
      Value<int>? learningMinutes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SkillsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      currentLevel: currentLevel ?? this.currentLevel,
      targetLevel: targetLevel ?? this.targetLevel,
      notes: notes ?? this.notes,
      learningMinutes: learningMinutes ?? this.learningMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (currentLevel.present) {
      map['current_level'] = Variable<String>(currentLevel.value);
    }
    if (targetLevel.present) {
      map['target_level'] = Variable<String>(targetLevel.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (learningMinutes.present) {
      map['learning_minutes'] = Variable<int>(learningMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkillsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('targetLevel: $targetLevel, ')
          ..write('notes: $notes, ')
          ..write('learningMinutes: $learningMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearningModulesTable extends LearningModules
    with TableInfo<$LearningModulesTable, LearningModuleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningModulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _skillIdMeta =
      const VerificationMeta('skillId');
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
      'skill_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES skills (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, skillId, title, description, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_modules';
  @override
  VerificationContext validateIntegrity(
      Insertable<LearningModuleEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('skill_id')) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta));
    } else if (isInserting) {
      context.missing(_skillIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningModuleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningModuleEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      skillId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skill_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $LearningModulesTable createAlias(String alias) {
    return $LearningModulesTable(attachedDatabase, alias);
  }
}

class LearningModuleEntry extends DataClass
    implements Insertable<LearningModuleEntry> {
  final String id;
  final String skillId;
  final String title;
  final String? description;
  final int orderIndex;
  const LearningModuleEntry(
      {required this.id,
      required this.skillId,
      required this.title,
      this.description,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['skill_id'] = Variable<String>(skillId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  LearningModulesCompanion toCompanion(bool nullToAbsent) {
    return LearningModulesCompanion(
      id: Value(id),
      skillId: Value(skillId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      orderIndex: Value(orderIndex),
    );
  }

  factory LearningModuleEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningModuleEntry(
      id: serializer.fromJson<String>(json['id']),
      skillId: serializer.fromJson<String>(json['skillId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'skillId': serializer.toJson<String>(skillId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  LearningModuleEntry copyWith(
          {String? id,
          String? skillId,
          String? title,
          Value<String?> description = const Value.absent(),
          int? orderIndex}) =>
      LearningModuleEntry(
        id: id ?? this.id,
        skillId: skillId ?? this.skillId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  LearningModuleEntry copyWithCompanion(LearningModulesCompanion data) {
    return LearningModuleEntry(
      id: data.id.present ? data.id.value : this.id,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningModuleEntry(')
          ..write('id: $id, ')
          ..write('skillId: $skillId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, skillId, title, description, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningModuleEntry &&
          other.id == this.id &&
          other.skillId == this.skillId &&
          other.title == this.title &&
          other.description == this.description &&
          other.orderIndex == this.orderIndex);
}

class LearningModulesCompanion extends UpdateCompanion<LearningModuleEntry> {
  final Value<String> id;
  final Value<String> skillId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const LearningModulesCompanion({
    this.id = const Value.absent(),
    this.skillId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningModulesCompanion.insert({
    required String id,
    required String skillId,
    required String title,
    this.description = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        skillId = Value(skillId),
        title = Value(title);
  static Insertable<LearningModuleEntry> custom({
    Expression<String>? id,
    Expression<String>? skillId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (skillId != null) 'skill_id': skillId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningModulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? skillId,
      Value<String>? title,
      Value<String?>? description,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return LearningModulesCompanion(
      id: id ?? this.id,
      skillId: skillId ?? this.skillId,
      title: title ?? this.title,
      description: description ?? this.description,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningModulesCompanion(')
          ..write('id: $id, ')
          ..write('skillId: $skillId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearningTopicsTable extends LearningTopics
    with TableInfo<$LearningTopicsTable, LearningTopicEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningTopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moduleIdMeta =
      const VerificationMeta('moduleId');
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
      'module_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES learning_modules (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('planned'));
  static const VerificationMeta _resourcesMeta =
      const VerificationMeta('resources');
  @override
  late final GeneratedColumn<String> resources = GeneratedColumn<String>(
      'resources', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, moduleId, title, status, resources, notes, orderIndex, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_topics';
  @override
  VerificationContext validateIntegrity(Insertable<LearningTopicEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(_moduleIdMeta,
          moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta));
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('resources')) {
      context.handle(_resourcesMeta,
          resources.isAcceptableOrUnknown(data['resources']!, _resourcesMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningTopicEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningTopicEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      moduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      resources: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resources'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $LearningTopicsTable createAlias(String alias) {
    return $LearningTopicsTable(attachedDatabase, alias);
  }
}

class LearningTopicEntry extends DataClass
    implements Insertable<LearningTopicEntry> {
  final String id;
  final String moduleId;
  final String title;
  final String status;
  final String resources;
  final String? notes;
  final int orderIndex;
  final DateTime? completedAt;
  const LearningTopicEntry(
      {required this.id,
      required this.moduleId,
      required this.title,
      required this.status,
      required this.resources,
      this.notes,
      required this.orderIndex,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['module_id'] = Variable<String>(moduleId);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['resources'] = Variable<String>(resources);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  LearningTopicsCompanion toCompanion(bool nullToAbsent) {
    return LearningTopicsCompanion(
      id: Value(id),
      moduleId: Value(moduleId),
      title: Value(title),
      status: Value(status),
      resources: Value(resources),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      orderIndex: Value(orderIndex),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory LearningTopicEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningTopicEntry(
      id: serializer.fromJson<String>(json['id']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      resources: serializer.fromJson<String>(json['resources']),
      notes: serializer.fromJson<String?>(json['notes']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'moduleId': serializer.toJson<String>(moduleId),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'resources': serializer.toJson<String>(resources),
      'notes': serializer.toJson<String?>(notes),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  LearningTopicEntry copyWith(
          {String? id,
          String? moduleId,
          String? title,
          String? status,
          String? resources,
          Value<String?> notes = const Value.absent(),
          int? orderIndex,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      LearningTopicEntry(
        id: id ?? this.id,
        moduleId: moduleId ?? this.moduleId,
        title: title ?? this.title,
        status: status ?? this.status,
        resources: resources ?? this.resources,
        notes: notes.present ? notes.value : this.notes,
        orderIndex: orderIndex ?? this.orderIndex,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  LearningTopicEntry copyWithCompanion(LearningTopicsCompanion data) {
    return LearningTopicEntry(
      id: data.id.present ? data.id.value : this.id,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      resources: data.resources.present ? data.resources.value : this.resources,
      notes: data.notes.present ? data.notes.value : this.notes,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningTopicEntry(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('resources: $resources, ')
          ..write('notes: $notes, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, moduleId, title, status, resources, notes, orderIndex, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningTopicEntry &&
          other.id == this.id &&
          other.moduleId == this.moduleId &&
          other.title == this.title &&
          other.status == this.status &&
          other.resources == this.resources &&
          other.notes == this.notes &&
          other.orderIndex == this.orderIndex &&
          other.completedAt == this.completedAt);
}

class LearningTopicsCompanion extends UpdateCompanion<LearningTopicEntry> {
  final Value<String> id;
  final Value<String> moduleId;
  final Value<String> title;
  final Value<String> status;
  final Value<String> resources;
  final Value<String?> notes;
  final Value<int> orderIndex;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const LearningTopicsCompanion({
    this.id = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.resources = const Value.absent(),
    this.notes = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningTopicsCompanion.insert({
    required String id,
    required String moduleId,
    required String title,
    this.status = const Value.absent(),
    this.resources = const Value.absent(),
    this.notes = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        moduleId = Value(moduleId),
        title = Value(title);
  static Insertable<LearningTopicEntry> custom({
    Expression<String>? id,
    Expression<String>? moduleId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<String>? resources,
    Expression<String>? notes,
    Expression<int>? orderIndex,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moduleId != null) 'module_id': moduleId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (resources != null) 'resources': resources,
      if (notes != null) 'notes': notes,
      if (orderIndex != null) 'order_index': orderIndex,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningTopicsCompanion copyWith(
      {Value<String>? id,
      Value<String>? moduleId,
      Value<String>? title,
      Value<String>? status,
      Value<String>? resources,
      Value<String?>? notes,
      Value<int>? orderIndex,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return LearningTopicsCompanion(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      status: status ?? this.status,
      resources: resources ?? this.resources,
      notes: notes ?? this.notes,
      orderIndex: orderIndex ?? this.orderIndex,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (resources.present) {
      map['resources'] = Variable<String>(resources.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningTopicsCompanion(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('resources: $resources, ')
          ..write('notes: $notes, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearningSessionsTable extends LearningSessions
    with TableInfo<$LearningSessionsTable, LearningSessionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _skillIdMeta =
      const VerificationMeta('skillId');
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
      'skill_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES skills (id) ON DELETE CASCADE'));
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, skillId, topicId, durationMinutes, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_sessions';
  @override
  VerificationContext validateIntegrity(
      Insertable<LearningSessionEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('skill_id')) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta));
    } else if (isInserting) {
      context.missing(_skillIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningSessionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningSessionEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      skillId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skill_id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id']),
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LearningSessionsTable createAlias(String alias) {
    return $LearningSessionsTable(attachedDatabase, alias);
  }
}

class LearningSessionEntry extends DataClass
    implements Insertable<LearningSessionEntry> {
  final String id;
  final String skillId;
  final String? topicId;
  final int durationMinutes;
  final String? notes;
  final DateTime createdAt;
  const LearningSessionEntry(
      {required this.id,
      required this.skillId,
      this.topicId,
      required this.durationMinutes,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['skill_id'] = Variable<String>(skillId);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LearningSessionsCompanion toCompanion(bool nullToAbsent) {
    return LearningSessionsCompanion(
      id: Value(id),
      skillId: Value(skillId),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      durationMinutes: Value(durationMinutes),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory LearningSessionEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningSessionEntry(
      id: serializer.fromJson<String>(json['id']),
      skillId: serializer.fromJson<String>(json['skillId']),
      topicId: serializer.fromJson<String?>(json['topicId']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'skillId': serializer.toJson<String>(skillId),
      'topicId': serializer.toJson<String?>(topicId),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LearningSessionEntry copyWith(
          {String? id,
          String? skillId,
          Value<String?> topicId = const Value.absent(),
          int? durationMinutes,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      LearningSessionEntry(
        id: id ?? this.id,
        skillId: skillId ?? this.skillId,
        topicId: topicId.present ? topicId.value : this.topicId,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  LearningSessionEntry copyWithCompanion(LearningSessionsCompanion data) {
    return LearningSessionEntry(
      id: data.id.present ? data.id.value : this.id,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningSessionEntry(')
          ..write('id: $id, ')
          ..write('skillId: $skillId, ')
          ..write('topicId: $topicId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, skillId, topicId, durationMinutes, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningSessionEntry &&
          other.id == this.id &&
          other.skillId == this.skillId &&
          other.topicId == this.topicId &&
          other.durationMinutes == this.durationMinutes &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class LearningSessionsCompanion extends UpdateCompanion<LearningSessionEntry> {
  final Value<String> id;
  final Value<String> skillId;
  final Value<String?> topicId;
  final Value<int> durationMinutes;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LearningSessionsCompanion({
    this.id = const Value.absent(),
    this.skillId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningSessionsCompanion.insert({
    required String id,
    required String skillId,
    this.topicId = const Value.absent(),
    required int durationMinutes,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        skillId = Value(skillId),
        durationMinutes = Value(durationMinutes),
        createdAt = Value(createdAt);
  static Insertable<LearningSessionEntry> custom({
    Expression<String>? id,
    Expression<String>? skillId,
    Expression<String>? topicId,
    Expression<int>? durationMinutes,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (skillId != null) 'skill_id': skillId,
      if (topicId != null) 'topic_id': topicId,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? skillId,
      Value<String?>? topicId,
      Value<int>? durationMinutes,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return LearningSessionsCompanion(
      id: id ?? this.id,
      skillId: skillId ?? this.skillId,
      topicId: topicId ?? this.topicId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningSessionsCompanion(')
          ..write('id: $id, ')
          ..write('skillId: $skillId, ')
          ..write('topicId: $topicId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('daily'));
  static const VerificationMeta _targetValueMeta =
      const VerificationMeta('targetValue');
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
      'target_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentValueMeta =
      const VerificationMeta('currentValue');
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
      'current_value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('hrs'));
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isAchievedMeta =
      const VerificationMeta('isAchieved');
  @override
  late final GeneratedColumn<bool> isAchieved = GeneratedColumn<bool>(
      'is_achieved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_achieved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        type,
        targetValue,
        currentValue,
        unit,
        deadline,
        isAchieved,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<GoalEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('target_value')) {
      context.handle(
          _targetValueMeta,
          targetValue.isAcceptableOrUnknown(
              data['target_value']!, _targetValueMeta));
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
          _currentValueMeta,
          currentValue.isAcceptableOrUnknown(
              data['current_value']!, _currentValueMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('is_achieved')) {
      context.handle(
          _isAchievedMeta,
          isAchieved.isAcceptableOrUnknown(
              data['is_achieved']!, _isAchievedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      targetValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_value'])!,
      currentValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_value'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
      isAchieved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_achieved'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class GoalEntry extends DataClass implements Insertable<GoalEntry> {
  final String id;
  final String title;
  final String? description;
  final String type;
  final double targetValue;
  final double currentValue;
  final String unit;
  final DateTime? deadline;
  final bool isAchieved;
  final DateTime createdAt;
  const GoalEntry(
      {required this.id,
      required this.title,
      this.description,
      required this.type,
      required this.targetValue,
      required this.currentValue,
      required this.unit,
      this.deadline,
      required this.isAchieved,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    map['target_value'] = Variable<double>(targetValue);
    map['current_value'] = Variable<double>(currentValue);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['is_achieved'] = Variable<bool>(isAchieved);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      targetValue: Value(targetValue),
      currentValue: Value(currentValue),
      unit: Value(unit),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      isAchieved: Value(isAchieved),
      createdAt: Value(createdAt),
    );
  }

  factory GoalEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      unit: serializer.fromJson<String>(json['unit']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      isAchieved: serializer.fromJson<bool>(json['isAchieved']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'targetValue': serializer.toJson<double>(targetValue),
      'currentValue': serializer.toJson<double>(currentValue),
      'unit': serializer.toJson<String>(unit),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'isAchieved': serializer.toJson<bool>(isAchieved),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalEntry copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? type,
          double? targetValue,
          double? currentValue,
          String? unit,
          Value<DateTime?> deadline = const Value.absent(),
          bool? isAchieved,
          DateTime? createdAt}) =>
      GoalEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        type: type ?? this.type,
        targetValue: targetValue ?? this.targetValue,
        currentValue: currentValue ?? this.currentValue,
        unit: unit ?? this.unit,
        deadline: deadline.present ? deadline.value : this.deadline,
        isAchieved: isAchieved ?? this.isAchieved,
        createdAt: createdAt ?? this.createdAt,
      );
  GoalEntry copyWithCompanion(GoalsCompanion data) {
    return GoalEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      targetValue:
          data.targetValue.present ? data.targetValue.value : this.targetValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      isAchieved:
          data.isAchieved.present ? data.isAchieved.value : this.isAchieved,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('unit: $unit, ')
          ..write('deadline: $deadline, ')
          ..write('isAchieved: $isAchieved, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, type, targetValue,
      currentValue, unit, deadline, isAchieved, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.targetValue == this.targetValue &&
          other.currentValue == this.currentValue &&
          other.unit == this.unit &&
          other.deadline == this.deadline &&
          other.isAchieved == this.isAchieved &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<GoalEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> type;
  final Value<double> targetValue;
  final Value<double> currentValue;
  final Value<String> unit;
  final Value<DateTime?> deadline;
  final Value<bool> isAchieved;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.deadline = const Value.absent(),
    this.isAchieved = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    required double targetValue,
    this.currentValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.deadline = const Value.absent(),
    this.isAchieved = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        targetValue = Value(targetValue),
        createdAt = Value(createdAt);
  static Insertable<GoalEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? type,
    Expression<double>? targetValue,
    Expression<double>? currentValue,
    Expression<String>? unit,
    Expression<DateTime>? deadline,
    Expression<bool>? isAchieved,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (targetValue != null) 'target_value': targetValue,
      if (currentValue != null) 'current_value': currentValue,
      if (unit != null) 'unit': unit,
      if (deadline != null) 'deadline': deadline,
      if (isAchieved != null) 'is_achieved': isAchieved,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? type,
      Value<double>? targetValue,
      Value<double>? currentValue,
      Value<String>? unit,
      Value<DateTime?>? deadline,
      Value<bool>? isAchieved,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return GoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      deadline: deadline ?? this.deadline,
      isAchieved: isAchieved ?? this.isAchieved,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (isAchieved.present) {
      map['is_achieved'] = Variable<bool>(isAchieved.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('unit: $unit, ')
          ..write('deadline: $deadline, ')
          ..write('isAchieved: $isAchieved, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits
    with TableInfo<$HabitsTable, HabitEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('daily'));
  static const VerificationMeta _targetDaysPerWeekMeta =
      const VerificationMeta('targetDaysPerWeek');
  @override
  late final GeneratedColumn<int> targetDaysPerWeek = GeneratedColumn<int>(
      'target_days_per_week', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(7));
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
      'reminder_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        frequency,
        targetDaysPerWeek,
        reminderTime,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(Insertable<HabitEntryRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('target_days_per_week')) {
      context.handle(
          _targetDaysPerWeekMeta,
          targetDaysPerWeek.isAcceptableOrUnknown(
              data['target_days_per_week']!, _targetDaysPerWeekMeta));
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitEntryRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      targetDaysPerWeek: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}target_days_per_week'])!,
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_time']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class HabitEntryRecord extends DataClass
    implements Insertable<HabitEntryRecord> {
  final String id;
  final String title;
  final String? description;
  final String frequency;
  final int targetDaysPerWeek;
  final String? reminderTime;
  final DateTime createdAt;
  const HabitEntryRecord(
      {required this.id,
      required this.title,
      this.description,
      required this.frequency,
      required this.targetDaysPerWeek,
      this.reminderTime,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['frequency'] = Variable<String>(frequency);
    map['target_days_per_week'] = Variable<int>(targetDaysPerWeek);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<String>(reminderTime);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      frequency: Value(frequency),
      targetDaysPerWeek: Value(targetDaysPerWeek),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      createdAt: Value(createdAt),
    );
  }

  factory HabitEntryRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitEntryRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      frequency: serializer.fromJson<String>(json['frequency']),
      targetDaysPerWeek: serializer.fromJson<int>(json['targetDaysPerWeek']),
      reminderTime: serializer.fromJson<String?>(json['reminderTime']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'frequency': serializer.toJson<String>(frequency),
      'targetDaysPerWeek': serializer.toJson<int>(targetDaysPerWeek),
      'reminderTime': serializer.toJson<String?>(reminderTime),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HabitEntryRecord copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? frequency,
          int? targetDaysPerWeek,
          Value<String?> reminderTime = const Value.absent(),
          DateTime? createdAt}) =>
      HabitEntryRecord(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        frequency: frequency ?? this.frequency,
        targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
        reminderTime:
            reminderTime.present ? reminderTime.value : this.reminderTime,
        createdAt: createdAt ?? this.createdAt,
      );
  HabitEntryRecord copyWithCompanion(HabitsCompanion data) {
    return HabitEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      targetDaysPerWeek: data.targetDaysPerWeek.present
          ? data.targetDaysPerWeek.value
          : this.targetDaysPerWeek,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntryRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('targetDaysPerWeek: $targetDaysPerWeek, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, frequency,
      targetDaysPerWeek, reminderTime, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitEntryRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.frequency == this.frequency &&
          other.targetDaysPerWeek == this.targetDaysPerWeek &&
          other.reminderTime == this.reminderTime &&
          other.createdAt == this.createdAt);
}

class HabitsCompanion extends UpdateCompanion<HabitEntryRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> frequency;
  final Value<int> targetDaysPerWeek;
  final Value<String?> reminderTime;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.frequency = const Value.absent(),
    this.targetDaysPerWeek = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.frequency = const Value.absent(),
    this.targetDaysPerWeek = const Value.absent(),
    this.reminderTime = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<HabitEntryRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? frequency,
    Expression<int>? targetDaysPerWeek,
    Expression<String>? reminderTime,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (frequency != null) 'frequency': frequency,
      if (targetDaysPerWeek != null) 'target_days_per_week': targetDaysPerWeek,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? frequency,
      Value<int>? targetDaysPerWeek,
      Value<String?>? reminderTime,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return HabitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (targetDaysPerWeek.present) {
      map['target_days_per_week'] = Variable<int>(targetDaysPerWeek.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('targetDaysPerWeek: $targetDaysPerWeek, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitEntriesTable extends HabitEntries
    with TableInfo<$HabitEntriesTable, HabitDailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _habitIdMeta =
      const VerificationMeta('habitId');
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
      'habit_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES habits (id) ON DELETE CASCADE'));
  static const VerificationMeta _dateStrMeta =
      const VerificationMeta('dateStr');
  @override
  late final GeneratedColumn<String> dateStr = GeneratedColumn<String>(
      'date_str', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, habitId, dateStr, isCompleted, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_entries';
  @override
  VerificationContext validateIntegrity(Insertable<HabitDailyLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date_str')) {
      context.handle(_dateStrMeta,
          dateStr.isAcceptableOrUnknown(data['date_str']!, _dateStrMeta));
    } else if (isInserting) {
      context.missing(_dateStrMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitDailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitDailyLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      habitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_id'])!,
      dateStr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_str'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HabitEntriesTable createAlias(String alias) {
    return $HabitEntriesTable(attachedDatabase, alias);
  }
}

class HabitDailyLog extends DataClass implements Insertable<HabitDailyLog> {
  final String id;
  final String habitId;
  final String dateStr;
  final bool isCompleted;
  final String? notes;
  final DateTime createdAt;
  const HabitDailyLog(
      {required this.id,
      required this.habitId,
      required this.dateStr,
      required this.isCompleted,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['date_str'] = Variable<String>(dateStr);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HabitEntriesCompanion toCompanion(bool nullToAbsent) {
    return HabitEntriesCompanion(
      id: Value(id),
      habitId: Value(habitId),
      dateStr: Value(dateStr),
      isCompleted: Value(isCompleted),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory HabitDailyLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitDailyLog(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      dateStr: serializer.fromJson<String>(json['dateStr']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'dateStr': serializer.toJson<String>(dateStr),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HabitDailyLog copyWith(
          {String? id,
          String? habitId,
          String? dateStr,
          bool? isCompleted,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      HabitDailyLog(
        id: id ?? this.id,
        habitId: habitId ?? this.habitId,
        dateStr: dateStr ?? this.dateStr,
        isCompleted: isCompleted ?? this.isCompleted,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  HabitDailyLog copyWithCompanion(HabitEntriesCompanion data) {
    return HabitDailyLog(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      dateStr: data.dateStr.present ? data.dateStr.value : this.dateStr,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitDailyLog(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('dateStr: $dateStr, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, habitId, dateStr, isCompleted, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitDailyLog &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.dateStr == this.dateStr &&
          other.isCompleted == this.isCompleted &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class HabitEntriesCompanion extends UpdateCompanion<HabitDailyLog> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> dateStr;
  final Value<bool> isCompleted;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HabitEntriesCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.dateStr = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitEntriesCompanion.insert({
    required String id,
    required String habitId,
    required String dateStr,
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        habitId = Value(habitId),
        dateStr = Value(dateStr),
        createdAt = Value(createdAt);
  static Insertable<HabitDailyLog> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? dateStr,
    Expression<bool>? isCompleted,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (dateStr != null) 'date_str': dateStr,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? habitId,
      Value<String>? dateStr,
      Value<bool>? isCompleted,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return HabitEntriesCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      dateStr: dateStr ?? this.dateStr,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (dateStr.present) {
      map['date_str'] = Variable<String>(dateStr.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('dateStr: $dateStr, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSessionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _skillIdMeta =
      const VerificationMeta('skillId');
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
      'skill_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sessionTypeMeta =
      const VerificationMeta('sessionType');
  @override
  late final GeneratedColumn<String> sessionType = GeneratedColumn<String>(
      'session_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pomodoro'));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskId,
        projectId,
        skillId,
        durationMinutes,
        sessionType,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<FocusSessionEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('skill_id')) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta));
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('session_type')) {
      context.handle(
          _sessionTypeMeta,
          sessionType.isAcceptableOrUnknown(
              data['session_type']!, _sessionTypeMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSessionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSessionEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id']),
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      skillId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skill_id']),
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      sessionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_type'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSessionEntry extends DataClass
    implements Insertable<FocusSessionEntry> {
  final String id;
  final String? taskId;
  final String? projectId;
  final String? skillId;
  final int durationMinutes;
  final String sessionType;
  final DateTime completedAt;
  const FocusSessionEntry(
      {required this.id,
      this.taskId,
      this.projectId,
      this.skillId,
      required this.durationMinutes,
      required this.sessionType,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || skillId != null) {
      map['skill_id'] = Variable<String>(skillId);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['session_type'] = Variable<String>(sessionType);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      skillId: skillId == null && nullToAbsent
          ? const Value.absent()
          : Value(skillId),
      durationMinutes: Value(durationMinutes),
      sessionType: Value(sessionType),
      completedAt: Value(completedAt),
    );
  }

  factory FocusSessionEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSessionEntry(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      skillId: serializer.fromJson<String?>(json['skillId']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      sessionType: serializer.fromJson<String>(json['sessionType']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'projectId': serializer.toJson<String?>(projectId),
      'skillId': serializer.toJson<String?>(skillId),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'sessionType': serializer.toJson<String>(sessionType),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  FocusSessionEntry copyWith(
          {String? id,
          Value<String?> taskId = const Value.absent(),
          Value<String?> projectId = const Value.absent(),
          Value<String?> skillId = const Value.absent(),
          int? durationMinutes,
          String? sessionType,
          DateTime? completedAt}) =>
      FocusSessionEntry(
        id: id ?? this.id,
        taskId: taskId.present ? taskId.value : this.taskId,
        projectId: projectId.present ? projectId.value : this.projectId,
        skillId: skillId.present ? skillId.value : this.skillId,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        sessionType: sessionType ?? this.sessionType,
        completedAt: completedAt ?? this.completedAt,
      );
  FocusSessionEntry copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSessionEntry(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      sessionType:
          data.sessionType.present ? data.sessionType.value : this.sessionType,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionEntry(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('projectId: $projectId, ')
          ..write('skillId: $skillId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sessionType: $sessionType, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, projectId, skillId,
      durationMinutes, sessionType, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSessionEntry &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.projectId == this.projectId &&
          other.skillId == this.skillId &&
          other.durationMinutes == this.durationMinutes &&
          other.sessionType == this.sessionType &&
          other.completedAt == this.completedAt);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSessionEntry> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<String?> projectId;
  final Value<String?> skillId;
  final Value<int> durationMinutes;
  final Value<String> sessionType;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.skillId = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.sessionType = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.skillId = const Value.absent(),
    required int durationMinutes,
    this.sessionType = const Value.absent(),
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        durationMinutes = Value(durationMinutes),
        completedAt = Value(completedAt);
  static Insertable<FocusSessionEntry> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? projectId,
    Expression<String>? skillId,
    Expression<int>? durationMinutes,
    Expression<String>? sessionType,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (projectId != null) 'project_id': projectId,
      if (skillId != null) 'skill_id': skillId,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (sessionType != null) 'session_type': sessionType,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? taskId,
      Value<String?>? projectId,
      Value<String?>? skillId,
      Value<int>? durationMinutes,
      Value<String>? sessionType,
      Value<DateTime>? completedAt,
      Value<int>? rowid}) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      projectId: projectId ?? this.projectId,
      skillId: skillId ?? this.skillId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sessionType: sessionType ?? this.sessionType,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (sessionType.present) {
      map['session_type'] = Variable<String>(sessionType.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('projectId: $projectId, ')
          ..write('skillId: $skillId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sessionType: $sessionType, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NoteEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('general'));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _skillIdMeta =
      const VerificationMeta('skillId');
  @override
  late final GeneratedColumn<String> skillId = GeneratedColumn<String>(
      'skill_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        category,
        tags,
        projectId,
        skillId,
        taskId,
        isPinned,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<NoteEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('skill_id')) {
      context.handle(_skillIdMeta,
          skillId.isAcceptableOrUnknown(data['skill_id']!, _skillIdMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      skillId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}skill_id']),
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id']),
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteEntry extends DataClass implements Insertable<NoteEntry> {
  final String id;
  final String title;
  final String content;
  final String category;
  final String tags;
  final String? projectId;
  final String? skillId;
  final String? taskId;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NoteEntry(
      {required this.id,
      required this.title,
      required this.content,
      required this.category,
      required this.tags,
      this.projectId,
      this.skillId,
      this.taskId,
      required this.isPinned,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['category'] = Variable<String>(category);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || skillId != null) {
      map['skill_id'] = Variable<String>(skillId);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      category: Value(category),
      tags: Value(tags),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      skillId: skillId == null && nullToAbsent
          ? const Value.absent()
          : Value(skillId),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      isPinned: Value(isPinned),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoteEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<String>(json['category']),
      tags: serializer.fromJson<String>(json['tags']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      skillId: serializer.fromJson<String?>(json['skillId']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<String>(category),
      'tags': serializer.toJson<String>(tags),
      'projectId': serializer.toJson<String?>(projectId),
      'skillId': serializer.toJson<String?>(skillId),
      'taskId': serializer.toJson<String?>(taskId),
      'isPinned': serializer.toJson<bool>(isPinned),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NoteEntry copyWith(
          {String? id,
          String? title,
          String? content,
          String? category,
          String? tags,
          Value<String?> projectId = const Value.absent(),
          Value<String?> skillId = const Value.absent(),
          Value<String?> taskId = const Value.absent(),
          bool? isPinned,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      NoteEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        category: category ?? this.category,
        tags: tags ?? this.tags,
        projectId: projectId.present ? projectId.value : this.projectId,
        skillId: skillId.present ? skillId.value : this.skillId,
        taskId: taskId.present ? taskId.value : this.taskId,
        isPinned: isPinned ?? this.isPinned,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  NoteEntry copyWithCompanion(NotesCompanion data) {
    return NoteEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      category: data.category.present ? data.category.value : this.category,
      tags: data.tags.present ? data.tags.value : this.tags,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      skillId: data.skillId.present ? data.skillId.value : this.skillId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('projectId: $projectId, ')
          ..write('skillId: $skillId, ')
          ..write('taskId: $taskId, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, category, tags, projectId,
      skillId, taskId, isPinned, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.category == this.category &&
          other.tags == this.tags &&
          other.projectId == this.projectId &&
          other.skillId == this.skillId &&
          other.taskId == this.taskId &&
          other.isPinned == this.isPinned &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<NoteEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> category;
  final Value<String> tags;
  final Value<String?> projectId;
  final Value<String?> skillId;
  final Value<String?> taskId;
  final Value<bool> isPinned;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.projectId = const Value.absent(),
    this.skillId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String title,
    required String content,
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.projectId = const Value.absent(),
    this.skillId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.isPinned = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        content = Value(content),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NoteEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? category,
    Expression<String>? tags,
    Expression<String>? projectId,
    Expression<String>? skillId,
    Expression<String>? taskId,
    Expression<bool>? isPinned,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (category != null) 'category': category,
      if (tags != null) 'tags': tags,
      if (projectId != null) 'project_id': projectId,
      if (skillId != null) 'skill_id': skillId,
      if (taskId != null) 'task_id': taskId,
      if (isPinned != null) 'is_pinned': isPinned,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? content,
      Value<String>? category,
      Value<String>? tags,
      Value<String?>? projectId,
      Value<String?>? skillId,
      Value<String?>? taskId,
      Value<bool>? isPinned,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      projectId: projectId ?? this.projectId,
      skillId: skillId ?? this.skillId,
      taskId: taskId ?? this.taskId,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (skillId.present) {
      map['skill_id'] = Variable<String>(skillId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('projectId: $projectId, ')
          ..write('skillId: $skillId, ')
          ..write('taskId: $taskId, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledNotificationsTable extends ScheduledNotifications
    with TableInfo<$ScheduledNotificationsTable, ScheduledNotificationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledTimeMeta =
      const VerificationMeta('scheduledTime');
  @override
  late final GeneratedColumn<DateTime> scheduledTime =
      GeneratedColumn<DateTime>('scheduled_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, type, scheduledTime, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_notifications';
  @override
  VerificationContext validateIntegrity(
      Insertable<ScheduledNotificationEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
          _scheduledTimeMeta,
          scheduledTime.isAcceptableOrUnknown(
              data['scheduled_time']!, _scheduledTimeMeta));
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledNotificationEntry map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledNotificationEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      scheduledTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_time'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
    );
  }

  @override
  $ScheduledNotificationsTable createAlias(String alias) {
    return $ScheduledNotificationsTable(attachedDatabase, alias);
  }
}

class ScheduledNotificationEntry extends DataClass
    implements Insertable<ScheduledNotificationEntry> {
  final int id;
  final String? taskId;
  final String type;
  final DateTime scheduledTime;
  final String payload;
  const ScheduledNotificationEntry(
      {required this.id,
      this.taskId,
      required this.type,
      required this.scheduledTime,
      required this.payload});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['type'] = Variable<String>(type);
    map['scheduled_time'] = Variable<DateTime>(scheduledTime);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  ScheduledNotificationsCompanion toCompanion(bool nullToAbsent) {
    return ScheduledNotificationsCompanion(
      id: Value(id),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      type: Value(type),
      scheduledTime: Value(scheduledTime),
      payload: Value(payload),
    );
  }

  factory ScheduledNotificationEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledNotificationEntry(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      type: serializer.fromJson<String>(json['type']),
      scheduledTime: serializer.fromJson<DateTime>(json['scheduledTime']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'type': serializer.toJson<String>(type),
      'scheduledTime': serializer.toJson<DateTime>(scheduledTime),
      'payload': serializer.toJson<String>(payload),
    };
  }

  ScheduledNotificationEntry copyWith(
          {int? id,
          Value<String?> taskId = const Value.absent(),
          String? type,
          DateTime? scheduledTime,
          String? payload}) =>
      ScheduledNotificationEntry(
        id: id ?? this.id,
        taskId: taskId.present ? taskId.value : this.taskId,
        type: type ?? this.type,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        payload: payload ?? this.payload,
      );
  ScheduledNotificationEntry copyWithCompanion(
      ScheduledNotificationsCompanion data) {
    return ScheduledNotificationEntry(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      type: data.type.present ? data.type.value : this.type,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledNotificationEntry(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, type, scheduledTime, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledNotificationEntry &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.type == this.type &&
          other.scheduledTime == this.scheduledTime &&
          other.payload == this.payload);
}

class ScheduledNotificationsCompanion
    extends UpdateCompanion<ScheduledNotificationEntry> {
  final Value<int> id;
  final Value<String?> taskId;
  final Value<String> type;
  final Value<DateTime> scheduledTime;
  final Value<String> payload;
  const ScheduledNotificationsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.type = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.payload = const Value.absent(),
  });
  ScheduledNotificationsCompanion.insert({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    required String type,
    required DateTime scheduledTime,
    this.payload = const Value.absent(),
  })  : type = Value(type),
        scheduledTime = Value(scheduledTime);
  static Insertable<ScheduledNotificationEntry> custom({
    Expression<int>? id,
    Expression<String>? taskId,
    Expression<String>? type,
    Expression<DateTime>? scheduledTime,
    Expression<String>? payload,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (type != null) 'type': type,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (payload != null) 'payload': payload,
    });
  }

  ScheduledNotificationsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? taskId,
      Value<String>? type,
      Value<DateTime>? scheduledTime,
      Value<String>? payload}) {
    return ScheduledNotificationsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      payload: payload ?? this.payload,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<DateTime>(scheduledTime.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }
}

class $ActivityHistoryTable extends ActivityHistory
    with TableInfo<$ActivityHistoryTable, ActivityHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 300),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, entityType, entityId, action, summary, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<ActivityHistoryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityHistoryEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ActivityHistoryTable createAlias(String alias) {
    return $ActivityHistoryTable(attachedDatabase, alias);
  }
}

class ActivityHistoryEntry extends DataClass
    implements Insertable<ActivityHistoryEntry> {
  final String id;
  final String entityType;
  final String? entityId;
  final String action;
  final String summary;
  final DateTime createdAt;
  const ActivityHistoryEntry(
      {required this.id,
      required this.entityType,
      this.entityId,
      required this.action,
      required this.summary,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['action'] = Variable<String>(action);
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityHistoryCompanion toCompanion(bool nullToAbsent) {
    return ActivityHistoryCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      action: Value(action),
      summary: Value(summary),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityHistoryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityHistoryEntry(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'action': serializer.toJson<String>(action),
      'summary': serializer.toJson<String>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityHistoryEntry copyWith(
          {String? id,
          String? entityType,
          Value<String?> entityId = const Value.absent(),
          String? action,
          String? summary,
          DateTime? createdAt}) =>
      ActivityHistoryEntry(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId.present ? entityId.value : this.entityId,
        action: action ?? this.action,
        summary: summary ?? this.summary,
        createdAt: createdAt ?? this.createdAt,
      );
  ActivityHistoryEntry copyWithCompanion(ActivityHistoryCompanion data) {
    return ActivityHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityHistoryEntry(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, entityId, action, summary, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityHistoryEntry &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt);
}

class ActivityHistoryCompanion extends UpdateCompanion<ActivityHistoryEntry> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String?> entityId;
  final Value<String> action;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ActivityHistoryCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityHistoryCompanion.insert({
    required String id,
    required String entityType,
    this.entityId = const Value.absent(),
    required String action,
    required String summary,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        action = Value(action),
        summary = Value(summary),
        createdAt = Value(createdAt);
  static Insertable<ActivityHistoryEntry> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String?>? entityId,
      Value<String>? action,
      Value<String>? summary,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ActivityHistoryCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityHistoryCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $XpEventsTable extends XpEvents
    with TableInfo<$XpEventsTable, XpEventEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceKeyMeta =
      const VerificationMeta('sourceKey');
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
      'source_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 240),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sourceKey, sourceType, amount, summary, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_events';
  @override
  VerificationContext validateIntegrity(Insertable<XpEventEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_key')) {
      context.handle(_sourceKeyMeta,
          sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta));
    } else if (isInserting) {
      context.missing(_sourceKeyMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpEventEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpEventEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_key'])!,
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $XpEventsTable createAlias(String alias) {
    return $XpEventsTable(attachedDatabase, alias);
  }
}

class XpEventEntry extends DataClass implements Insertable<XpEventEntry> {
  final String id;
  final String sourceKey;
  final String sourceType;
  final int amount;
  final String summary;
  final DateTime createdAt;
  const XpEventEntry(
      {required this.id,
      required this.sourceKey,
      required this.sourceType,
      required this.amount,
      required this.summary,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_key'] = Variable<String>(sourceKey);
    map['source_type'] = Variable<String>(sourceType);
    map['amount'] = Variable<int>(amount);
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  XpEventsCompanion toCompanion(bool nullToAbsent) {
    return XpEventsCompanion(
      id: Value(id),
      sourceKey: Value(sourceKey),
      sourceType: Value(sourceType),
      amount: Value(amount),
      summary: Value(summary),
      createdAt: Value(createdAt),
    );
  }

  factory XpEventEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpEventEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceKey: serializer.fromJson<String>(json['sourceKey']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      amount: serializer.fromJson<int>(json['amount']),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceKey': serializer.toJson<String>(sourceKey),
      'sourceType': serializer.toJson<String>(sourceType),
      'amount': serializer.toJson<int>(amount),
      'summary': serializer.toJson<String>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  XpEventEntry copyWith(
          {String? id,
          String? sourceKey,
          String? sourceType,
          int? amount,
          String? summary,
          DateTime? createdAt}) =>
      XpEventEntry(
        id: id ?? this.id,
        sourceKey: sourceKey ?? this.sourceKey,
        sourceType: sourceType ?? this.sourceType,
        amount: amount ?? this.amount,
        summary: summary ?? this.summary,
        createdAt: createdAt ?? this.createdAt,
      );
  XpEventEntry copyWithCompanion(XpEventsCompanion data) {
    return XpEventEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      amount: data.amount.present ? data.amount.value : this.amount,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpEventEntry(')
          ..write('id: $id, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('sourceType: $sourceType, ')
          ..write('amount: $amount, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourceKey, sourceType, amount, summary, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpEventEntry &&
          other.id == this.id &&
          other.sourceKey == this.sourceKey &&
          other.sourceType == this.sourceType &&
          other.amount == this.amount &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt);
}

class XpEventsCompanion extends UpdateCompanion<XpEventEntry> {
  final Value<String> id;
  final Value<String> sourceKey;
  final Value<String> sourceType;
  final Value<int> amount;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const XpEventsCompanion({
    this.id = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.amount = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  XpEventsCompanion.insert({
    required String id,
    required String sourceKey,
    required String sourceType,
    required int amount,
    required String summary,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceKey = Value(sourceKey),
        sourceType = Value(sourceType),
        amount = Value(amount),
        summary = Value(summary),
        createdAt = Value(createdAt);
  static Insertable<XpEventEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceKey,
    Expression<String>? sourceType,
    Expression<int>? amount,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceKey != null) 'source_key': sourceKey,
      if (sourceType != null) 'source_type': sourceType,
      if (amount != null) 'amount': amount,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  XpEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceKey,
      Value<String>? sourceType,
      Value<int>? amount,
      Value<String>? summary,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return XpEventsCompanion(
      id: id ?? this.id,
      sourceKey: sourceKey ?? this.sourceKey,
      sourceType: sourceType ?? this.sourceType,
      amount: amount ?? this.amount,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpEventsCompanion(')
          ..write('id: $id, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('sourceType: $sourceType, ')
          ..write('amount: $amount, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnlockedAchievementsTable extends UnlockedAchievements
    with TableInfo<$UnlockedAchievementsTable, UnlockedAchievementEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedAchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 260),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, category, title, description, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_achievements';
  @override
  VerificationContext validateIntegrity(
      Insertable<UnlockedAchievementEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnlockedAchievementEntry map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedAchievementEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $UnlockedAchievementsTable createAlias(String alias) {
    return $UnlockedAchievementsTable(attachedDatabase, alias);
  }
}

class UnlockedAchievementEntry extends DataClass
    implements Insertable<UnlockedAchievementEntry> {
  final String id;
  final String category;
  final String title;
  final String description;
  final DateTime unlockedAt;
  const UnlockedAchievementEntry(
      {required this.id,
      required this.category,
      required this.title,
      required this.description,
      required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  UnlockedAchievementsCompanion toCompanion(bool nullToAbsent) {
    return UnlockedAchievementsCompanion(
      id: Value(id),
      category: Value(category),
      title: Value(title),
      description: Value(description),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory UnlockedAchievementEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedAchievementEntry(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  UnlockedAchievementEntry copyWith(
          {String? id,
          String? category,
          String? title,
          String? description,
          DateTime? unlockedAt}) =>
      UnlockedAchievementEntry(
        id: id ?? this.id,
        category: category ?? this.category,
        title: title ?? this.title,
        description: description ?? this.description,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  UnlockedAchievementEntry copyWithCompanion(
      UnlockedAchievementsCompanion data) {
    return UnlockedAchievementEntry(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedAchievementEntry(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, title, description, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedAchievementEntry &&
          other.id == this.id &&
          other.category == this.category &&
          other.title == this.title &&
          other.description == this.description &&
          other.unlockedAt == this.unlockedAt);
}

class UnlockedAchievementsCompanion
    extends UpdateCompanion<UnlockedAchievementEntry> {
  final Value<String> id;
  final Value<String> category;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const UnlockedAchievementsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnlockedAchievementsCompanion.insert({
    required String id,
    required String category,
    required String title,
    required String description,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        category = Value(category),
        title = Value(title),
        description = Value(description),
        unlockedAt = Value(unlockedAt);
  static Insertable<UnlockedAchievementEntry> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnlockedAchievementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? category,
      Value<String>? title,
      Value<String>? description,
      Value<DateTime>? unlockedAt,
      Value<int>? rowid}) {
    return UnlockedAchievementsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedAchievementsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadarDiscoveriesTable extends RadarDiscoveries
    with TableInfo<$RadarDiscoveriesTable, RadarDiscoveryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadarDiscoveriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _canonicalUrlMeta =
      const VerificationMeta('canonicalUrl');
  @override
  late final GeneratedColumn<String> canonicalUrl = GeneratedColumn<String>(
      'canonical_url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _discoveryTypeMeta =
      const VerificationMeta('discoveryType');
  @override
  late final GeneratedColumn<String> discoveryType = GeneratedColumn<String>(
      'discovery_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _primaryCategoryMeta =
      const VerificationMeta('primaryCategory');
  @override
  late final GeneratedColumn<String> primaryCategory = GeneratedColumn<String>(
      'primary_category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoriesJsonMeta =
      const VerificationMeta('categoriesJson');
  @override
  late final GeneratedColumn<String> categoriesJson = GeneratedColumn<String>(
      'categories_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _priorityTierMeta =
      const VerificationMeta('priorityTier');
  @override
  late final GeneratedColumn<String> priorityTier = GeneratedColumn<String>(
      'priority_tier', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('P1'));
  static const VerificationMeta _sourceNameMeta =
      const VerificationMeta('sourceName');
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
      'source_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceDomainMeta =
      const VerificationMeta('sourceDomain');
  @override
  late final GeneratedColumn<String> sourceDomain = GeneratedColumn<String>(
      'source_domain', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _authorOrOrgMeta =
      const VerificationMeta('authorOrOrg');
  @override
  late final GeneratedColumn<String> authorOrOrg = GeneratedColumn<String>(
      'author_or_org', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedAtIsoMeta =
      const VerificationMeta('publishedAtIso');
  @override
  late final GeneratedColumn<String> publishedAtIso = GeneratedColumn<String>(
      'published_at_iso', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _discoveredAtMeta =
      const VerificationMeta('discoveredAt');
  @override
  late final GeneratedColumn<DateTime> discoveredAt = GeneratedColumn<DateTime>(
      'discovered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _rawSummaryMeta =
      const VerificationMeta('rawSummary');
  @override
  late final GeneratedColumn<String> rawSummary = GeneratedColumn<String>(
      'raw_summary', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _plainEnglishSummaryMeta =
      const VerificationMeta('plainEnglishSummary');
  @override
  late final GeneratedColumn<String> plainEnglishSummary =
      GeneratedColumn<String>('plain_english_summary', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whyItMattersMeta =
      const VerificationMeta('whyItMatters');
  @override
  late final GeneratedColumn<String> whyItMatters = GeneratedColumn<String>(
      'why_it_matters', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whoItIsForMeta =
      const VerificationMeta('whoItIsFor');
  @override
  late final GeneratedColumn<String> whoItIsFor = GeneratedColumn<String>(
      'who_it_is_for', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _howItComparesMeta =
      const VerificationMeta('howItCompares');
  @override
  late final GeneratedColumn<String> howItCompares = GeneratedColumn<String>(
      'how_it_compares', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _practicalTakeawayMeta =
      const VerificationMeta('practicalTakeaway');
  @override
  late final GeneratedColumn<String> practicalTakeaway =
      GeneratedColumn<String>('practical_takeaway', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tryItSuggestionMeta =
      const VerificationMeta('tryItSuggestion');
  @override
  late final GeneratedColumn<String> tryItSuggestion = GeneratedColumn<String>(
      'try_it_suggestion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _beginnerNoteMeta =
      const VerificationMeta('beginnerNote');
  @override
  late final GeneratedColumn<String> beginnerNote = GeneratedColumn<String>(
      'beginner_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _analysisSourceMeta =
      const VerificationMeta('analysisSource');
  @override
  late final GeneratedColumn<String> analysisSource = GeneratedColumn<String>(
      'analysis_source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('source_reported'));
  static const VerificationMeta _primaryMetricLabelMeta =
      const VerificationMeta('primaryMetricLabel');
  @override
  late final GeneratedColumn<String> primaryMetricLabel =
      GeneratedColumn<String>('primary_metric_label', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _primaryMetricValueMeta =
      const VerificationMeta('primaryMetricValue');
  @override
  late final GeneratedColumn<double> primaryMetricValue =
      GeneratedColumn<double>('primary_metric_value', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _secondaryMetricLabelMeta =
      const VerificationMeta('secondaryMetricLabel');
  @override
  late final GeneratedColumn<String> secondaryMetricLabel =
      GeneratedColumn<String>('secondary_metric_label', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _secondaryMetricValueMeta =
      const VerificationMeta('secondaryMetricValue');
  @override
  late final GeneratedColumn<double> secondaryMetricValue =
      GeneratedColumn<double>('secondary_metric_value', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _metricDeltaLabelMeta =
      const VerificationMeta('metricDeltaLabel');
  @override
  late final GeneratedColumn<String> metricDeltaLabel = GeneratedColumn<String>(
      'metric_delta_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metricDeltaValueMeta =
      const VerificationMeta('metricDeltaValue');
  @override
  late final GeneratedColumn<double> metricDeltaValue = GeneratedColumn<double>(
      'metric_delta_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sourcesJsonMeta =
      const VerificationMeta('sourcesJson');
  @override
  late final GeneratedColumn<String> sourcesJson = GeneratedColumn<String>(
      'sources_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _rankScoreMeta =
      const VerificationMeta('rankScore');
  @override
  late final GeneratedColumn<double> rankScore = GeneratedColumn<double>(
      'rank_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isExploratoryMeta =
      const VerificationMeta('isExploratory');
  @override
  late final GeneratedColumn<bool> isExploratory = GeneratedColumn<bool>(
      'is_exploratory', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_exploratory" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isBookmarkedMeta =
      const VerificationMeta('isBookmarked');
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
      'is_bookmarked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_bookmarked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bookmarkCollectionMeta =
      const VerificationMeta('bookmarkCollection');
  @override
  late final GeneratedColumn<String> bookmarkCollection =
      GeneratedColumn<String>('bookmark_collection', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bookmarkNoteMeta =
      const VerificationMeta('bookmarkNote');
  @override
  late final GeneratedColumn<String> bookmarkNote = GeneratedColumn<String>(
      'bookmark_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isExploredMeta =
      const VerificationMeta('isExplored');
  @override
  late final GeneratedColumn<bool> isExplored = GeneratedColumn<bool>(
      'is_explored', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_explored" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isHiddenMeta =
      const VerificationMeta('isHidden');
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
      'is_hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_hidden" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        canonicalUrl,
        title,
        discoveryType,
        primaryCategory,
        categoriesJson,
        tagsJson,
        priorityTier,
        sourceName,
        sourceDomain,
        authorOrOrg,
        publishedAtIso,
        discoveredAt,
        rawSummary,
        plainEnglishSummary,
        whyItMatters,
        whoItIsFor,
        howItCompares,
        practicalTakeaway,
        tryItSuggestion,
        beginnerNote,
        analysisSource,
        primaryMetricLabel,
        primaryMetricValue,
        secondaryMetricLabel,
        secondaryMetricValue,
        metricDeltaLabel,
        metricDeltaValue,
        sourcesJson,
        rankScore,
        isExploratory,
        isBookmarked,
        bookmarkCollection,
        bookmarkNote,
        isRead,
        isExplored,
        isHidden
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radar_discoveries';
  @override
  VerificationContext validateIntegrity(
      Insertable<RadarDiscoveryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('canonical_url')) {
      context.handle(
          _canonicalUrlMeta,
          canonicalUrl.isAcceptableOrUnknown(
              data['canonical_url']!, _canonicalUrlMeta));
    } else if (isInserting) {
      context.missing(_canonicalUrlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('discovery_type')) {
      context.handle(
          _discoveryTypeMeta,
          discoveryType.isAcceptableOrUnknown(
              data['discovery_type']!, _discoveryTypeMeta));
    } else if (isInserting) {
      context.missing(_discoveryTypeMeta);
    }
    if (data.containsKey('primary_category')) {
      context.handle(
          _primaryCategoryMeta,
          primaryCategory.isAcceptableOrUnknown(
              data['primary_category']!, _primaryCategoryMeta));
    } else if (isInserting) {
      context.missing(_primaryCategoryMeta);
    }
    if (data.containsKey('categories_json')) {
      context.handle(
          _categoriesJsonMeta,
          categoriesJson.isAcceptableOrUnknown(
              data['categories_json']!, _categoriesJsonMeta));
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    }
    if (data.containsKey('priority_tier')) {
      context.handle(
          _priorityTierMeta,
          priorityTier.isAcceptableOrUnknown(
              data['priority_tier']!, _priorityTierMeta));
    }
    if (data.containsKey('source_name')) {
      context.handle(
          _sourceNameMeta,
          sourceName.isAcceptableOrUnknown(
              data['source_name']!, _sourceNameMeta));
    } else if (isInserting) {
      context.missing(_sourceNameMeta);
    }
    if (data.containsKey('source_domain')) {
      context.handle(
          _sourceDomainMeta,
          sourceDomain.isAcceptableOrUnknown(
              data['source_domain']!, _sourceDomainMeta));
    }
    if (data.containsKey('author_or_org')) {
      context.handle(
          _authorOrOrgMeta,
          authorOrOrg.isAcceptableOrUnknown(
              data['author_or_org']!, _authorOrOrgMeta));
    }
    if (data.containsKey('published_at_iso')) {
      context.handle(
          _publishedAtIsoMeta,
          publishedAtIso.isAcceptableOrUnknown(
              data['published_at_iso']!, _publishedAtIsoMeta));
    }
    if (data.containsKey('discovered_at')) {
      context.handle(
          _discoveredAtMeta,
          discoveredAt.isAcceptableOrUnknown(
              data['discovered_at']!, _discoveredAtMeta));
    } else if (isInserting) {
      context.missing(_discoveredAtMeta);
    }
    if (data.containsKey('raw_summary')) {
      context.handle(
          _rawSummaryMeta,
          rawSummary.isAcceptableOrUnknown(
              data['raw_summary']!, _rawSummaryMeta));
    }
    if (data.containsKey('plain_english_summary')) {
      context.handle(
          _plainEnglishSummaryMeta,
          plainEnglishSummary.isAcceptableOrUnknown(
              data['plain_english_summary']!, _plainEnglishSummaryMeta));
    }
    if (data.containsKey('why_it_matters')) {
      context.handle(
          _whyItMattersMeta,
          whyItMatters.isAcceptableOrUnknown(
              data['why_it_matters']!, _whyItMattersMeta));
    }
    if (data.containsKey('who_it_is_for')) {
      context.handle(
          _whoItIsForMeta,
          whoItIsFor.isAcceptableOrUnknown(
              data['who_it_is_for']!, _whoItIsForMeta));
    }
    if (data.containsKey('how_it_compares')) {
      context.handle(
          _howItComparesMeta,
          howItCompares.isAcceptableOrUnknown(
              data['how_it_compares']!, _howItComparesMeta));
    }
    if (data.containsKey('practical_takeaway')) {
      context.handle(
          _practicalTakeawayMeta,
          practicalTakeaway.isAcceptableOrUnknown(
              data['practical_takeaway']!, _practicalTakeawayMeta));
    }
    if (data.containsKey('try_it_suggestion')) {
      context.handle(
          _tryItSuggestionMeta,
          tryItSuggestion.isAcceptableOrUnknown(
              data['try_it_suggestion']!, _tryItSuggestionMeta));
    }
    if (data.containsKey('beginner_note')) {
      context.handle(
          _beginnerNoteMeta,
          beginnerNote.isAcceptableOrUnknown(
              data['beginner_note']!, _beginnerNoteMeta));
    }
    if (data.containsKey('analysis_source')) {
      context.handle(
          _analysisSourceMeta,
          analysisSource.isAcceptableOrUnknown(
              data['analysis_source']!, _analysisSourceMeta));
    }
    if (data.containsKey('primary_metric_label')) {
      context.handle(
          _primaryMetricLabelMeta,
          primaryMetricLabel.isAcceptableOrUnknown(
              data['primary_metric_label']!, _primaryMetricLabelMeta));
    }
    if (data.containsKey('primary_metric_value')) {
      context.handle(
          _primaryMetricValueMeta,
          primaryMetricValue.isAcceptableOrUnknown(
              data['primary_metric_value']!, _primaryMetricValueMeta));
    }
    if (data.containsKey('secondary_metric_label')) {
      context.handle(
          _secondaryMetricLabelMeta,
          secondaryMetricLabel.isAcceptableOrUnknown(
              data['secondary_metric_label']!, _secondaryMetricLabelMeta));
    }
    if (data.containsKey('secondary_metric_value')) {
      context.handle(
          _secondaryMetricValueMeta,
          secondaryMetricValue.isAcceptableOrUnknown(
              data['secondary_metric_value']!, _secondaryMetricValueMeta));
    }
    if (data.containsKey('metric_delta_label')) {
      context.handle(
          _metricDeltaLabelMeta,
          metricDeltaLabel.isAcceptableOrUnknown(
              data['metric_delta_label']!, _metricDeltaLabelMeta));
    }
    if (data.containsKey('metric_delta_value')) {
      context.handle(
          _metricDeltaValueMeta,
          metricDeltaValue.isAcceptableOrUnknown(
              data['metric_delta_value']!, _metricDeltaValueMeta));
    }
    if (data.containsKey('sources_json')) {
      context.handle(
          _sourcesJsonMeta,
          sourcesJson.isAcceptableOrUnknown(
              data['sources_json']!, _sourcesJsonMeta));
    }
    if (data.containsKey('rank_score')) {
      context.handle(_rankScoreMeta,
          rankScore.isAcceptableOrUnknown(data['rank_score']!, _rankScoreMeta));
    }
    if (data.containsKey('is_exploratory')) {
      context.handle(
          _isExploratoryMeta,
          isExploratory.isAcceptableOrUnknown(
              data['is_exploratory']!, _isExploratoryMeta));
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
          _isBookmarkedMeta,
          isBookmarked.isAcceptableOrUnknown(
              data['is_bookmarked']!, _isBookmarkedMeta));
    }
    if (data.containsKey('bookmark_collection')) {
      context.handle(
          _bookmarkCollectionMeta,
          bookmarkCollection.isAcceptableOrUnknown(
              data['bookmark_collection']!, _bookmarkCollectionMeta));
    }
    if (data.containsKey('bookmark_note')) {
      context.handle(
          _bookmarkNoteMeta,
          bookmarkNote.isAcceptableOrUnknown(
              data['bookmark_note']!, _bookmarkNoteMeta));
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('is_explored')) {
      context.handle(
          _isExploredMeta,
          isExplored.isAcceptableOrUnknown(
              data['is_explored']!, _isExploredMeta));
    }
    if (data.containsKey('is_hidden')) {
      context.handle(_isHiddenMeta,
          isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RadarDiscoveryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadarDiscoveryEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      canonicalUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}canonical_url'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      discoveryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}discovery_type'])!,
      primaryCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_category'])!,
      categoriesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}categories_json'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json'])!,
      priorityTier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority_tier'])!,
      sourceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_name'])!,
      sourceDomain: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_domain'])!,
      authorOrOrg: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_or_org']),
      publishedAtIso: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}published_at_iso']),
      discoveredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}discovered_at'])!,
      rawSummary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_summary'])!,
      plainEnglishSummary: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}plain_english_summary']),
      whyItMatters: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}why_it_matters']),
      whoItIsFor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}who_it_is_for']),
      howItCompares: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}how_it_compares']),
      practicalTakeaway: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}practical_takeaway']),
      tryItSuggestion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}try_it_suggestion']),
      beginnerNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}beginner_note']),
      analysisSource: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}analysis_source'])!,
      primaryMetricLabel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_metric_label']),
      primaryMetricValue: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}primary_metric_value']),
      secondaryMetricLabel: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}secondary_metric_label']),
      secondaryMetricValue: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}secondary_metric_value']),
      metricDeltaLabel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}metric_delta_label']),
      metricDeltaValue: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}metric_delta_value']),
      sourcesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sources_json'])!,
      rankScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rank_score'])!,
      isExploratory: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_exploratory'])!,
      isBookmarked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bookmarked'])!,
      bookmarkCollection: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}bookmark_collection']),
      bookmarkNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bookmark_note']),
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      isExplored: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_explored'])!,
      isHidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_hidden'])!,
    );
  }

  @override
  $RadarDiscoveriesTable createAlias(String alias) {
    return $RadarDiscoveriesTable(attachedDatabase, alias);
  }
}

class RadarDiscoveryEntry extends DataClass
    implements Insertable<RadarDiscoveryEntry> {
  final String id;
  final String canonicalUrl;
  final String title;
  final String discoveryType;
  final String primaryCategory;
  final String categoriesJson;
  final String tagsJson;
  final String priorityTier;
  final String sourceName;
  final String sourceDomain;
  final String? authorOrOrg;
  final String? publishedAtIso;
  final DateTime discoveredAt;
  final String rawSummary;
  final String? plainEnglishSummary;
  final String? whyItMatters;
  final String? whoItIsFor;
  final String? howItCompares;
  final String? practicalTakeaway;
  final String? tryItSuggestion;
  final String? beginnerNote;
  final String analysisSource;
  final String? primaryMetricLabel;
  final double? primaryMetricValue;
  final String? secondaryMetricLabel;
  final double? secondaryMetricValue;
  final String? metricDeltaLabel;
  final double? metricDeltaValue;
  final String sourcesJson;
  final double rankScore;
  final bool isExploratory;
  final bool isBookmarked;
  final String? bookmarkCollection;
  final String? bookmarkNote;
  final bool isRead;
  final bool isExplored;
  final bool isHidden;
  const RadarDiscoveryEntry(
      {required this.id,
      required this.canonicalUrl,
      required this.title,
      required this.discoveryType,
      required this.primaryCategory,
      required this.categoriesJson,
      required this.tagsJson,
      required this.priorityTier,
      required this.sourceName,
      required this.sourceDomain,
      this.authorOrOrg,
      this.publishedAtIso,
      required this.discoveredAt,
      required this.rawSummary,
      this.plainEnglishSummary,
      this.whyItMatters,
      this.whoItIsFor,
      this.howItCompares,
      this.practicalTakeaway,
      this.tryItSuggestion,
      this.beginnerNote,
      required this.analysisSource,
      this.primaryMetricLabel,
      this.primaryMetricValue,
      this.secondaryMetricLabel,
      this.secondaryMetricValue,
      this.metricDeltaLabel,
      this.metricDeltaValue,
      required this.sourcesJson,
      required this.rankScore,
      required this.isExploratory,
      required this.isBookmarked,
      this.bookmarkCollection,
      this.bookmarkNote,
      required this.isRead,
      required this.isExplored,
      required this.isHidden});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['canonical_url'] = Variable<String>(canonicalUrl);
    map['title'] = Variable<String>(title);
    map['discovery_type'] = Variable<String>(discoveryType);
    map['primary_category'] = Variable<String>(primaryCategory);
    map['categories_json'] = Variable<String>(categoriesJson);
    map['tags_json'] = Variable<String>(tagsJson);
    map['priority_tier'] = Variable<String>(priorityTier);
    map['source_name'] = Variable<String>(sourceName);
    map['source_domain'] = Variable<String>(sourceDomain);
    if (!nullToAbsent || authorOrOrg != null) {
      map['author_or_org'] = Variable<String>(authorOrOrg);
    }
    if (!nullToAbsent || publishedAtIso != null) {
      map['published_at_iso'] = Variable<String>(publishedAtIso);
    }
    map['discovered_at'] = Variable<DateTime>(discoveredAt);
    map['raw_summary'] = Variable<String>(rawSummary);
    if (!nullToAbsent || plainEnglishSummary != null) {
      map['plain_english_summary'] = Variable<String>(plainEnglishSummary);
    }
    if (!nullToAbsent || whyItMatters != null) {
      map['why_it_matters'] = Variable<String>(whyItMatters);
    }
    if (!nullToAbsent || whoItIsFor != null) {
      map['who_it_is_for'] = Variable<String>(whoItIsFor);
    }
    if (!nullToAbsent || howItCompares != null) {
      map['how_it_compares'] = Variable<String>(howItCompares);
    }
    if (!nullToAbsent || practicalTakeaway != null) {
      map['practical_takeaway'] = Variable<String>(practicalTakeaway);
    }
    if (!nullToAbsent || tryItSuggestion != null) {
      map['try_it_suggestion'] = Variable<String>(tryItSuggestion);
    }
    if (!nullToAbsent || beginnerNote != null) {
      map['beginner_note'] = Variable<String>(beginnerNote);
    }
    map['analysis_source'] = Variable<String>(analysisSource);
    if (!nullToAbsent || primaryMetricLabel != null) {
      map['primary_metric_label'] = Variable<String>(primaryMetricLabel);
    }
    if (!nullToAbsent || primaryMetricValue != null) {
      map['primary_metric_value'] = Variable<double>(primaryMetricValue);
    }
    if (!nullToAbsent || secondaryMetricLabel != null) {
      map['secondary_metric_label'] = Variable<String>(secondaryMetricLabel);
    }
    if (!nullToAbsent || secondaryMetricValue != null) {
      map['secondary_metric_value'] = Variable<double>(secondaryMetricValue);
    }
    if (!nullToAbsent || metricDeltaLabel != null) {
      map['metric_delta_label'] = Variable<String>(metricDeltaLabel);
    }
    if (!nullToAbsent || metricDeltaValue != null) {
      map['metric_delta_value'] = Variable<double>(metricDeltaValue);
    }
    map['sources_json'] = Variable<String>(sourcesJson);
    map['rank_score'] = Variable<double>(rankScore);
    map['is_exploratory'] = Variable<bool>(isExploratory);
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    if (!nullToAbsent || bookmarkCollection != null) {
      map['bookmark_collection'] = Variable<String>(bookmarkCollection);
    }
    if (!nullToAbsent || bookmarkNote != null) {
      map['bookmark_note'] = Variable<String>(bookmarkNote);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['is_explored'] = Variable<bool>(isExplored);
    map['is_hidden'] = Variable<bool>(isHidden);
    return map;
  }

  RadarDiscoveriesCompanion toCompanion(bool nullToAbsent) {
    return RadarDiscoveriesCompanion(
      id: Value(id),
      canonicalUrl: Value(canonicalUrl),
      title: Value(title),
      discoveryType: Value(discoveryType),
      primaryCategory: Value(primaryCategory),
      categoriesJson: Value(categoriesJson),
      tagsJson: Value(tagsJson),
      priorityTier: Value(priorityTier),
      sourceName: Value(sourceName),
      sourceDomain: Value(sourceDomain),
      authorOrOrg: authorOrOrg == null && nullToAbsent
          ? const Value.absent()
          : Value(authorOrOrg),
      publishedAtIso: publishedAtIso == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAtIso),
      discoveredAt: Value(discoveredAt),
      rawSummary: Value(rawSummary),
      plainEnglishSummary: plainEnglishSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(plainEnglishSummary),
      whyItMatters: whyItMatters == null && nullToAbsent
          ? const Value.absent()
          : Value(whyItMatters),
      whoItIsFor: whoItIsFor == null && nullToAbsent
          ? const Value.absent()
          : Value(whoItIsFor),
      howItCompares: howItCompares == null && nullToAbsent
          ? const Value.absent()
          : Value(howItCompares),
      practicalTakeaway: practicalTakeaway == null && nullToAbsent
          ? const Value.absent()
          : Value(practicalTakeaway),
      tryItSuggestion: tryItSuggestion == null && nullToAbsent
          ? const Value.absent()
          : Value(tryItSuggestion),
      beginnerNote: beginnerNote == null && nullToAbsent
          ? const Value.absent()
          : Value(beginnerNote),
      analysisSource: Value(analysisSource),
      primaryMetricLabel: primaryMetricLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryMetricLabel),
      primaryMetricValue: primaryMetricValue == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryMetricValue),
      secondaryMetricLabel: secondaryMetricLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryMetricLabel),
      secondaryMetricValue: secondaryMetricValue == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryMetricValue),
      metricDeltaLabel: metricDeltaLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(metricDeltaLabel),
      metricDeltaValue: metricDeltaValue == null && nullToAbsent
          ? const Value.absent()
          : Value(metricDeltaValue),
      sourcesJson: Value(sourcesJson),
      rankScore: Value(rankScore),
      isExploratory: Value(isExploratory),
      isBookmarked: Value(isBookmarked),
      bookmarkCollection: bookmarkCollection == null && nullToAbsent
          ? const Value.absent()
          : Value(bookmarkCollection),
      bookmarkNote: bookmarkNote == null && nullToAbsent
          ? const Value.absent()
          : Value(bookmarkNote),
      isRead: Value(isRead),
      isExplored: Value(isExplored),
      isHidden: Value(isHidden),
    );
  }

  factory RadarDiscoveryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadarDiscoveryEntry(
      id: serializer.fromJson<String>(json['id']),
      canonicalUrl: serializer.fromJson<String>(json['canonicalUrl']),
      title: serializer.fromJson<String>(json['title']),
      discoveryType: serializer.fromJson<String>(json['discoveryType']),
      primaryCategory: serializer.fromJson<String>(json['primaryCategory']),
      categoriesJson: serializer.fromJson<String>(json['categoriesJson']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      priorityTier: serializer.fromJson<String>(json['priorityTier']),
      sourceName: serializer.fromJson<String>(json['sourceName']),
      sourceDomain: serializer.fromJson<String>(json['sourceDomain']),
      authorOrOrg: serializer.fromJson<String?>(json['authorOrOrg']),
      publishedAtIso: serializer.fromJson<String?>(json['publishedAtIso']),
      discoveredAt: serializer.fromJson<DateTime>(json['discoveredAt']),
      rawSummary: serializer.fromJson<String>(json['rawSummary']),
      plainEnglishSummary:
          serializer.fromJson<String?>(json['plainEnglishSummary']),
      whyItMatters: serializer.fromJson<String?>(json['whyItMatters']),
      whoItIsFor: serializer.fromJson<String?>(json['whoItIsFor']),
      howItCompares: serializer.fromJson<String?>(json['howItCompares']),
      practicalTakeaway:
          serializer.fromJson<String?>(json['practicalTakeaway']),
      tryItSuggestion: serializer.fromJson<String?>(json['tryItSuggestion']),
      beginnerNote: serializer.fromJson<String?>(json['beginnerNote']),
      analysisSource: serializer.fromJson<String>(json['analysisSource']),
      primaryMetricLabel:
          serializer.fromJson<String?>(json['primaryMetricLabel']),
      primaryMetricValue:
          serializer.fromJson<double?>(json['primaryMetricValue']),
      secondaryMetricLabel:
          serializer.fromJson<String?>(json['secondaryMetricLabel']),
      secondaryMetricValue:
          serializer.fromJson<double?>(json['secondaryMetricValue']),
      metricDeltaLabel: serializer.fromJson<String?>(json['metricDeltaLabel']),
      metricDeltaValue: serializer.fromJson<double?>(json['metricDeltaValue']),
      sourcesJson: serializer.fromJson<String>(json['sourcesJson']),
      rankScore: serializer.fromJson<double>(json['rankScore']),
      isExploratory: serializer.fromJson<bool>(json['isExploratory']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
      bookmarkCollection:
          serializer.fromJson<String?>(json['bookmarkCollection']),
      bookmarkNote: serializer.fromJson<String?>(json['bookmarkNote']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      isExplored: serializer.fromJson<bool>(json['isExplored']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'canonicalUrl': serializer.toJson<String>(canonicalUrl),
      'title': serializer.toJson<String>(title),
      'discoveryType': serializer.toJson<String>(discoveryType),
      'primaryCategory': serializer.toJson<String>(primaryCategory),
      'categoriesJson': serializer.toJson<String>(categoriesJson),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'priorityTier': serializer.toJson<String>(priorityTier),
      'sourceName': serializer.toJson<String>(sourceName),
      'sourceDomain': serializer.toJson<String>(sourceDomain),
      'authorOrOrg': serializer.toJson<String?>(authorOrOrg),
      'publishedAtIso': serializer.toJson<String?>(publishedAtIso),
      'discoveredAt': serializer.toJson<DateTime>(discoveredAt),
      'rawSummary': serializer.toJson<String>(rawSummary),
      'plainEnglishSummary': serializer.toJson<String?>(plainEnglishSummary),
      'whyItMatters': serializer.toJson<String?>(whyItMatters),
      'whoItIsFor': serializer.toJson<String?>(whoItIsFor),
      'howItCompares': serializer.toJson<String?>(howItCompares),
      'practicalTakeaway': serializer.toJson<String?>(practicalTakeaway),
      'tryItSuggestion': serializer.toJson<String?>(tryItSuggestion),
      'beginnerNote': serializer.toJson<String?>(beginnerNote),
      'analysisSource': serializer.toJson<String>(analysisSource),
      'primaryMetricLabel': serializer.toJson<String?>(primaryMetricLabel),
      'primaryMetricValue': serializer.toJson<double?>(primaryMetricValue),
      'secondaryMetricLabel': serializer.toJson<String?>(secondaryMetricLabel),
      'secondaryMetricValue': serializer.toJson<double?>(secondaryMetricValue),
      'metricDeltaLabel': serializer.toJson<String?>(metricDeltaLabel),
      'metricDeltaValue': serializer.toJson<double?>(metricDeltaValue),
      'sourcesJson': serializer.toJson<String>(sourcesJson),
      'rankScore': serializer.toJson<double>(rankScore),
      'isExploratory': serializer.toJson<bool>(isExploratory),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
      'bookmarkCollection': serializer.toJson<String?>(bookmarkCollection),
      'bookmarkNote': serializer.toJson<String?>(bookmarkNote),
      'isRead': serializer.toJson<bool>(isRead),
      'isExplored': serializer.toJson<bool>(isExplored),
      'isHidden': serializer.toJson<bool>(isHidden),
    };
  }

  RadarDiscoveryEntry copyWith(
          {String? id,
          String? canonicalUrl,
          String? title,
          String? discoveryType,
          String? primaryCategory,
          String? categoriesJson,
          String? tagsJson,
          String? priorityTier,
          String? sourceName,
          String? sourceDomain,
          Value<String?> authorOrOrg = const Value.absent(),
          Value<String?> publishedAtIso = const Value.absent(),
          DateTime? discoveredAt,
          String? rawSummary,
          Value<String?> plainEnglishSummary = const Value.absent(),
          Value<String?> whyItMatters = const Value.absent(),
          Value<String?> whoItIsFor = const Value.absent(),
          Value<String?> howItCompares = const Value.absent(),
          Value<String?> practicalTakeaway = const Value.absent(),
          Value<String?> tryItSuggestion = const Value.absent(),
          Value<String?> beginnerNote = const Value.absent(),
          String? analysisSource,
          Value<String?> primaryMetricLabel = const Value.absent(),
          Value<double?> primaryMetricValue = const Value.absent(),
          Value<String?> secondaryMetricLabel = const Value.absent(),
          Value<double?> secondaryMetricValue = const Value.absent(),
          Value<String?> metricDeltaLabel = const Value.absent(),
          Value<double?> metricDeltaValue = const Value.absent(),
          String? sourcesJson,
          double? rankScore,
          bool? isExploratory,
          bool? isBookmarked,
          Value<String?> bookmarkCollection = const Value.absent(),
          Value<String?> bookmarkNote = const Value.absent(),
          bool? isRead,
          bool? isExplored,
          bool? isHidden}) =>
      RadarDiscoveryEntry(
        id: id ?? this.id,
        canonicalUrl: canonicalUrl ?? this.canonicalUrl,
        title: title ?? this.title,
        discoveryType: discoveryType ?? this.discoveryType,
        primaryCategory: primaryCategory ?? this.primaryCategory,
        categoriesJson: categoriesJson ?? this.categoriesJson,
        tagsJson: tagsJson ?? this.tagsJson,
        priorityTier: priorityTier ?? this.priorityTier,
        sourceName: sourceName ?? this.sourceName,
        sourceDomain: sourceDomain ?? this.sourceDomain,
        authorOrOrg: authorOrOrg.present ? authorOrOrg.value : this.authorOrOrg,
        publishedAtIso:
            publishedAtIso.present ? publishedAtIso.value : this.publishedAtIso,
        discoveredAt: discoveredAt ?? this.discoveredAt,
        rawSummary: rawSummary ?? this.rawSummary,
        plainEnglishSummary: plainEnglishSummary.present
            ? plainEnglishSummary.value
            : this.plainEnglishSummary,
        whyItMatters:
            whyItMatters.present ? whyItMatters.value : this.whyItMatters,
        whoItIsFor: whoItIsFor.present ? whoItIsFor.value : this.whoItIsFor,
        howItCompares:
            howItCompares.present ? howItCompares.value : this.howItCompares,
        practicalTakeaway: practicalTakeaway.present
            ? practicalTakeaway.value
            : this.practicalTakeaway,
        tryItSuggestion: tryItSuggestion.present
            ? tryItSuggestion.value
            : this.tryItSuggestion,
        beginnerNote:
            beginnerNote.present ? beginnerNote.value : this.beginnerNote,
        analysisSource: analysisSource ?? this.analysisSource,
        primaryMetricLabel: primaryMetricLabel.present
            ? primaryMetricLabel.value
            : this.primaryMetricLabel,
        primaryMetricValue: primaryMetricValue.present
            ? primaryMetricValue.value
            : this.primaryMetricValue,
        secondaryMetricLabel: secondaryMetricLabel.present
            ? secondaryMetricLabel.value
            : this.secondaryMetricLabel,
        secondaryMetricValue: secondaryMetricValue.present
            ? secondaryMetricValue.value
            : this.secondaryMetricValue,
        metricDeltaLabel: metricDeltaLabel.present
            ? metricDeltaLabel.value
            : this.metricDeltaLabel,
        metricDeltaValue: metricDeltaValue.present
            ? metricDeltaValue.value
            : this.metricDeltaValue,
        sourcesJson: sourcesJson ?? this.sourcesJson,
        rankScore: rankScore ?? this.rankScore,
        isExploratory: isExploratory ?? this.isExploratory,
        isBookmarked: isBookmarked ?? this.isBookmarked,
        bookmarkCollection: bookmarkCollection.present
            ? bookmarkCollection.value
            : this.bookmarkCollection,
        bookmarkNote:
            bookmarkNote.present ? bookmarkNote.value : this.bookmarkNote,
        isRead: isRead ?? this.isRead,
        isExplored: isExplored ?? this.isExplored,
        isHidden: isHidden ?? this.isHidden,
      );
  RadarDiscoveryEntry copyWithCompanion(RadarDiscoveriesCompanion data) {
    return RadarDiscoveryEntry(
      id: data.id.present ? data.id.value : this.id,
      canonicalUrl: data.canonicalUrl.present
          ? data.canonicalUrl.value
          : this.canonicalUrl,
      title: data.title.present ? data.title.value : this.title,
      discoveryType: data.discoveryType.present
          ? data.discoveryType.value
          : this.discoveryType,
      primaryCategory: data.primaryCategory.present
          ? data.primaryCategory.value
          : this.primaryCategory,
      categoriesJson: data.categoriesJson.present
          ? data.categoriesJson.value
          : this.categoriesJson,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      priorityTier: data.priorityTier.present
          ? data.priorityTier.value
          : this.priorityTier,
      sourceName:
          data.sourceName.present ? data.sourceName.value : this.sourceName,
      sourceDomain: data.sourceDomain.present
          ? data.sourceDomain.value
          : this.sourceDomain,
      authorOrOrg:
          data.authorOrOrg.present ? data.authorOrOrg.value : this.authorOrOrg,
      publishedAtIso: data.publishedAtIso.present
          ? data.publishedAtIso.value
          : this.publishedAtIso,
      discoveredAt: data.discoveredAt.present
          ? data.discoveredAt.value
          : this.discoveredAt,
      rawSummary:
          data.rawSummary.present ? data.rawSummary.value : this.rawSummary,
      plainEnglishSummary: data.plainEnglishSummary.present
          ? data.plainEnglishSummary.value
          : this.plainEnglishSummary,
      whyItMatters: data.whyItMatters.present
          ? data.whyItMatters.value
          : this.whyItMatters,
      whoItIsFor:
          data.whoItIsFor.present ? data.whoItIsFor.value : this.whoItIsFor,
      howItCompares: data.howItCompares.present
          ? data.howItCompares.value
          : this.howItCompares,
      practicalTakeaway: data.practicalTakeaway.present
          ? data.practicalTakeaway.value
          : this.practicalTakeaway,
      tryItSuggestion: data.tryItSuggestion.present
          ? data.tryItSuggestion.value
          : this.tryItSuggestion,
      beginnerNote: data.beginnerNote.present
          ? data.beginnerNote.value
          : this.beginnerNote,
      analysisSource: data.analysisSource.present
          ? data.analysisSource.value
          : this.analysisSource,
      primaryMetricLabel: data.primaryMetricLabel.present
          ? data.primaryMetricLabel.value
          : this.primaryMetricLabel,
      primaryMetricValue: data.primaryMetricValue.present
          ? data.primaryMetricValue.value
          : this.primaryMetricValue,
      secondaryMetricLabel: data.secondaryMetricLabel.present
          ? data.secondaryMetricLabel.value
          : this.secondaryMetricLabel,
      secondaryMetricValue: data.secondaryMetricValue.present
          ? data.secondaryMetricValue.value
          : this.secondaryMetricValue,
      metricDeltaLabel: data.metricDeltaLabel.present
          ? data.metricDeltaLabel.value
          : this.metricDeltaLabel,
      metricDeltaValue: data.metricDeltaValue.present
          ? data.metricDeltaValue.value
          : this.metricDeltaValue,
      sourcesJson:
          data.sourcesJson.present ? data.sourcesJson.value : this.sourcesJson,
      rankScore: data.rankScore.present ? data.rankScore.value : this.rankScore,
      isExploratory: data.isExploratory.present
          ? data.isExploratory.value
          : this.isExploratory,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
      bookmarkCollection: data.bookmarkCollection.present
          ? data.bookmarkCollection.value
          : this.bookmarkCollection,
      bookmarkNote: data.bookmarkNote.present
          ? data.bookmarkNote.value
          : this.bookmarkNote,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      isExplored:
          data.isExplored.present ? data.isExplored.value : this.isExplored,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadarDiscoveryEntry(')
          ..write('id: $id, ')
          ..write('canonicalUrl: $canonicalUrl, ')
          ..write('title: $title, ')
          ..write('discoveryType: $discoveryType, ')
          ..write('primaryCategory: $primaryCategory, ')
          ..write('categoriesJson: $categoriesJson, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('priorityTier: $priorityTier, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceDomain: $sourceDomain, ')
          ..write('authorOrOrg: $authorOrOrg, ')
          ..write('publishedAtIso: $publishedAtIso, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('rawSummary: $rawSummary, ')
          ..write('plainEnglishSummary: $plainEnglishSummary, ')
          ..write('whyItMatters: $whyItMatters, ')
          ..write('whoItIsFor: $whoItIsFor, ')
          ..write('howItCompares: $howItCompares, ')
          ..write('practicalTakeaway: $practicalTakeaway, ')
          ..write('tryItSuggestion: $tryItSuggestion, ')
          ..write('beginnerNote: $beginnerNote, ')
          ..write('analysisSource: $analysisSource, ')
          ..write('primaryMetricLabel: $primaryMetricLabel, ')
          ..write('primaryMetricValue: $primaryMetricValue, ')
          ..write('secondaryMetricLabel: $secondaryMetricLabel, ')
          ..write('secondaryMetricValue: $secondaryMetricValue, ')
          ..write('metricDeltaLabel: $metricDeltaLabel, ')
          ..write('metricDeltaValue: $metricDeltaValue, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('rankScore: $rankScore, ')
          ..write('isExploratory: $isExploratory, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('bookmarkCollection: $bookmarkCollection, ')
          ..write('bookmarkNote: $bookmarkNote, ')
          ..write('isRead: $isRead, ')
          ..write('isExplored: $isExplored, ')
          ..write('isHidden: $isHidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        canonicalUrl,
        title,
        discoveryType,
        primaryCategory,
        categoriesJson,
        tagsJson,
        priorityTier,
        sourceName,
        sourceDomain,
        authorOrOrg,
        publishedAtIso,
        discoveredAt,
        rawSummary,
        plainEnglishSummary,
        whyItMatters,
        whoItIsFor,
        howItCompares,
        practicalTakeaway,
        tryItSuggestion,
        beginnerNote,
        analysisSource,
        primaryMetricLabel,
        primaryMetricValue,
        secondaryMetricLabel,
        secondaryMetricValue,
        metricDeltaLabel,
        metricDeltaValue,
        sourcesJson,
        rankScore,
        isExploratory,
        isBookmarked,
        bookmarkCollection,
        bookmarkNote,
        isRead,
        isExplored,
        isHidden
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadarDiscoveryEntry &&
          other.id == this.id &&
          other.canonicalUrl == this.canonicalUrl &&
          other.title == this.title &&
          other.discoveryType == this.discoveryType &&
          other.primaryCategory == this.primaryCategory &&
          other.categoriesJson == this.categoriesJson &&
          other.tagsJson == this.tagsJson &&
          other.priorityTier == this.priorityTier &&
          other.sourceName == this.sourceName &&
          other.sourceDomain == this.sourceDomain &&
          other.authorOrOrg == this.authorOrOrg &&
          other.publishedAtIso == this.publishedAtIso &&
          other.discoveredAt == this.discoveredAt &&
          other.rawSummary == this.rawSummary &&
          other.plainEnglishSummary == this.plainEnglishSummary &&
          other.whyItMatters == this.whyItMatters &&
          other.whoItIsFor == this.whoItIsFor &&
          other.howItCompares == this.howItCompares &&
          other.practicalTakeaway == this.practicalTakeaway &&
          other.tryItSuggestion == this.tryItSuggestion &&
          other.beginnerNote == this.beginnerNote &&
          other.analysisSource == this.analysisSource &&
          other.primaryMetricLabel == this.primaryMetricLabel &&
          other.primaryMetricValue == this.primaryMetricValue &&
          other.secondaryMetricLabel == this.secondaryMetricLabel &&
          other.secondaryMetricValue == this.secondaryMetricValue &&
          other.metricDeltaLabel == this.metricDeltaLabel &&
          other.metricDeltaValue == this.metricDeltaValue &&
          other.sourcesJson == this.sourcesJson &&
          other.rankScore == this.rankScore &&
          other.isExploratory == this.isExploratory &&
          other.isBookmarked == this.isBookmarked &&
          other.bookmarkCollection == this.bookmarkCollection &&
          other.bookmarkNote == this.bookmarkNote &&
          other.isRead == this.isRead &&
          other.isExplored == this.isExplored &&
          other.isHidden == this.isHidden);
}

class RadarDiscoveriesCompanion extends UpdateCompanion<RadarDiscoveryEntry> {
  final Value<String> id;
  final Value<String> canonicalUrl;
  final Value<String> title;
  final Value<String> discoveryType;
  final Value<String> primaryCategory;
  final Value<String> categoriesJson;
  final Value<String> tagsJson;
  final Value<String> priorityTier;
  final Value<String> sourceName;
  final Value<String> sourceDomain;
  final Value<String?> authorOrOrg;
  final Value<String?> publishedAtIso;
  final Value<DateTime> discoveredAt;
  final Value<String> rawSummary;
  final Value<String?> plainEnglishSummary;
  final Value<String?> whyItMatters;
  final Value<String?> whoItIsFor;
  final Value<String?> howItCompares;
  final Value<String?> practicalTakeaway;
  final Value<String?> tryItSuggestion;
  final Value<String?> beginnerNote;
  final Value<String> analysisSource;
  final Value<String?> primaryMetricLabel;
  final Value<double?> primaryMetricValue;
  final Value<String?> secondaryMetricLabel;
  final Value<double?> secondaryMetricValue;
  final Value<String?> metricDeltaLabel;
  final Value<double?> metricDeltaValue;
  final Value<String> sourcesJson;
  final Value<double> rankScore;
  final Value<bool> isExploratory;
  final Value<bool> isBookmarked;
  final Value<String?> bookmarkCollection;
  final Value<String?> bookmarkNote;
  final Value<bool> isRead;
  final Value<bool> isExplored;
  final Value<bool> isHidden;
  final Value<int> rowid;
  const RadarDiscoveriesCompanion({
    this.id = const Value.absent(),
    this.canonicalUrl = const Value.absent(),
    this.title = const Value.absent(),
    this.discoveryType = const Value.absent(),
    this.primaryCategory = const Value.absent(),
    this.categoriesJson = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.priorityTier = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceDomain = const Value.absent(),
    this.authorOrOrg = const Value.absent(),
    this.publishedAtIso = const Value.absent(),
    this.discoveredAt = const Value.absent(),
    this.rawSummary = const Value.absent(),
    this.plainEnglishSummary = const Value.absent(),
    this.whyItMatters = const Value.absent(),
    this.whoItIsFor = const Value.absent(),
    this.howItCompares = const Value.absent(),
    this.practicalTakeaway = const Value.absent(),
    this.tryItSuggestion = const Value.absent(),
    this.beginnerNote = const Value.absent(),
    this.analysisSource = const Value.absent(),
    this.primaryMetricLabel = const Value.absent(),
    this.primaryMetricValue = const Value.absent(),
    this.secondaryMetricLabel = const Value.absent(),
    this.secondaryMetricValue = const Value.absent(),
    this.metricDeltaLabel = const Value.absent(),
    this.metricDeltaValue = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.rankScore = const Value.absent(),
    this.isExploratory = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.bookmarkCollection = const Value.absent(),
    this.bookmarkNote = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isExplored = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RadarDiscoveriesCompanion.insert({
    required String id,
    required String canonicalUrl,
    required String title,
    required String discoveryType,
    required String primaryCategory,
    this.categoriesJson = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.priorityTier = const Value.absent(),
    required String sourceName,
    this.sourceDomain = const Value.absent(),
    this.authorOrOrg = const Value.absent(),
    this.publishedAtIso = const Value.absent(),
    required DateTime discoveredAt,
    this.rawSummary = const Value.absent(),
    this.plainEnglishSummary = const Value.absent(),
    this.whyItMatters = const Value.absent(),
    this.whoItIsFor = const Value.absent(),
    this.howItCompares = const Value.absent(),
    this.practicalTakeaway = const Value.absent(),
    this.tryItSuggestion = const Value.absent(),
    this.beginnerNote = const Value.absent(),
    this.analysisSource = const Value.absent(),
    this.primaryMetricLabel = const Value.absent(),
    this.primaryMetricValue = const Value.absent(),
    this.secondaryMetricLabel = const Value.absent(),
    this.secondaryMetricValue = const Value.absent(),
    this.metricDeltaLabel = const Value.absent(),
    this.metricDeltaValue = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.rankScore = const Value.absent(),
    this.isExploratory = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.bookmarkCollection = const Value.absent(),
    this.bookmarkNote = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isExplored = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        canonicalUrl = Value(canonicalUrl),
        title = Value(title),
        discoveryType = Value(discoveryType),
        primaryCategory = Value(primaryCategory),
        sourceName = Value(sourceName),
        discoveredAt = Value(discoveredAt);
  static Insertable<RadarDiscoveryEntry> custom({
    Expression<String>? id,
    Expression<String>? canonicalUrl,
    Expression<String>? title,
    Expression<String>? discoveryType,
    Expression<String>? primaryCategory,
    Expression<String>? categoriesJson,
    Expression<String>? tagsJson,
    Expression<String>? priorityTier,
    Expression<String>? sourceName,
    Expression<String>? sourceDomain,
    Expression<String>? authorOrOrg,
    Expression<String>? publishedAtIso,
    Expression<DateTime>? discoveredAt,
    Expression<String>? rawSummary,
    Expression<String>? plainEnglishSummary,
    Expression<String>? whyItMatters,
    Expression<String>? whoItIsFor,
    Expression<String>? howItCompares,
    Expression<String>? practicalTakeaway,
    Expression<String>? tryItSuggestion,
    Expression<String>? beginnerNote,
    Expression<String>? analysisSource,
    Expression<String>? primaryMetricLabel,
    Expression<double>? primaryMetricValue,
    Expression<String>? secondaryMetricLabel,
    Expression<double>? secondaryMetricValue,
    Expression<String>? metricDeltaLabel,
    Expression<double>? metricDeltaValue,
    Expression<String>? sourcesJson,
    Expression<double>? rankScore,
    Expression<bool>? isExploratory,
    Expression<bool>? isBookmarked,
    Expression<String>? bookmarkCollection,
    Expression<String>? bookmarkNote,
    Expression<bool>? isRead,
    Expression<bool>? isExplored,
    Expression<bool>? isHidden,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (canonicalUrl != null) 'canonical_url': canonicalUrl,
      if (title != null) 'title': title,
      if (discoveryType != null) 'discovery_type': discoveryType,
      if (primaryCategory != null) 'primary_category': primaryCategory,
      if (categoriesJson != null) 'categories_json': categoriesJson,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (priorityTier != null) 'priority_tier': priorityTier,
      if (sourceName != null) 'source_name': sourceName,
      if (sourceDomain != null) 'source_domain': sourceDomain,
      if (authorOrOrg != null) 'author_or_org': authorOrOrg,
      if (publishedAtIso != null) 'published_at_iso': publishedAtIso,
      if (discoveredAt != null) 'discovered_at': discoveredAt,
      if (rawSummary != null) 'raw_summary': rawSummary,
      if (plainEnglishSummary != null)
        'plain_english_summary': plainEnglishSummary,
      if (whyItMatters != null) 'why_it_matters': whyItMatters,
      if (whoItIsFor != null) 'who_it_is_for': whoItIsFor,
      if (howItCompares != null) 'how_it_compares': howItCompares,
      if (practicalTakeaway != null) 'practical_takeaway': practicalTakeaway,
      if (tryItSuggestion != null) 'try_it_suggestion': tryItSuggestion,
      if (beginnerNote != null) 'beginner_note': beginnerNote,
      if (analysisSource != null) 'analysis_source': analysisSource,
      if (primaryMetricLabel != null)
        'primary_metric_label': primaryMetricLabel,
      if (primaryMetricValue != null)
        'primary_metric_value': primaryMetricValue,
      if (secondaryMetricLabel != null)
        'secondary_metric_label': secondaryMetricLabel,
      if (secondaryMetricValue != null)
        'secondary_metric_value': secondaryMetricValue,
      if (metricDeltaLabel != null) 'metric_delta_label': metricDeltaLabel,
      if (metricDeltaValue != null) 'metric_delta_value': metricDeltaValue,
      if (sourcesJson != null) 'sources_json': sourcesJson,
      if (rankScore != null) 'rank_score': rankScore,
      if (isExploratory != null) 'is_exploratory': isExploratory,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
      if (bookmarkCollection != null) 'bookmark_collection': bookmarkCollection,
      if (bookmarkNote != null) 'bookmark_note': bookmarkNote,
      if (isRead != null) 'is_read': isRead,
      if (isExplored != null) 'is_explored': isExplored,
      if (isHidden != null) 'is_hidden': isHidden,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RadarDiscoveriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? canonicalUrl,
      Value<String>? title,
      Value<String>? discoveryType,
      Value<String>? primaryCategory,
      Value<String>? categoriesJson,
      Value<String>? tagsJson,
      Value<String>? priorityTier,
      Value<String>? sourceName,
      Value<String>? sourceDomain,
      Value<String?>? authorOrOrg,
      Value<String?>? publishedAtIso,
      Value<DateTime>? discoveredAt,
      Value<String>? rawSummary,
      Value<String?>? plainEnglishSummary,
      Value<String?>? whyItMatters,
      Value<String?>? whoItIsFor,
      Value<String?>? howItCompares,
      Value<String?>? practicalTakeaway,
      Value<String?>? tryItSuggestion,
      Value<String?>? beginnerNote,
      Value<String>? analysisSource,
      Value<String?>? primaryMetricLabel,
      Value<double?>? primaryMetricValue,
      Value<String?>? secondaryMetricLabel,
      Value<double?>? secondaryMetricValue,
      Value<String?>? metricDeltaLabel,
      Value<double?>? metricDeltaValue,
      Value<String>? sourcesJson,
      Value<double>? rankScore,
      Value<bool>? isExploratory,
      Value<bool>? isBookmarked,
      Value<String?>? bookmarkCollection,
      Value<String?>? bookmarkNote,
      Value<bool>? isRead,
      Value<bool>? isExplored,
      Value<bool>? isHidden,
      Value<int>? rowid}) {
    return RadarDiscoveriesCompanion(
      id: id ?? this.id,
      canonicalUrl: canonicalUrl ?? this.canonicalUrl,
      title: title ?? this.title,
      discoveryType: discoveryType ?? this.discoveryType,
      primaryCategory: primaryCategory ?? this.primaryCategory,
      categoriesJson: categoriesJson ?? this.categoriesJson,
      tagsJson: tagsJson ?? this.tagsJson,
      priorityTier: priorityTier ?? this.priorityTier,
      sourceName: sourceName ?? this.sourceName,
      sourceDomain: sourceDomain ?? this.sourceDomain,
      authorOrOrg: authorOrOrg ?? this.authorOrOrg,
      publishedAtIso: publishedAtIso ?? this.publishedAtIso,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      rawSummary: rawSummary ?? this.rawSummary,
      plainEnglishSummary: plainEnglishSummary ?? this.plainEnglishSummary,
      whyItMatters: whyItMatters ?? this.whyItMatters,
      whoItIsFor: whoItIsFor ?? this.whoItIsFor,
      howItCompares: howItCompares ?? this.howItCompares,
      practicalTakeaway: practicalTakeaway ?? this.practicalTakeaway,
      tryItSuggestion: tryItSuggestion ?? this.tryItSuggestion,
      beginnerNote: beginnerNote ?? this.beginnerNote,
      analysisSource: analysisSource ?? this.analysisSource,
      primaryMetricLabel: primaryMetricLabel ?? this.primaryMetricLabel,
      primaryMetricValue: primaryMetricValue ?? this.primaryMetricValue,
      secondaryMetricLabel: secondaryMetricLabel ?? this.secondaryMetricLabel,
      secondaryMetricValue: secondaryMetricValue ?? this.secondaryMetricValue,
      metricDeltaLabel: metricDeltaLabel ?? this.metricDeltaLabel,
      metricDeltaValue: metricDeltaValue ?? this.metricDeltaValue,
      sourcesJson: sourcesJson ?? this.sourcesJson,
      rankScore: rankScore ?? this.rankScore,
      isExploratory: isExploratory ?? this.isExploratory,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      bookmarkCollection: bookmarkCollection ?? this.bookmarkCollection,
      bookmarkNote: bookmarkNote ?? this.bookmarkNote,
      isRead: isRead ?? this.isRead,
      isExplored: isExplored ?? this.isExplored,
      isHidden: isHidden ?? this.isHidden,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (canonicalUrl.present) {
      map['canonical_url'] = Variable<String>(canonicalUrl.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (discoveryType.present) {
      map['discovery_type'] = Variable<String>(discoveryType.value);
    }
    if (primaryCategory.present) {
      map['primary_category'] = Variable<String>(primaryCategory.value);
    }
    if (categoriesJson.present) {
      map['categories_json'] = Variable<String>(categoriesJson.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (priorityTier.present) {
      map['priority_tier'] = Variable<String>(priorityTier.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (sourceDomain.present) {
      map['source_domain'] = Variable<String>(sourceDomain.value);
    }
    if (authorOrOrg.present) {
      map['author_or_org'] = Variable<String>(authorOrOrg.value);
    }
    if (publishedAtIso.present) {
      map['published_at_iso'] = Variable<String>(publishedAtIso.value);
    }
    if (discoveredAt.present) {
      map['discovered_at'] = Variable<DateTime>(discoveredAt.value);
    }
    if (rawSummary.present) {
      map['raw_summary'] = Variable<String>(rawSummary.value);
    }
    if (plainEnglishSummary.present) {
      map['plain_english_summary'] =
          Variable<String>(plainEnglishSummary.value);
    }
    if (whyItMatters.present) {
      map['why_it_matters'] = Variable<String>(whyItMatters.value);
    }
    if (whoItIsFor.present) {
      map['who_it_is_for'] = Variable<String>(whoItIsFor.value);
    }
    if (howItCompares.present) {
      map['how_it_compares'] = Variable<String>(howItCompares.value);
    }
    if (practicalTakeaway.present) {
      map['practical_takeaway'] = Variable<String>(practicalTakeaway.value);
    }
    if (tryItSuggestion.present) {
      map['try_it_suggestion'] = Variable<String>(tryItSuggestion.value);
    }
    if (beginnerNote.present) {
      map['beginner_note'] = Variable<String>(beginnerNote.value);
    }
    if (analysisSource.present) {
      map['analysis_source'] = Variable<String>(analysisSource.value);
    }
    if (primaryMetricLabel.present) {
      map['primary_metric_label'] = Variable<String>(primaryMetricLabel.value);
    }
    if (primaryMetricValue.present) {
      map['primary_metric_value'] = Variable<double>(primaryMetricValue.value);
    }
    if (secondaryMetricLabel.present) {
      map['secondary_metric_label'] =
          Variable<String>(secondaryMetricLabel.value);
    }
    if (secondaryMetricValue.present) {
      map['secondary_metric_value'] =
          Variable<double>(secondaryMetricValue.value);
    }
    if (metricDeltaLabel.present) {
      map['metric_delta_label'] = Variable<String>(metricDeltaLabel.value);
    }
    if (metricDeltaValue.present) {
      map['metric_delta_value'] = Variable<double>(metricDeltaValue.value);
    }
    if (sourcesJson.present) {
      map['sources_json'] = Variable<String>(sourcesJson.value);
    }
    if (rankScore.present) {
      map['rank_score'] = Variable<double>(rankScore.value);
    }
    if (isExploratory.present) {
      map['is_exploratory'] = Variable<bool>(isExploratory.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    if (bookmarkCollection.present) {
      map['bookmark_collection'] = Variable<String>(bookmarkCollection.value);
    }
    if (bookmarkNote.present) {
      map['bookmark_note'] = Variable<String>(bookmarkNote.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (isExplored.present) {
      map['is_explored'] = Variable<bool>(isExplored.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadarDiscoveriesCompanion(')
          ..write('id: $id, ')
          ..write('canonicalUrl: $canonicalUrl, ')
          ..write('title: $title, ')
          ..write('discoveryType: $discoveryType, ')
          ..write('primaryCategory: $primaryCategory, ')
          ..write('categoriesJson: $categoriesJson, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('priorityTier: $priorityTier, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceDomain: $sourceDomain, ')
          ..write('authorOrOrg: $authorOrOrg, ')
          ..write('publishedAtIso: $publishedAtIso, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('rawSummary: $rawSummary, ')
          ..write('plainEnglishSummary: $plainEnglishSummary, ')
          ..write('whyItMatters: $whyItMatters, ')
          ..write('whoItIsFor: $whoItIsFor, ')
          ..write('howItCompares: $howItCompares, ')
          ..write('practicalTakeaway: $practicalTakeaway, ')
          ..write('tryItSuggestion: $tryItSuggestion, ')
          ..write('beginnerNote: $beginnerNote, ')
          ..write('analysisSource: $analysisSource, ')
          ..write('primaryMetricLabel: $primaryMetricLabel, ')
          ..write('primaryMetricValue: $primaryMetricValue, ')
          ..write('secondaryMetricLabel: $secondaryMetricLabel, ')
          ..write('secondaryMetricValue: $secondaryMetricValue, ')
          ..write('metricDeltaLabel: $metricDeltaLabel, ')
          ..write('metricDeltaValue: $metricDeltaValue, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('rankScore: $rankScore, ')
          ..write('isExploratory: $isExploratory, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('bookmarkCollection: $bookmarkCollection, ')
          ..write('bookmarkNote: $bookmarkNote, ')
          ..write('isRead: $isRead, ')
          ..write('isExplored: $isExplored, ')
          ..write('isHidden: $isHidden, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadarTopicPrefsTable extends RadarTopicPrefs
    with TableInfo<$RadarTopicPrefsTable, RadarTopicPrefEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadarTopicPrefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryCodeMeta =
      const VerificationMeta('categoryCode');
  @override
  late final GeneratedColumn<String> categoryCode = GeneratedColumn<String>(
      'category_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityLevelMeta =
      const VerificationMeta('priorityLevel');
  @override
  late final GeneratedColumn<String> priorityLevel = GeneratedColumn<String>(
      'priority_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('P1'));
  static const VerificationMeta _isMutedMeta =
      const VerificationMeta('isMuted');
  @override
  late final GeneratedColumn<bool> isMuted = GeneratedColumn<bool>(
      'is_muted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_muted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _boostKeywordsJsonMeta =
      const VerificationMeta('boostKeywordsJson');
  @override
  late final GeneratedColumn<String> boostKeywordsJson =
      GeneratedColumn<String>('boost_keywords_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _mutedKeywordsJsonMeta =
      const VerificationMeta('mutedKeywordsJson');
  @override
  late final GeneratedColumn<String> mutedKeywordsJson =
      GeneratedColumn<String>('muted_keywords_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _affinityAdjustmentMeta =
      const VerificationMeta('affinityAdjustment');
  @override
  late final GeneratedColumn<double> affinityAdjustment =
      GeneratedColumn<double>('affinity_adjustment', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        categoryCode,
        categoryName,
        priorityLevel,
        isMuted,
        boostKeywordsJson,
        mutedKeywordsJson,
        affinityAdjustment,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radar_topic_prefs';
  @override
  VerificationContext validateIntegrity(
      Insertable<RadarTopicPrefEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_code')) {
      context.handle(
          _categoryCodeMeta,
          categoryCode.isAcceptableOrUnknown(
              data['category_code']!, _categoryCodeMeta));
    } else if (isInserting) {
      context.missing(_categoryCodeMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('priority_level')) {
      context.handle(
          _priorityLevelMeta,
          priorityLevel.isAcceptableOrUnknown(
              data['priority_level']!, _priorityLevelMeta));
    }
    if (data.containsKey('is_muted')) {
      context.handle(_isMutedMeta,
          isMuted.isAcceptableOrUnknown(data['is_muted']!, _isMutedMeta));
    }
    if (data.containsKey('boost_keywords_json')) {
      context.handle(
          _boostKeywordsJsonMeta,
          boostKeywordsJson.isAcceptableOrUnknown(
              data['boost_keywords_json']!, _boostKeywordsJsonMeta));
    }
    if (data.containsKey('muted_keywords_json')) {
      context.handle(
          _mutedKeywordsJsonMeta,
          mutedKeywordsJson.isAcceptableOrUnknown(
              data['muted_keywords_json']!, _mutedKeywordsJsonMeta));
    }
    if (data.containsKey('affinity_adjustment')) {
      context.handle(
          _affinityAdjustmentMeta,
          affinityAdjustment.isAcceptableOrUnknown(
              data['affinity_adjustment']!, _affinityAdjustmentMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryCode};
  @override
  RadarTopicPrefEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadarTopicPrefEntry(
      categoryCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_code'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      priorityLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority_level'])!,
      isMuted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_muted'])!,
      boostKeywordsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}boost_keywords_json'])!,
      mutedKeywordsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}muted_keywords_json'])!,
      affinityAdjustment: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}affinity_adjustment'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RadarTopicPrefsTable createAlias(String alias) {
    return $RadarTopicPrefsTable(attachedDatabase, alias);
  }
}

class RadarTopicPrefEntry extends DataClass
    implements Insertable<RadarTopicPrefEntry> {
  final String categoryCode;
  final String categoryName;
  final String priorityLevel;
  final bool isMuted;
  final String boostKeywordsJson;
  final String mutedKeywordsJson;
  final double affinityAdjustment;
  final DateTime updatedAt;
  const RadarTopicPrefEntry(
      {required this.categoryCode,
      required this.categoryName,
      required this.priorityLevel,
      required this.isMuted,
      required this.boostKeywordsJson,
      required this.mutedKeywordsJson,
      required this.affinityAdjustment,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_code'] = Variable<String>(categoryCode);
    map['category_name'] = Variable<String>(categoryName);
    map['priority_level'] = Variable<String>(priorityLevel);
    map['is_muted'] = Variable<bool>(isMuted);
    map['boost_keywords_json'] = Variable<String>(boostKeywordsJson);
    map['muted_keywords_json'] = Variable<String>(mutedKeywordsJson);
    map['affinity_adjustment'] = Variable<double>(affinityAdjustment);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RadarTopicPrefsCompanion toCompanion(bool nullToAbsent) {
    return RadarTopicPrefsCompanion(
      categoryCode: Value(categoryCode),
      categoryName: Value(categoryName),
      priorityLevel: Value(priorityLevel),
      isMuted: Value(isMuted),
      boostKeywordsJson: Value(boostKeywordsJson),
      mutedKeywordsJson: Value(mutedKeywordsJson),
      affinityAdjustment: Value(affinityAdjustment),
      updatedAt: Value(updatedAt),
    );
  }

  factory RadarTopicPrefEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadarTopicPrefEntry(
      categoryCode: serializer.fromJson<String>(json['categoryCode']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      priorityLevel: serializer.fromJson<String>(json['priorityLevel']),
      isMuted: serializer.fromJson<bool>(json['isMuted']),
      boostKeywordsJson: serializer.fromJson<String>(json['boostKeywordsJson']),
      mutedKeywordsJson: serializer.fromJson<String>(json['mutedKeywordsJson']),
      affinityAdjustment:
          serializer.fromJson<double>(json['affinityAdjustment']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryCode': serializer.toJson<String>(categoryCode),
      'categoryName': serializer.toJson<String>(categoryName),
      'priorityLevel': serializer.toJson<String>(priorityLevel),
      'isMuted': serializer.toJson<bool>(isMuted),
      'boostKeywordsJson': serializer.toJson<String>(boostKeywordsJson),
      'mutedKeywordsJson': serializer.toJson<String>(mutedKeywordsJson),
      'affinityAdjustment': serializer.toJson<double>(affinityAdjustment),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RadarTopicPrefEntry copyWith(
          {String? categoryCode,
          String? categoryName,
          String? priorityLevel,
          bool? isMuted,
          String? boostKeywordsJson,
          String? mutedKeywordsJson,
          double? affinityAdjustment,
          DateTime? updatedAt}) =>
      RadarTopicPrefEntry(
        categoryCode: categoryCode ?? this.categoryCode,
        categoryName: categoryName ?? this.categoryName,
        priorityLevel: priorityLevel ?? this.priorityLevel,
        isMuted: isMuted ?? this.isMuted,
        boostKeywordsJson: boostKeywordsJson ?? this.boostKeywordsJson,
        mutedKeywordsJson: mutedKeywordsJson ?? this.mutedKeywordsJson,
        affinityAdjustment: affinityAdjustment ?? this.affinityAdjustment,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RadarTopicPrefEntry copyWithCompanion(RadarTopicPrefsCompanion data) {
    return RadarTopicPrefEntry(
      categoryCode: data.categoryCode.present
          ? data.categoryCode.value
          : this.categoryCode,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      priorityLevel: data.priorityLevel.present
          ? data.priorityLevel.value
          : this.priorityLevel,
      isMuted: data.isMuted.present ? data.isMuted.value : this.isMuted,
      boostKeywordsJson: data.boostKeywordsJson.present
          ? data.boostKeywordsJson.value
          : this.boostKeywordsJson,
      mutedKeywordsJson: data.mutedKeywordsJson.present
          ? data.mutedKeywordsJson.value
          : this.mutedKeywordsJson,
      affinityAdjustment: data.affinityAdjustment.present
          ? data.affinityAdjustment.value
          : this.affinityAdjustment,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadarTopicPrefEntry(')
          ..write('categoryCode: $categoryCode, ')
          ..write('categoryName: $categoryName, ')
          ..write('priorityLevel: $priorityLevel, ')
          ..write('isMuted: $isMuted, ')
          ..write('boostKeywordsJson: $boostKeywordsJson, ')
          ..write('mutedKeywordsJson: $mutedKeywordsJson, ')
          ..write('affinityAdjustment: $affinityAdjustment, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      categoryCode,
      categoryName,
      priorityLevel,
      isMuted,
      boostKeywordsJson,
      mutedKeywordsJson,
      affinityAdjustment,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadarTopicPrefEntry &&
          other.categoryCode == this.categoryCode &&
          other.categoryName == this.categoryName &&
          other.priorityLevel == this.priorityLevel &&
          other.isMuted == this.isMuted &&
          other.boostKeywordsJson == this.boostKeywordsJson &&
          other.mutedKeywordsJson == this.mutedKeywordsJson &&
          other.affinityAdjustment == this.affinityAdjustment &&
          other.updatedAt == this.updatedAt);
}

class RadarTopicPrefsCompanion extends UpdateCompanion<RadarTopicPrefEntry> {
  final Value<String> categoryCode;
  final Value<String> categoryName;
  final Value<String> priorityLevel;
  final Value<bool> isMuted;
  final Value<String> boostKeywordsJson;
  final Value<String> mutedKeywordsJson;
  final Value<double> affinityAdjustment;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RadarTopicPrefsCompanion({
    this.categoryCode = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.priorityLevel = const Value.absent(),
    this.isMuted = const Value.absent(),
    this.boostKeywordsJson = const Value.absent(),
    this.mutedKeywordsJson = const Value.absent(),
    this.affinityAdjustment = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RadarTopicPrefsCompanion.insert({
    required String categoryCode,
    required String categoryName,
    this.priorityLevel = const Value.absent(),
    this.isMuted = const Value.absent(),
    this.boostKeywordsJson = const Value.absent(),
    this.mutedKeywordsJson = const Value.absent(),
    this.affinityAdjustment = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : categoryCode = Value(categoryCode),
        categoryName = Value(categoryName),
        updatedAt = Value(updatedAt);
  static Insertable<RadarTopicPrefEntry> custom({
    Expression<String>? categoryCode,
    Expression<String>? categoryName,
    Expression<String>? priorityLevel,
    Expression<bool>? isMuted,
    Expression<String>? boostKeywordsJson,
    Expression<String>? mutedKeywordsJson,
    Expression<double>? affinityAdjustment,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categoryCode != null) 'category_code': categoryCode,
      if (categoryName != null) 'category_name': categoryName,
      if (priorityLevel != null) 'priority_level': priorityLevel,
      if (isMuted != null) 'is_muted': isMuted,
      if (boostKeywordsJson != null) 'boost_keywords_json': boostKeywordsJson,
      if (mutedKeywordsJson != null) 'muted_keywords_json': mutedKeywordsJson,
      if (affinityAdjustment != null) 'affinity_adjustment': affinityAdjustment,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RadarTopicPrefsCompanion copyWith(
      {Value<String>? categoryCode,
      Value<String>? categoryName,
      Value<String>? priorityLevel,
      Value<bool>? isMuted,
      Value<String>? boostKeywordsJson,
      Value<String>? mutedKeywordsJson,
      Value<double>? affinityAdjustment,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RadarTopicPrefsCompanion(
      categoryCode: categoryCode ?? this.categoryCode,
      categoryName: categoryName ?? this.categoryName,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      isMuted: isMuted ?? this.isMuted,
      boostKeywordsJson: boostKeywordsJson ?? this.boostKeywordsJson,
      mutedKeywordsJson: mutedKeywordsJson ?? this.mutedKeywordsJson,
      affinityAdjustment: affinityAdjustment ?? this.affinityAdjustment,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryCode.present) {
      map['category_code'] = Variable<String>(categoryCode.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (priorityLevel.present) {
      map['priority_level'] = Variable<String>(priorityLevel.value);
    }
    if (isMuted.present) {
      map['is_muted'] = Variable<bool>(isMuted.value);
    }
    if (boostKeywordsJson.present) {
      map['boost_keywords_json'] = Variable<String>(boostKeywordsJson.value);
    }
    if (mutedKeywordsJson.present) {
      map['muted_keywords_json'] = Variable<String>(mutedKeywordsJson.value);
    }
    if (affinityAdjustment.present) {
      map['affinity_adjustment'] = Variable<double>(affinityAdjustment.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadarTopicPrefsCompanion(')
          ..write('categoryCode: $categoryCode, ')
          ..write('categoryName: $categoryName, ')
          ..write('priorityLevel: $priorityLevel, ')
          ..write('isMuted: $isMuted, ')
          ..write('boostKeywordsJson: $boostKeywordsJson, ')
          ..write('mutedKeywordsJson: $mutedKeywordsJson, ')
          ..write('affinityAdjustment: $affinityAdjustment, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadarFollowsTable extends RadarFollows
    with TableInfo<$RadarFollowsTable, RadarFollowEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadarFollowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _followTypeMeta =
      const VerificationMeta('followType');
  @override
  late final GeneratedColumn<String> followType = GeneratedColumn<String>(
      'follow_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetKeyMeta =
      const VerificationMeta('targetKey');
  @override
  late final GeneratedColumn<String> targetKey = GeneratedColumn<String>(
      'target_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, followType, targetKey, displayName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radar_follows';
  @override
  VerificationContext validateIntegrity(Insertable<RadarFollowEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('follow_type')) {
      context.handle(
          _followTypeMeta,
          followType.isAcceptableOrUnknown(
              data['follow_type']!, _followTypeMeta));
    } else if (isInserting) {
      context.missing(_followTypeMeta);
    }
    if (data.containsKey('target_key')) {
      context.handle(_targetKeyMeta,
          targetKey.isAcceptableOrUnknown(data['target_key']!, _targetKeyMeta));
    } else if (isInserting) {
      context.missing(_targetKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RadarFollowEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadarFollowEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      followType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}follow_type'])!,
      targetKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_key'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RadarFollowsTable createAlias(String alias) {
    return $RadarFollowsTable(attachedDatabase, alias);
  }
}

class RadarFollowEntry extends DataClass
    implements Insertable<RadarFollowEntry> {
  final String id;
  final String followType;
  final String targetKey;
  final String displayName;
  final DateTime createdAt;
  const RadarFollowEntry(
      {required this.id,
      required this.followType,
      required this.targetKey,
      required this.displayName,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['follow_type'] = Variable<String>(followType);
    map['target_key'] = Variable<String>(targetKey);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RadarFollowsCompanion toCompanion(bool nullToAbsent) {
    return RadarFollowsCompanion(
      id: Value(id),
      followType: Value(followType),
      targetKey: Value(targetKey),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
    );
  }

  factory RadarFollowEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadarFollowEntry(
      id: serializer.fromJson<String>(json['id']),
      followType: serializer.fromJson<String>(json['followType']),
      targetKey: serializer.fromJson<String>(json['targetKey']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'followType': serializer.toJson<String>(followType),
      'targetKey': serializer.toJson<String>(targetKey),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RadarFollowEntry copyWith(
          {String? id,
          String? followType,
          String? targetKey,
          String? displayName,
          DateTime? createdAt}) =>
      RadarFollowEntry(
        id: id ?? this.id,
        followType: followType ?? this.followType,
        targetKey: targetKey ?? this.targetKey,
        displayName: displayName ?? this.displayName,
        createdAt: createdAt ?? this.createdAt,
      );
  RadarFollowEntry copyWithCompanion(RadarFollowsCompanion data) {
    return RadarFollowEntry(
      id: data.id.present ? data.id.value : this.id,
      followType:
          data.followType.present ? data.followType.value : this.followType,
      targetKey: data.targetKey.present ? data.targetKey.value : this.targetKey,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadarFollowEntry(')
          ..write('id: $id, ')
          ..write('followType: $followType, ')
          ..write('targetKey: $targetKey, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, followType, targetKey, displayName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadarFollowEntry &&
          other.id == this.id &&
          other.followType == this.followType &&
          other.targetKey == this.targetKey &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt);
}

class RadarFollowsCompanion extends UpdateCompanion<RadarFollowEntry> {
  final Value<String> id;
  final Value<String> followType;
  final Value<String> targetKey;
  final Value<String> displayName;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RadarFollowsCompanion({
    this.id = const Value.absent(),
    this.followType = const Value.absent(),
    this.targetKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RadarFollowsCompanion.insert({
    required String id,
    required String followType,
    required String targetKey,
    required String displayName,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        followType = Value(followType),
        targetKey = Value(targetKey),
        displayName = Value(displayName),
        createdAt = Value(createdAt);
  static Insertable<RadarFollowEntry> custom({
    Expression<String>? id,
    Expression<String>? followType,
    Expression<String>? targetKey,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (followType != null) 'follow_type': followType,
      if (targetKey != null) 'target_key': targetKey,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RadarFollowsCompanion copyWith(
      {Value<String>? id,
      Value<String>? followType,
      Value<String>? targetKey,
      Value<String>? displayName,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RadarFollowsCompanion(
      id: id ?? this.id,
      followType: followType ?? this.followType,
      targetKey: targetKey ?? this.targetKey,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (followType.present) {
      map['follow_type'] = Variable<String>(followType.value);
    }
    if (targetKey.present) {
      map['target_key'] = Variable<String>(targetKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadarFollowsCompanion(')
          ..write('id: $id, ')
          ..write('followType: $followType, ')
          ..write('targetKey: $targetKey, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadarFeedbackLogsTable extends RadarFeedbackLogs
    with TableInfo<$RadarFeedbackLogsTable, RadarFeedbackLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadarFeedbackLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _discoveryIdMeta =
      const VerificationMeta('discoveryId');
  @override
  late final GeneratedColumn<String> discoveryId = GeneratedColumn<String>(
      'discovery_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryCodeMeta =
      const VerificationMeta('categoryCode');
  @override
  late final GeneratedColumn<String> categoryCode = GeneratedColumn<String>(
      'category_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, discoveryId, action, categoryCode, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radar_feedback_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<RadarFeedbackLogEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('discovery_id')) {
      context.handle(
          _discoveryIdMeta,
          discoveryId.isAcceptableOrUnknown(
              data['discovery_id']!, _discoveryIdMeta));
    } else if (isInserting) {
      context.missing(_discoveryIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('category_code')) {
      context.handle(
          _categoryCodeMeta,
          categoryCode.isAcceptableOrUnknown(
              data['category_code']!, _categoryCodeMeta));
    } else if (isInserting) {
      context.missing(_categoryCodeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RadarFeedbackLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadarFeedbackLogEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      discoveryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}discovery_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      categoryCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_code'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RadarFeedbackLogsTable createAlias(String alias) {
    return $RadarFeedbackLogsTable(attachedDatabase, alias);
  }
}

class RadarFeedbackLogEntry extends DataClass
    implements Insertable<RadarFeedbackLogEntry> {
  final String id;
  final String discoveryId;
  final String action;
  final String categoryCode;
  final DateTime createdAt;
  const RadarFeedbackLogEntry(
      {required this.id,
      required this.discoveryId,
      required this.action,
      required this.categoryCode,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['discovery_id'] = Variable<String>(discoveryId);
    map['action'] = Variable<String>(action);
    map['category_code'] = Variable<String>(categoryCode);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RadarFeedbackLogsCompanion toCompanion(bool nullToAbsent) {
    return RadarFeedbackLogsCompanion(
      id: Value(id),
      discoveryId: Value(discoveryId),
      action: Value(action),
      categoryCode: Value(categoryCode),
      createdAt: Value(createdAt),
    );
  }

  factory RadarFeedbackLogEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadarFeedbackLogEntry(
      id: serializer.fromJson<String>(json['id']),
      discoveryId: serializer.fromJson<String>(json['discoveryId']),
      action: serializer.fromJson<String>(json['action']),
      categoryCode: serializer.fromJson<String>(json['categoryCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'discoveryId': serializer.toJson<String>(discoveryId),
      'action': serializer.toJson<String>(action),
      'categoryCode': serializer.toJson<String>(categoryCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RadarFeedbackLogEntry copyWith(
          {String? id,
          String? discoveryId,
          String? action,
          String? categoryCode,
          DateTime? createdAt}) =>
      RadarFeedbackLogEntry(
        id: id ?? this.id,
        discoveryId: discoveryId ?? this.discoveryId,
        action: action ?? this.action,
        categoryCode: categoryCode ?? this.categoryCode,
        createdAt: createdAt ?? this.createdAt,
      );
  RadarFeedbackLogEntry copyWithCompanion(RadarFeedbackLogsCompanion data) {
    return RadarFeedbackLogEntry(
      id: data.id.present ? data.id.value : this.id,
      discoveryId:
          data.discoveryId.present ? data.discoveryId.value : this.discoveryId,
      action: data.action.present ? data.action.value : this.action,
      categoryCode: data.categoryCode.present
          ? data.categoryCode.value
          : this.categoryCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadarFeedbackLogEntry(')
          ..write('id: $id, ')
          ..write('discoveryId: $discoveryId, ')
          ..write('action: $action, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, discoveryId, action, categoryCode, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadarFeedbackLogEntry &&
          other.id == this.id &&
          other.discoveryId == this.discoveryId &&
          other.action == this.action &&
          other.categoryCode == this.categoryCode &&
          other.createdAt == this.createdAt);
}

class RadarFeedbackLogsCompanion
    extends UpdateCompanion<RadarFeedbackLogEntry> {
  final Value<String> id;
  final Value<String> discoveryId;
  final Value<String> action;
  final Value<String> categoryCode;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RadarFeedbackLogsCompanion({
    this.id = const Value.absent(),
    this.discoveryId = const Value.absent(),
    this.action = const Value.absent(),
    this.categoryCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RadarFeedbackLogsCompanion.insert({
    required String id,
    required String discoveryId,
    required String action,
    required String categoryCode,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        discoveryId = Value(discoveryId),
        action = Value(action),
        categoryCode = Value(categoryCode),
        createdAt = Value(createdAt);
  static Insertable<RadarFeedbackLogEntry> custom({
    Expression<String>? id,
    Expression<String>? discoveryId,
    Expression<String>? action,
    Expression<String>? categoryCode,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (discoveryId != null) 'discovery_id': discoveryId,
      if (action != null) 'action': action,
      if (categoryCode != null) 'category_code': categoryCode,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RadarFeedbackLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? discoveryId,
      Value<String>? action,
      Value<String>? categoryCode,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RadarFeedbackLogsCompanion(
      id: id ?? this.id,
      discoveryId: discoveryId ?? this.discoveryId,
      action: action ?? this.action,
      categoryCode: categoryCode ?? this.categoryCode,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (discoveryId.present) {
      map['discovery_id'] = Variable<String>(discoveryId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (categoryCode.present) {
      map['category_code'] = Variable<String>(categoryCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadarFeedbackLogsCompanion(')
          ..write('id: $id, ')
          ..write('discoveryId: $discoveryId, ')
          ..write('action: $action, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RadarBriefingsTable extends RadarBriefings
    with TableInfo<$RadarBriefingsTable, RadarBriefingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RadarBriefingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _briefingTypeMeta =
      const VerificationMeta('briefingType');
  @override
  late final GeneratedColumn<String> briefingType = GeneratedColumn<String>(
      'briefing_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _briefingDateMeta =
      const VerificationMeta('briefingDate');
  @override
  late final GeneratedColumn<String> briefingDate = GeneratedColumn<String>(
      'briefing_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _headlineMeta =
      const VerificationMeta('headline');
  @override
  late final GeneratedColumn<String> headline = GeneratedColumn<String>(
      'headline', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sectionsJsonMeta =
      const VerificationMeta('sectionsJson');
  @override
  late final GeneratedColumn<String> sectionsJson = GeneratedColumn<String>(
      'sections_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _generatedByMeta =
      const VerificationMeta('generatedBy');
  @override
  late final GeneratedColumn<String> generatedBy = GeneratedColumn<String>(
      'generated_by', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('radar_curator'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        briefingType,
        briefingDate,
        headline,
        sectionsJson,
        generatedBy,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'radar_briefings';
  @override
  VerificationContext validateIntegrity(Insertable<RadarBriefingEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('briefing_type')) {
      context.handle(
          _briefingTypeMeta,
          briefingType.isAcceptableOrUnknown(
              data['briefing_type']!, _briefingTypeMeta));
    } else if (isInserting) {
      context.missing(_briefingTypeMeta);
    }
    if (data.containsKey('briefing_date')) {
      context.handle(
          _briefingDateMeta,
          briefingDate.isAcceptableOrUnknown(
              data['briefing_date']!, _briefingDateMeta));
    } else if (isInserting) {
      context.missing(_briefingDateMeta);
    }
    if (data.containsKey('headline')) {
      context.handle(_headlineMeta,
          headline.isAcceptableOrUnknown(data['headline']!, _headlineMeta));
    } else if (isInserting) {
      context.missing(_headlineMeta);
    }
    if (data.containsKey('sections_json')) {
      context.handle(
          _sectionsJsonMeta,
          sectionsJson.isAcceptableOrUnknown(
              data['sections_json']!, _sectionsJsonMeta));
    } else if (isInserting) {
      context.missing(_sectionsJsonMeta);
    }
    if (data.containsKey('generated_by')) {
      context.handle(
          _generatedByMeta,
          generatedBy.isAcceptableOrUnknown(
              data['generated_by']!, _generatedByMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RadarBriefingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RadarBriefingEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      briefingType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}briefing_type'])!,
      briefingDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}briefing_date'])!,
      headline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}headline'])!,
      sectionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sections_json'])!,
      generatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}generated_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RadarBriefingsTable createAlias(String alias) {
    return $RadarBriefingsTable(attachedDatabase, alias);
  }
}

class RadarBriefingEntry extends DataClass
    implements Insertable<RadarBriefingEntry> {
  final String id;
  final String briefingType;
  final String briefingDate;
  final String headline;
  final String sectionsJson;
  final String generatedBy;
  final DateTime createdAt;
  const RadarBriefingEntry(
      {required this.id,
      required this.briefingType,
      required this.briefingDate,
      required this.headline,
      required this.sectionsJson,
      required this.generatedBy,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['briefing_type'] = Variable<String>(briefingType);
    map['briefing_date'] = Variable<String>(briefingDate);
    map['headline'] = Variable<String>(headline);
    map['sections_json'] = Variable<String>(sectionsJson);
    map['generated_by'] = Variable<String>(generatedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RadarBriefingsCompanion toCompanion(bool nullToAbsent) {
    return RadarBriefingsCompanion(
      id: Value(id),
      briefingType: Value(briefingType),
      briefingDate: Value(briefingDate),
      headline: Value(headline),
      sectionsJson: Value(sectionsJson),
      generatedBy: Value(generatedBy),
      createdAt: Value(createdAt),
    );
  }

  factory RadarBriefingEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RadarBriefingEntry(
      id: serializer.fromJson<String>(json['id']),
      briefingType: serializer.fromJson<String>(json['briefingType']),
      briefingDate: serializer.fromJson<String>(json['briefingDate']),
      headline: serializer.fromJson<String>(json['headline']),
      sectionsJson: serializer.fromJson<String>(json['sectionsJson']),
      generatedBy: serializer.fromJson<String>(json['generatedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'briefingType': serializer.toJson<String>(briefingType),
      'briefingDate': serializer.toJson<String>(briefingDate),
      'headline': serializer.toJson<String>(headline),
      'sectionsJson': serializer.toJson<String>(sectionsJson),
      'generatedBy': serializer.toJson<String>(generatedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RadarBriefingEntry copyWith(
          {String? id,
          String? briefingType,
          String? briefingDate,
          String? headline,
          String? sectionsJson,
          String? generatedBy,
          DateTime? createdAt}) =>
      RadarBriefingEntry(
        id: id ?? this.id,
        briefingType: briefingType ?? this.briefingType,
        briefingDate: briefingDate ?? this.briefingDate,
        headline: headline ?? this.headline,
        sectionsJson: sectionsJson ?? this.sectionsJson,
        generatedBy: generatedBy ?? this.generatedBy,
        createdAt: createdAt ?? this.createdAt,
      );
  RadarBriefingEntry copyWithCompanion(RadarBriefingsCompanion data) {
    return RadarBriefingEntry(
      id: data.id.present ? data.id.value : this.id,
      briefingType: data.briefingType.present
          ? data.briefingType.value
          : this.briefingType,
      briefingDate: data.briefingDate.present
          ? data.briefingDate.value
          : this.briefingDate,
      headline: data.headline.present ? data.headline.value : this.headline,
      sectionsJson: data.sectionsJson.present
          ? data.sectionsJson.value
          : this.sectionsJson,
      generatedBy:
          data.generatedBy.present ? data.generatedBy.value : this.generatedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RadarBriefingEntry(')
          ..write('id: $id, ')
          ..write('briefingType: $briefingType, ')
          ..write('briefingDate: $briefingDate, ')
          ..write('headline: $headline, ')
          ..write('sectionsJson: $sectionsJson, ')
          ..write('generatedBy: $generatedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, briefingType, briefingDate, headline,
      sectionsJson, generatedBy, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RadarBriefingEntry &&
          other.id == this.id &&
          other.briefingType == this.briefingType &&
          other.briefingDate == this.briefingDate &&
          other.headline == this.headline &&
          other.sectionsJson == this.sectionsJson &&
          other.generatedBy == this.generatedBy &&
          other.createdAt == this.createdAt);
}

class RadarBriefingsCompanion extends UpdateCompanion<RadarBriefingEntry> {
  final Value<String> id;
  final Value<String> briefingType;
  final Value<String> briefingDate;
  final Value<String> headline;
  final Value<String> sectionsJson;
  final Value<String> generatedBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RadarBriefingsCompanion({
    this.id = const Value.absent(),
    this.briefingType = const Value.absent(),
    this.briefingDate = const Value.absent(),
    this.headline = const Value.absent(),
    this.sectionsJson = const Value.absent(),
    this.generatedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RadarBriefingsCompanion.insert({
    required String id,
    required String briefingType,
    required String briefingDate,
    required String headline,
    required String sectionsJson,
    this.generatedBy = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        briefingType = Value(briefingType),
        briefingDate = Value(briefingDate),
        headline = Value(headline),
        sectionsJson = Value(sectionsJson),
        createdAt = Value(createdAt);
  static Insertable<RadarBriefingEntry> custom({
    Expression<String>? id,
    Expression<String>? briefingType,
    Expression<String>? briefingDate,
    Expression<String>? headline,
    Expression<String>? sectionsJson,
    Expression<String>? generatedBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (briefingType != null) 'briefing_type': briefingType,
      if (briefingDate != null) 'briefing_date': briefingDate,
      if (headline != null) 'headline': headline,
      if (sectionsJson != null) 'sections_json': sectionsJson,
      if (generatedBy != null) 'generated_by': generatedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RadarBriefingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? briefingType,
      Value<String>? briefingDate,
      Value<String>? headline,
      Value<String>? sectionsJson,
      Value<String>? generatedBy,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RadarBriefingsCompanion(
      id: id ?? this.id,
      briefingType: briefingType ?? this.briefingType,
      briefingDate: briefingDate ?? this.briefingDate,
      headline: headline ?? this.headline,
      sectionsJson: sectionsJson ?? this.sectionsJson,
      generatedBy: generatedBy ?? this.generatedBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (briefingType.present) {
      map['briefing_type'] = Variable<String>(briefingType.value);
    }
    if (briefingDate.present) {
      map['briefing_date'] = Variable<String>(briefingDate.value);
    }
    if (headline.present) {
      map['headline'] = Variable<String>(headline.value);
    }
    if (sectionsJson.present) {
      map['sections_json'] = Variable<String>(sectionsJson.value);
    }
    if (generatedBy.present) {
      map['generated_by'] = Variable<String>(generatedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RadarBriefingsCompanion(')
          ..write('id: $id, ')
          ..write('briefingType: $briefingType, ')
          ..write('briefingDate: $briefingDate, ')
          ..write('headline: $headline, ')
          ..write('sectionsJson: $sectionsJson, ')
          ..write('generatedBy: $generatedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $SubtasksTable subtasks = $SubtasksTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $MilestonesTable milestones = $MilestonesTable(this);
  late final $SkillsTable skills = $SkillsTable(this);
  late final $LearningModulesTable learningModules =
      $LearningModulesTable(this);
  late final $LearningTopicsTable learningTopics = $LearningTopicsTable(this);
  late final $LearningSessionsTable learningSessions =
      $LearningSessionsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitEntriesTable habitEntries = $HabitEntriesTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $ScheduledNotificationsTable scheduledNotifications =
      $ScheduledNotificationsTable(this);
  late final $ActivityHistoryTable activityHistory =
      $ActivityHistoryTable(this);
  late final $XpEventsTable xpEvents = $XpEventsTable(this);
  late final $UnlockedAchievementsTable unlockedAchievements =
      $UnlockedAchievementsTable(this);
  late final $RadarDiscoveriesTable radarDiscoveries =
      $RadarDiscoveriesTable(this);
  late final $RadarTopicPrefsTable radarTopicPrefs =
      $RadarTopicPrefsTable(this);
  late final $RadarFollowsTable radarFollows = $RadarFollowsTable(this);
  late final $RadarFeedbackLogsTable radarFeedbackLogs =
      $RadarFeedbackLogsTable(this);
  late final $RadarBriefingsTable radarBriefings = $RadarBriefingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        tasks,
        subtasks,
        projects,
        milestones,
        skills,
        learningModules,
        learningTopics,
        learningSessions,
        goals,
        habits,
        habitEntries,
        focusSessions,
        notes,
        scheduledNotifications,
        activityHistory,
        xpEvents,
        unlockedAchievements,
        radarDiscoveries,
        radarTopicPrefs,
        radarFollows,
        radarFeedbackLogs,
        radarBriefings
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('tasks',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('subtasks', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('milestones', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('skills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('learning_modules', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('learning_modules',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('learning_topics', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('skills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('learning_sessions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('habits',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('habit_entries', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  Value<String> priority,
  Value<DateTime?> dueDate,
  Value<bool> hasDueTime,
  Value<DateTime?> reminderAt,
  Value<String?> projectId,
  Value<String?> skillId,
  Value<int> estimatedMinutes,
  Value<int> actualMinutes,
  Value<String> recurrence,
  Value<String> tags,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String> priority,
  Value<DateTime?> dueDate,
  Value<bool> hasDueTime,
  Value<DateTime?> reminderAt,
  Value<String?> projectId,
  Value<String?> skillId,
  Value<int> estimatedMinutes,
  Value<int> actualMinutes,
  Value<String> recurrence,
  Value<String> tags,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, TaskEntry> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubtasksTable, List<SubtaskEntry>>
      _subtasksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.subtasks,
              aliasName: $_aliasNameGenerator(db.tasks.id, db.subtasks.taskId));

  $$SubtasksTableProcessedTableManager get subtasksRefs {
    final manager = $$SubtasksTableTableManager($_db, $_db.subtasks)
        .filter((f) => f.taskId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_subtasksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasDueTime => $composableBuilder(
      column: $table.hasDueTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderAt => $composableBuilder(
      column: $table.reminderAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skillId => $composableBuilder(
      column: $table.skillId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get actualMinutes => $composableBuilder(
      column: $table.actualMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrence => $composableBuilder(
      column: $table.recurrence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> subtasksRefs(
      Expression<bool> Function($$SubtasksTableFilterComposer f) f) {
    final $$SubtasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subtasks,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubtasksTableFilterComposer(
              $db: $db,
              $table: $db.subtasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasDueTime => $composableBuilder(
      column: $table.hasDueTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderAt => $composableBuilder(
      column: $table.reminderAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skillId => $composableBuilder(
      column: $table.skillId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get actualMinutes => $composableBuilder(
      column: $table.actualMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrence => $composableBuilder(
      column: $table.recurrence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get hasDueTime => $composableBuilder(
      column: $table.hasDueTime, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt => $composableBuilder(
      column: $table.reminderAt, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get skillId =>
      $composableBuilder(column: $table.skillId, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes, builder: (column) => column);

  GeneratedColumn<int> get actualMinutes => $composableBuilder(
      column: $table.actualMinutes, builder: (column) => column);

  GeneratedColumn<String> get recurrence => $composableBuilder(
      column: $table.recurrence, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> subtasksRefs<T extends Object>(
      Expression<T> Function($$SubtasksTableAnnotationComposer a) f) {
    final $$SubtasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subtasks,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubtasksTableAnnotationComposer(
              $db: $db,
              $table: $db.subtasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskEntry,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskEntry, $$TasksTableReferences),
    TaskEntry,
    PrefetchHooks Function({bool subtasksRefs})> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<bool> hasDueTime = const Value.absent(),
            Value<DateTime?> reminderAt = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String?> skillId = const Value.absent(),
            Value<int> estimatedMinutes = const Value.absent(),
            Value<int> actualMinutes = const Value.absent(),
            Value<String> recurrence = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            title: title,
            description: description,
            priority: priority,
            dueDate: dueDate,
            hasDueTime: hasDueTime,
            reminderAt: reminderAt,
            projectId: projectId,
            skillId: skillId,
            estimatedMinutes: estimatedMinutes,
            actualMinutes: actualMinutes,
            recurrence: recurrence,
            tags: tags,
            isCompleted: isCompleted,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<bool> hasDueTime = const Value.absent(),
            Value<DateTime?> reminderAt = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String?> skillId = const Value.absent(),
            Value<int> estimatedMinutes = const Value.absent(),
            Value<int> actualMinutes = const Value.absent(),
            Value<String> recurrence = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            title: title,
            description: description,
            priority: priority,
            dueDate: dueDate,
            hasDueTime: hasDueTime,
            reminderAt: reminderAt,
            projectId: projectId,
            skillId: skillId,
            estimatedMinutes: estimatedMinutes,
            actualMinutes: actualMinutes,
            recurrence: recurrence,
            tags: tags,
            isCompleted: isCompleted,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TasksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({subtasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (subtasksRefs) db.subtasks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subtasksRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$TasksTableReferences._subtasksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TasksTableReferences(db, table, p0).subtasksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.taskId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    TaskEntry,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (TaskEntry, $$TasksTableReferences),
    TaskEntry,
    PrefetchHooks Function({bool subtasksRefs})>;
typedef $$SubtasksTableCreateCompanionBuilder = SubtasksCompanion Function({
  required String id,
  required String taskId,
  required String title,
  Value<bool> isCompleted,
  Value<int> orderIndex,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SubtasksTableUpdateCompanionBuilder = SubtasksCompanion Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> title,
  Value<bool> isCompleted,
  Value<int> orderIndex,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$SubtasksTableReferences
    extends BaseReferences<_$AppDatabase, $SubtasksTable, SubtaskEntry> {
  $$SubtasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks
      .createAlias($_aliasNameGenerator(db.subtasks.taskId, db.tasks.id));

  $$TasksTableProcessedTableManager get taskId {
    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.id($_item.taskId));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SubtasksTableFilterComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubtasksTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableOrderingComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubtasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubtasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubtasksTable,
    SubtaskEntry,
    $$SubtasksTableFilterComposer,
    $$SubtasksTableOrderingComposer,
    $$SubtasksTableAnnotationComposer,
    $$SubtasksTableCreateCompanionBuilder,
    $$SubtasksTableUpdateCompanionBuilder,
    (SubtaskEntry, $$SubtasksTableReferences),
    SubtaskEntry,
    PrefetchHooks Function({bool taskId})> {
  $$SubtasksTableTableManager(_$AppDatabase db, $SubtasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubtasksCompanion(
            id: id,
            taskId: taskId,
            title: title,
            isCompleted: isCompleted,
            orderIndex: orderIndex,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required String title,
            Value<bool> isCompleted = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubtasksCompanion.insert(
            id: id,
            taskId: taskId,
            title: title,
            isCompleted: isCompleted,
            orderIndex: orderIndex,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SubtasksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (taskId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.taskId,
                    referencedTable: $$SubtasksTableReferences._taskIdTable(db),
                    referencedColumn:
                        $$SubtasksTableReferences._taskIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SubtasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubtasksTable,
    SubtaskEntry,
    $$SubtasksTableFilterComposer,
    $$SubtasksTableOrderingComposer,
    $$SubtasksTableAnnotationComposer,
    $$SubtasksTableCreateCompanionBuilder,
    $$SubtasksTableUpdateCompanionBuilder,
    (SubtaskEntry, $$SubtasksTableReferences),
    SubtaskEntry,
    PrefetchHooks Function({bool taskId})>;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<String> category,
  required DateTime startDate,
  Value<DateTime?> targetDate,
  Value<String> status,
  Value<String> priority,
  Value<String> techStack,
  Value<String?> repositoryUrl,
  Value<String?> notes,
  Value<int> timeSpentMinutes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> category,
  Value<DateTime> startDate,
  Value<DateTime?> targetDate,
  Value<String> status,
  Value<String> priority,
  Value<String> techStack,
  Value<String?> repositoryUrl,
  Value<String?> notes,
  Value<int> timeSpentMinutes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectEntry> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MilestonesTable, List<MilestoneEntry>>
      _milestonesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.milestones,
          aliasName:
              $_aliasNameGenerator(db.projects.id, db.milestones.projectId));

  $$MilestonesTableProcessedTableManager get milestonesRefs {
    final manager = $$MilestonesTableTableManager($_db, $_db.milestones)
        .filter((f) => f.projectId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_milestonesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get techStack => $composableBuilder(
      column: $table.techStack, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get repositoryUrl => $composableBuilder(
      column: $table.repositoryUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeSpentMinutes => $composableBuilder(
      column: $table.timeSpentMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> milestonesRefs(
      Expression<bool> Function($$MilestonesTableFilterComposer f) f) {
    final $$MilestonesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.milestones,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MilestonesTableFilterComposer(
              $db: $db,
              $table: $db.milestones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get techStack => $composableBuilder(
      column: $table.techStack, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repositoryUrl => $composableBuilder(
      column: $table.repositoryUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeSpentMinutes => $composableBuilder(
      column: $table.timeSpentMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get techStack =>
      $composableBuilder(column: $table.techStack, builder: (column) => column);

  GeneratedColumn<String> get repositoryUrl => $composableBuilder(
      column: $table.repositoryUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get timeSpentMinutes => $composableBuilder(
      column: $table.timeSpentMinutes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> milestonesRefs<T extends Object>(
      Expression<T> Function($$MilestonesTableAnnotationComposer a) f) {
    final $$MilestonesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.milestones,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MilestonesTableAnnotationComposer(
              $db: $db,
              $table: $db.milestones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    ProjectEntry,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (ProjectEntry, $$ProjectsTableReferences),
    ProjectEntry,
    PrefetchHooks Function({bool milestonesRefs})> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> targetDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> techStack = const Value.absent(),
            Value<String?> repositoryUrl = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> timeSpentMinutes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            name: name,
            description: description,
            category: category,
            startDate: startDate,
            targetDate: targetDate,
            status: status,
            priority: priority,
            techStack: techStack,
            repositoryUrl: repositoryUrl,
            notes: notes,
            timeSpentMinutes: timeSpentMinutes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> targetDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> techStack = const Value.absent(),
            Value<String?> repositoryUrl = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> timeSpentMinutes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            name: name,
            description: description,
            category: category,
            startDate: startDate,
            targetDate: targetDate,
            status: status,
            priority: priority,
            techStack: techStack,
            repositoryUrl: repositoryUrl,
            notes: notes,
            timeSpentMinutes: timeSpentMinutes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProjectsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({milestonesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (milestonesRefs) db.milestones],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (milestonesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._milestonesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .milestonesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    ProjectEntry,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (ProjectEntry, $$ProjectsTableReferences),
    ProjectEntry,
    PrefetchHooks Function({bool milestonesRefs})>;
typedef $$MilestonesTableCreateCompanionBuilder = MilestonesCompanion Function({
  required String id,
  required String projectId,
  required String title,
  Value<String?> description,
  Value<DateTime?> targetDate,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<int> orderIndex,
  Value<int> rowid,
});
typedef $$MilestonesTableUpdateCompanionBuilder = MilestonesCompanion Function({
  Value<String> id,
  Value<String> projectId,
  Value<String> title,
  Value<String?> description,
  Value<DateTime?> targetDate,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<int> orderIndex,
  Value<int> rowid,
});

final class $$MilestonesTableReferences
    extends BaseReferences<_$AppDatabase, $MilestonesTable, MilestoneEntry> {
  $$MilestonesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.milestones.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id($_item.projectId));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilestonesTable> {
  $$MilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MilestonesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MilestonesTable,
    MilestoneEntry,
    $$MilestonesTableFilterComposer,
    $$MilestonesTableOrderingComposer,
    $$MilestonesTableAnnotationComposer,
    $$MilestonesTableCreateCompanionBuilder,
    $$MilestonesTableUpdateCompanionBuilder,
    (MilestoneEntry, $$MilestonesTableReferences),
    MilestoneEntry,
    PrefetchHooks Function({bool projectId})> {
  $$MilestonesTableTableManager(_$AppDatabase db, $MilestonesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilestonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> targetDate = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MilestonesCompanion(
            id: id,
            projectId: projectId,
            title: title,
            description: description,
            targetDate: targetDate,
            isCompleted: isCompleted,
            completedAt: completedAt,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projectId,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> targetDate = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MilestonesCompanion.insert(
            id: id,
            projectId: projectId,
            title: title,
            description: description,
            targetDate: targetDate,
            isCompleted: isCompleted,
            completedAt: completedAt,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MilestonesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$MilestonesTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$MilestonesTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MilestonesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MilestonesTable,
    MilestoneEntry,
    $$MilestonesTableFilterComposer,
    $$MilestonesTableOrderingComposer,
    $$MilestonesTableAnnotationComposer,
    $$MilestonesTableCreateCompanionBuilder,
    $$MilestonesTableUpdateCompanionBuilder,
    (MilestoneEntry, $$MilestonesTableReferences),
    MilestoneEntry,
    PrefetchHooks Function({bool projectId})>;
typedef $$SkillsTableCreateCompanionBuilder = SkillsCompanion Function({
  required String id,
  required String name,
  Value<String> category,
  Value<String> currentLevel,
  Value<String> targetLevel,
  Value<String?> notes,
  Value<int> learningMinutes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SkillsTableUpdateCompanionBuilder = SkillsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> category,
  Value<String> currentLevel,
  Value<String> targetLevel,
  Value<String?> notes,
  Value<int> learningMinutes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$SkillsTableReferences
    extends BaseReferences<_$AppDatabase, $SkillsTable, SkillEntry> {
  $$SkillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LearningModulesTable, List<LearningModuleEntry>>
      _learningModulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.learningModules,
              aliasName: $_aliasNameGenerator(
                  db.skills.id, db.learningModules.skillId));

  $$LearningModulesTableProcessedTableManager get learningModulesRefs {
    final manager =
        $$LearningModulesTableTableManager($_db, $_db.learningModules)
            .filter((f) => f.skillId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_learningModulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LearningSessionsTable, List<LearningSessionEntry>>
      _learningSessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.learningSessions,
              aliasName: $_aliasNameGenerator(
                  db.skills.id, db.learningSessions.skillId));

  $$LearningSessionsTableProcessedTableManager get learningSessionsRefs {
    final manager =
        $$LearningSessionsTableTableManager($_db, $_db.learningSessions)
            .filter((f) => f.skillId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_learningSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SkillsTableFilterComposer
    extends Composer<_$AppDatabase, $SkillsTable> {
  $$SkillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentLevel => $composableBuilder(
      column: $table.currentLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetLevel => $composableBuilder(
      column: $table.targetLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get learningMinutes => $composableBuilder(
      column: $table.learningMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> learningModulesRefs(
      Expression<bool> Function($$LearningModulesTableFilterComposer f) f) {
    final $$LearningModulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.learningModules,
        getReferencedColumn: (t) => t.skillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningModulesTableFilterComposer(
              $db: $db,
              $table: $db.learningModules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> learningSessionsRefs(
      Expression<bool> Function($$LearningSessionsTableFilterComposer f) f) {
    final $$LearningSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.learningSessions,
        getReferencedColumn: (t) => t.skillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningSessionsTableFilterComposer(
              $db: $db,
              $table: $db.learningSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SkillsTableOrderingComposer
    extends Composer<_$AppDatabase, $SkillsTable> {
  $$SkillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentLevel => $composableBuilder(
      column: $table.currentLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetLevel => $composableBuilder(
      column: $table.targetLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get learningMinutes => $composableBuilder(
      column: $table.learningMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SkillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkillsTable> {
  $$SkillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get currentLevel => $composableBuilder(
      column: $table.currentLevel, builder: (column) => column);

  GeneratedColumn<String> get targetLevel => $composableBuilder(
      column: $table.targetLevel, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get learningMinutes => $composableBuilder(
      column: $table.learningMinutes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> learningModulesRefs<T extends Object>(
      Expression<T> Function($$LearningModulesTableAnnotationComposer a) f) {
    final $$LearningModulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.learningModules,
        getReferencedColumn: (t) => t.skillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningModulesTableAnnotationComposer(
              $db: $db,
              $table: $db.learningModules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> learningSessionsRefs<T extends Object>(
      Expression<T> Function($$LearningSessionsTableAnnotationComposer a) f) {
    final $$LearningSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.learningSessions,
        getReferencedColumn: (t) => t.skillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.learningSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SkillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SkillsTable,
    SkillEntry,
    $$SkillsTableFilterComposer,
    $$SkillsTableOrderingComposer,
    $$SkillsTableAnnotationComposer,
    $$SkillsTableCreateCompanionBuilder,
    $$SkillsTableUpdateCompanionBuilder,
    (SkillEntry, $$SkillsTableReferences),
    SkillEntry,
    PrefetchHooks Function(
        {bool learningModulesRefs, bool learningSessionsRefs})> {
  $$SkillsTableTableManager(_$AppDatabase db, $SkillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> currentLevel = const Value.absent(),
            Value<String> targetLevel = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> learningMinutes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SkillsCompanion(
            id: id,
            name: name,
            category: category,
            currentLevel: currentLevel,
            targetLevel: targetLevel,
            notes: notes,
            learningMinutes: learningMinutes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> category = const Value.absent(),
            Value<String> currentLevel = const Value.absent(),
            Value<String> targetLevel = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> learningMinutes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SkillsCompanion.insert(
            id: id,
            name: name,
            category: category,
            currentLevel: currentLevel,
            targetLevel: targetLevel,
            notes: notes,
            learningMinutes: learningMinutes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SkillsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {learningModulesRefs = false, learningSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (learningModulesRefs) db.learningModules,
                if (learningSessionsRefs) db.learningSessions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (learningModulesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SkillsTableReferences
                            ._learningModulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SkillsTableReferences(db, table, p0)
                                .learningModulesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.skillId == item.id),
                        typedResults: items),
                  if (learningSessionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$SkillsTableReferences
                            ._learningSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SkillsTableReferences(db, table, p0)
                                .learningSessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.skillId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SkillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SkillsTable,
    SkillEntry,
    $$SkillsTableFilterComposer,
    $$SkillsTableOrderingComposer,
    $$SkillsTableAnnotationComposer,
    $$SkillsTableCreateCompanionBuilder,
    $$SkillsTableUpdateCompanionBuilder,
    (SkillEntry, $$SkillsTableReferences),
    SkillEntry,
    PrefetchHooks Function(
        {bool learningModulesRefs, bool learningSessionsRefs})>;
typedef $$LearningModulesTableCreateCompanionBuilder = LearningModulesCompanion
    Function({
  required String id,
  required String skillId,
  required String title,
  Value<String?> description,
  Value<int> orderIndex,
  Value<int> rowid,
});
typedef $$LearningModulesTableUpdateCompanionBuilder = LearningModulesCompanion
    Function({
  Value<String> id,
  Value<String> skillId,
  Value<String> title,
  Value<String?> description,
  Value<int> orderIndex,
  Value<int> rowid,
});

final class $$LearningModulesTableReferences extends BaseReferences<
    _$AppDatabase, $LearningModulesTable, LearningModuleEntry> {
  $$LearningModulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SkillsTable _skillIdTable(_$AppDatabase db) => db.skills.createAlias(
      $_aliasNameGenerator(db.learningModules.skillId, db.skills.id));

  $$SkillsTableProcessedTableManager get skillId {
    final manager = $$SkillsTableTableManager($_db, $_db.skills)
        .filter((f) => f.id($_item.skillId));
    final item = $_typedResult.readTableOrNull(_skillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$LearningTopicsTable, List<LearningTopicEntry>>
      _learningTopicsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.learningTopics,
              aliasName: $_aliasNameGenerator(
                  db.learningModules.id, db.learningTopics.moduleId));

  $$LearningTopicsTableProcessedTableManager get learningTopicsRefs {
    final manager = $$LearningTopicsTableTableManager($_db, $_db.learningTopics)
        .filter((f) => f.moduleId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_learningTopicsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LearningModulesTableFilterComposer
    extends Composer<_$AppDatabase, $LearningModulesTable> {
  $$LearningModulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  $$SkillsTableFilterComposer get skillId {
    final $$SkillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableFilterComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> learningTopicsRefs(
      Expression<bool> Function($$LearningTopicsTableFilterComposer f) f) {
    final $$LearningTopicsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.learningTopics,
        getReferencedColumn: (t) => t.moduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningTopicsTableFilterComposer(
              $db: $db,
              $table: $db.learningTopics,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LearningModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningModulesTable> {
  $$LearningModulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  $$SkillsTableOrderingComposer get skillId {
    final $$SkillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableOrderingComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LearningModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningModulesTable> {
  $$LearningModulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  $$SkillsTableAnnotationComposer get skillId {
    final $$SkillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableAnnotationComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> learningTopicsRefs<T extends Object>(
      Expression<T> Function($$LearningTopicsTableAnnotationComposer a) f) {
    final $$LearningTopicsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.learningTopics,
        getReferencedColumn: (t) => t.moduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningTopicsTableAnnotationComposer(
              $db: $db,
              $table: $db.learningTopics,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LearningModulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LearningModulesTable,
    LearningModuleEntry,
    $$LearningModulesTableFilterComposer,
    $$LearningModulesTableOrderingComposer,
    $$LearningModulesTableAnnotationComposer,
    $$LearningModulesTableCreateCompanionBuilder,
    $$LearningModulesTableUpdateCompanionBuilder,
    (LearningModuleEntry, $$LearningModulesTableReferences),
    LearningModuleEntry,
    PrefetchHooks Function({bool skillId, bool learningTopicsRefs})> {
  $$LearningModulesTableTableManager(
      _$AppDatabase db, $LearningModulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> skillId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LearningModulesCompanion(
            id: id,
            skillId: skillId,
            title: title,
            description: description,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String skillId,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LearningModulesCompanion.insert(
            id: id,
            skillId: skillId,
            title: title,
            description: description,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LearningModulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {skillId = false, learningTopicsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (learningTopicsRefs) db.learningTopics
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (skillId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.skillId,
                    referencedTable:
                        $$LearningModulesTableReferences._skillIdTable(db),
                    referencedColumn:
                        $$LearningModulesTableReferences._skillIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (learningTopicsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$LearningModulesTableReferences
                            ._learningTopicsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LearningModulesTableReferences(db, table, p0)
                                .learningTopicsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.moduleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LearningModulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LearningModulesTable,
    LearningModuleEntry,
    $$LearningModulesTableFilterComposer,
    $$LearningModulesTableOrderingComposer,
    $$LearningModulesTableAnnotationComposer,
    $$LearningModulesTableCreateCompanionBuilder,
    $$LearningModulesTableUpdateCompanionBuilder,
    (LearningModuleEntry, $$LearningModulesTableReferences),
    LearningModuleEntry,
    PrefetchHooks Function({bool skillId, bool learningTopicsRefs})>;
typedef $$LearningTopicsTableCreateCompanionBuilder = LearningTopicsCompanion
    Function({
  required String id,
  required String moduleId,
  required String title,
  Value<String> status,
  Value<String> resources,
  Value<String?> notes,
  Value<int> orderIndex,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$LearningTopicsTableUpdateCompanionBuilder = LearningTopicsCompanion
    Function({
  Value<String> id,
  Value<String> moduleId,
  Value<String> title,
  Value<String> status,
  Value<String> resources,
  Value<String?> notes,
  Value<int> orderIndex,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

final class $$LearningTopicsTableReferences extends BaseReferences<
    _$AppDatabase, $LearningTopicsTable, LearningTopicEntry> {
  $$LearningTopicsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LearningModulesTable _moduleIdTable(_$AppDatabase db) =>
      db.learningModules.createAlias($_aliasNameGenerator(
          db.learningTopics.moduleId, db.learningModules.id));

  $$LearningModulesTableProcessedTableManager get moduleId {
    final manager =
        $$LearningModulesTableTableManager($_db, $_db.learningModules)
            .filter((f) => f.id($_item.moduleId));
    final item = $_typedResult.readTableOrNull(_moduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LearningTopicsTableFilterComposer
    extends Composer<_$AppDatabase, $LearningTopicsTable> {
  $$LearningTopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resources => $composableBuilder(
      column: $table.resources, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$LearningModulesTableFilterComposer get moduleId {
    final $$LearningModulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.moduleId,
        referencedTable: $db.learningModules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningModulesTableFilterComposer(
              $db: $db,
              $table: $db.learningModules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LearningTopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningTopicsTable> {
  $$LearningTopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resources => $composableBuilder(
      column: $table.resources, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$LearningModulesTableOrderingComposer get moduleId {
    final $$LearningModulesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.moduleId,
        referencedTable: $db.learningModules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningModulesTableOrderingComposer(
              $db: $db,
              $table: $db.learningModules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LearningTopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningTopicsTable> {
  $$LearningTopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get resources =>
      $composableBuilder(column: $table.resources, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$LearningModulesTableAnnotationComposer get moduleId {
    final $$LearningModulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.moduleId,
        referencedTable: $db.learningModules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningModulesTableAnnotationComposer(
              $db: $db,
              $table: $db.learningModules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LearningTopicsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LearningTopicsTable,
    LearningTopicEntry,
    $$LearningTopicsTableFilterComposer,
    $$LearningTopicsTableOrderingComposer,
    $$LearningTopicsTableAnnotationComposer,
    $$LearningTopicsTableCreateCompanionBuilder,
    $$LearningTopicsTableUpdateCompanionBuilder,
    (LearningTopicEntry, $$LearningTopicsTableReferences),
    LearningTopicEntry,
    PrefetchHooks Function({bool moduleId})> {
  $$LearningTopicsTableTableManager(
      _$AppDatabase db, $LearningTopicsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningTopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningTopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningTopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> moduleId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> resources = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LearningTopicsCompanion(
            id: id,
            moduleId: moduleId,
            title: title,
            status: status,
            resources: resources,
            notes: notes,
            orderIndex: orderIndex,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String moduleId,
            required String title,
            Value<String> status = const Value.absent(),
            Value<String> resources = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LearningTopicsCompanion.insert(
            id: id,
            moduleId: moduleId,
            title: title,
            status: status,
            resources: resources,
            notes: notes,
            orderIndex: orderIndex,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LearningTopicsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({moduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (moduleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.moduleId,
                    referencedTable:
                        $$LearningTopicsTableReferences._moduleIdTable(db),
                    referencedColumn:
                        $$LearningTopicsTableReferences._moduleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LearningTopicsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LearningTopicsTable,
    LearningTopicEntry,
    $$LearningTopicsTableFilterComposer,
    $$LearningTopicsTableOrderingComposer,
    $$LearningTopicsTableAnnotationComposer,
    $$LearningTopicsTableCreateCompanionBuilder,
    $$LearningTopicsTableUpdateCompanionBuilder,
    (LearningTopicEntry, $$LearningTopicsTableReferences),
    LearningTopicEntry,
    PrefetchHooks Function({bool moduleId})>;
typedef $$LearningSessionsTableCreateCompanionBuilder
    = LearningSessionsCompanion Function({
  required String id,
  required String skillId,
  Value<String?> topicId,
  required int durationMinutes,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$LearningSessionsTableUpdateCompanionBuilder
    = LearningSessionsCompanion Function({
  Value<String> id,
  Value<String> skillId,
  Value<String?> topicId,
  Value<int> durationMinutes,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$LearningSessionsTableReferences extends BaseReferences<
    _$AppDatabase, $LearningSessionsTable, LearningSessionEntry> {
  $$LearningSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SkillsTable _skillIdTable(_$AppDatabase db) => db.skills.createAlias(
      $_aliasNameGenerator(db.learningSessions.skillId, db.skills.id));

  $$SkillsTableProcessedTableManager get skillId {
    final manager = $$SkillsTableTableManager($_db, $_db.skills)
        .filter((f) => f.id($_item.skillId));
    final item = $_typedResult.readTableOrNull(_skillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LearningSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $LearningSessionsTable> {
  $$LearningSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SkillsTableFilterComposer get skillId {
    final $$SkillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableFilterComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LearningSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningSessionsTable> {
  $$LearningSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SkillsTableOrderingComposer get skillId {
    final $$SkillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableOrderingComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LearningSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningSessionsTable> {
  $$LearningSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SkillsTableAnnotationComposer get skillId {
    final $$SkillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.skillId,
        referencedTable: $db.skills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SkillsTableAnnotationComposer(
              $db: $db,
              $table: $db.skills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LearningSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LearningSessionsTable,
    LearningSessionEntry,
    $$LearningSessionsTableFilterComposer,
    $$LearningSessionsTableOrderingComposer,
    $$LearningSessionsTableAnnotationComposer,
    $$LearningSessionsTableCreateCompanionBuilder,
    $$LearningSessionsTableUpdateCompanionBuilder,
    (LearningSessionEntry, $$LearningSessionsTableReferences),
    LearningSessionEntry,
    PrefetchHooks Function({bool skillId})> {
  $$LearningSessionsTableTableManager(
      _$AppDatabase db, $LearningSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> skillId = const Value.absent(),
            Value<String?> topicId = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LearningSessionsCompanion(
            id: id,
            skillId: skillId,
            topicId: topicId,
            durationMinutes: durationMinutes,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String skillId,
            Value<String?> topicId = const Value.absent(),
            required int durationMinutes,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LearningSessionsCompanion.insert(
            id: id,
            skillId: skillId,
            topicId: topicId,
            durationMinutes: durationMinutes,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LearningSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({skillId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (skillId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.skillId,
                    referencedTable:
                        $$LearningSessionsTableReferences._skillIdTable(db),
                    referencedColumn:
                        $$LearningSessionsTableReferences._skillIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LearningSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LearningSessionsTable,
    LearningSessionEntry,
    $$LearningSessionsTableFilterComposer,
    $$LearningSessionsTableOrderingComposer,
    $$LearningSessionsTableAnnotationComposer,
    $$LearningSessionsTableCreateCompanionBuilder,
    $$LearningSessionsTableUpdateCompanionBuilder,
    (LearningSessionEntry, $$LearningSessionsTableReferences),
    LearningSessionEntry,
    PrefetchHooks Function({bool skillId})>;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  Value<String> type,
  required double targetValue,
  Value<double> currentValue,
  Value<String> unit,
  Value<DateTime?> deadline,
  Value<bool> isAchieved,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String> type,
  Value<double> targetValue,
  Value<double> currentValue,
  Value<String> unit,
  Value<DateTime?> deadline,
  Value<bool> isAchieved,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAchieved => $composableBuilder(
      column: $table.isAchieved, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentValue => $composableBuilder(
      column: $table.currentValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAchieved => $composableBuilder(
      column: $table.isAchieved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => column);

  GeneratedColumn<double> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<bool> get isAchieved => $composableBuilder(
      column: $table.isAchieved, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTable,
    GoalEntry,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (GoalEntry, BaseReferences<_$AppDatabase, $GoalsTable, GoalEntry>),
    GoalEntry,
    PrefetchHooks Function()> {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> targetValue = const Value.absent(),
            Value<double> currentValue = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<bool> isAchieved = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion(
            id: id,
            title: title,
            description: description,
            type: type,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadline: deadline,
            isAchieved: isAchieved,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            required double targetValue,
            Value<double> currentValue = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<bool> isAchieved = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion.insert(
            id: id,
            title: title,
            description: description,
            type: type,
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit,
            deadline: deadline,
            isAchieved: isAchieved,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTable,
    GoalEntry,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (GoalEntry, BaseReferences<_$AppDatabase, $GoalsTable, GoalEntry>),
    GoalEntry,
    PrefetchHooks Function()>;
typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  Value<String> frequency,
  Value<int> targetDaysPerWeek,
  Value<String?> reminderTime,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String> frequency,
  Value<int> targetDaysPerWeek,
  Value<String?> reminderTime,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, HabitEntryRecord> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitEntriesTable, List<HabitDailyLog>>
      _habitEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.habitEntries,
              aliasName:
                  $_aliasNameGenerator(db.habits.id, db.habitEntries.habitId));

  $$HabitEntriesTableProcessedTableManager get habitEntriesRefs {
    final manager = $$HabitEntriesTableTableManager($_db, $_db.habitEntries)
        .filter((f) => f.habitId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_habitEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetDaysPerWeek => $composableBuilder(
      column: $table.targetDaysPerWeek,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> habitEntriesRefs(
      Expression<bool> Function($$HabitEntriesTableFilterComposer f) f) {
    final $$HabitEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitEntries,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitEntriesTableFilterComposer(
              $db: $db,
              $table: $db.habitEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetDaysPerWeek => $composableBuilder(
      column: $table.targetDaysPerWeek,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get targetDaysPerWeek => $composableBuilder(
      column: $table.targetDaysPerWeek, builder: (column) => column);

  GeneratedColumn<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> habitEntriesRefs<T extends Object>(
      Expression<T> Function($$HabitEntriesTableAnnotationComposer a) f) {
    final $$HabitEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitEntries,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.habitEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HabitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitsTable,
    HabitEntryRecord,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (HabitEntryRecord, $$HabitsTableReferences),
    HabitEntryRecord,
    PrefetchHooks Function({bool habitEntriesRefs})> {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<int> targetDaysPerWeek = const Value.absent(),
            Value<String?> reminderTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitsCompanion(
            id: id,
            title: title,
            description: description,
            frequency: frequency,
            targetDaysPerWeek: targetDaysPerWeek,
            reminderTime: reminderTime,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<int> targetDaysPerWeek = const Value.absent(),
            Value<String?> reminderTime = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitsCompanion.insert(
            id: id,
            title: title,
            description: description,
            frequency: frequency,
            targetDaysPerWeek: targetDaysPerWeek,
            reminderTime: reminderTime,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$HabitsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({habitEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (habitEntriesRefs) db.habitEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitEntriesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$HabitsTableReferences._habitEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HabitsTableReferences(db, table, p0)
                                .habitEntriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.habitId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HabitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitsTable,
    HabitEntryRecord,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (HabitEntryRecord, $$HabitsTableReferences),
    HabitEntryRecord,
    PrefetchHooks Function({bool habitEntriesRefs})>;
typedef $$HabitEntriesTableCreateCompanionBuilder = HabitEntriesCompanion
    Function({
  required String id,
  required String habitId,
  required String dateStr,
  Value<bool> isCompleted,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$HabitEntriesTableUpdateCompanionBuilder = HabitEntriesCompanion
    Function({
  Value<String> id,
  Value<String> habitId,
  Value<String> dateStr,
  Value<bool> isCompleted,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$HabitEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $HabitEntriesTable, HabitDailyLog> {
  $$HabitEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) => db.habits
      .createAlias($_aliasNameGenerator(db.habitEntries.habitId, db.habits.id));

  $$HabitsTableProcessedTableManager get habitId {
    final manager = $$HabitsTableTableManager($_db, $_db.habits)
        .filter((f) => f.id($_item.habitId));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HabitEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateStr => $composableBuilder(
      column: $table.dateStr, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableFilterComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateStr => $composableBuilder(
      column: $table.dateStr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableOrderingComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitEntriesTable> {
  $$HabitEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateStr =>
      $composableBuilder(column: $table.dateStr, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableAnnotationComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitEntriesTable,
    HabitDailyLog,
    $$HabitEntriesTableFilterComposer,
    $$HabitEntriesTableOrderingComposer,
    $$HabitEntriesTableAnnotationComposer,
    $$HabitEntriesTableCreateCompanionBuilder,
    $$HabitEntriesTableUpdateCompanionBuilder,
    (HabitDailyLog, $$HabitEntriesTableReferences),
    HabitDailyLog,
    PrefetchHooks Function({bool habitId})> {
  $$HabitEntriesTableTableManager(_$AppDatabase db, $HabitEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> habitId = const Value.absent(),
            Value<String> dateStr = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitEntriesCompanion(
            id: id,
            habitId: habitId,
            dateStr: dateStr,
            isCompleted: isCompleted,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String habitId,
            required String dateStr,
            Value<bool> isCompleted = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitEntriesCompanion.insert(
            id: id,
            habitId: habitId,
            dateStr: dateStr,
            isCompleted: isCompleted,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HabitEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (habitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.habitId,
                    referencedTable:
                        $$HabitEntriesTableReferences._habitIdTable(db),
                    referencedColumn:
                        $$HabitEntriesTableReferences._habitIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HabitEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitEntriesTable,
    HabitDailyLog,
    $$HabitEntriesTableFilterComposer,
    $$HabitEntriesTableOrderingComposer,
    $$HabitEntriesTableAnnotationComposer,
    $$HabitEntriesTableCreateCompanionBuilder,
    $$HabitEntriesTableUpdateCompanionBuilder,
    (HabitDailyLog, $$HabitEntriesTableReferences),
    HabitDailyLog,
    PrefetchHooks Function({bool habitId})>;
typedef $$FocusSessionsTableCreateCompanionBuilder = FocusSessionsCompanion
    Function({
  required String id,
  Value<String?> taskId,
  Value<String?> projectId,
  Value<String?> skillId,
  required int durationMinutes,
  Value<String> sessionType,
  required DateTime completedAt,
  Value<int> rowid,
});
typedef $$FocusSessionsTableUpdateCompanionBuilder = FocusSessionsCompanion
    Function({
  Value<String> id,
  Value<String?> taskId,
  Value<String?> projectId,
  Value<String?> skillId,
  Value<int> durationMinutes,
  Value<String> sessionType,
  Value<DateTime> completedAt,
  Value<int> rowid,
});

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skillId => $composableBuilder(
      column: $table.skillId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skillId => $composableBuilder(
      column: $table.skillId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get skillId =>
      $composableBuilder(column: $table.skillId, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<String> get sessionType => $composableBuilder(
      column: $table.sessionType, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$FocusSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FocusSessionsTable,
    FocusSessionEntry,
    $$FocusSessionsTableFilterComposer,
    $$FocusSessionsTableOrderingComposer,
    $$FocusSessionsTableAnnotationComposer,
    $$FocusSessionsTableCreateCompanionBuilder,
    $$FocusSessionsTableUpdateCompanionBuilder,
    (
      FocusSessionEntry,
      BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSessionEntry>
    ),
    FocusSessionEntry,
    PrefetchHooks Function()> {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String?> skillId = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<String> sessionType = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FocusSessionsCompanion(
            id: id,
            taskId: taskId,
            projectId: projectId,
            skillId: skillId,
            durationMinutes: durationMinutes,
            sessionType: sessionType,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> taskId = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String?> skillId = const Value.absent(),
            required int durationMinutes,
            Value<String> sessionType = const Value.absent(),
            required DateTime completedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FocusSessionsCompanion.insert(
            id: id,
            taskId: taskId,
            projectId: projectId,
            skillId: skillId,
            durationMinutes: durationMinutes,
            sessionType: sessionType,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FocusSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FocusSessionsTable,
    FocusSessionEntry,
    $$FocusSessionsTableFilterComposer,
    $$FocusSessionsTableOrderingComposer,
    $$FocusSessionsTableAnnotationComposer,
    $$FocusSessionsTableCreateCompanionBuilder,
    $$FocusSessionsTableUpdateCompanionBuilder,
    (
      FocusSessionEntry,
      BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSessionEntry>
    ),
    FocusSessionEntry,
    PrefetchHooks Function()>;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String id,
  required String title,
  required String content,
  Value<String> category,
  Value<String> tags,
  Value<String?> projectId,
  Value<String?> skillId,
  Value<String?> taskId,
  Value<bool> isPinned,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> content,
  Value<String> category,
  Value<String> tags,
  Value<String?> projectId,
  Value<String?> skillId,
  Value<String?> taskId,
  Value<bool> isPinned,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get skillId => $composableBuilder(
      column: $table.skillId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get skillId => $composableBuilder(
      column: $table.skillId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get skillId =>
      $composableBuilder(column: $table.skillId, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteEntry,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteEntry, BaseReferences<_$AppDatabase, $NotesTable, NoteEntry>),
    NoteEntry,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String?> skillId = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            title: title,
            content: content,
            category: category,
            tags: tags,
            projectId: projectId,
            skillId: skillId,
            taskId: taskId,
            isPinned: isPinned,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String content,
            Value<String> category = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String?> skillId = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            title: title,
            content: content,
            category: category,
            tags: tags,
            projectId: projectId,
            skillId: skillId,
            taskId: taskId,
            isPinned: isPinned,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    NoteEntry,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NoteEntry, BaseReferences<_$AppDatabase, $NotesTable, NoteEntry>),
    NoteEntry,
    PrefetchHooks Function()>;
typedef $$ScheduledNotificationsTableCreateCompanionBuilder
    = ScheduledNotificationsCompanion Function({
  Value<int> id,
  Value<String?> taskId,
  required String type,
  required DateTime scheduledTime,
  Value<String> payload,
});
typedef $$ScheduledNotificationsTableUpdateCompanionBuilder
    = ScheduledNotificationsCompanion Function({
  Value<int> id,
  Value<String?> taskId,
  Value<String> type,
  Value<DateTime> scheduledTime,
  Value<String> payload,
});

class $$ScheduledNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledNotificationsTable> {
  $$ScheduledNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));
}

class $$ScheduledNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledNotificationsTable> {
  $$ScheduledNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));
}

class $$ScheduledNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledNotificationsTable> {
  $$ScheduledNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$ScheduledNotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduledNotificationsTable,
    ScheduledNotificationEntry,
    $$ScheduledNotificationsTableFilterComposer,
    $$ScheduledNotificationsTableOrderingComposer,
    $$ScheduledNotificationsTableAnnotationComposer,
    $$ScheduledNotificationsTableCreateCompanionBuilder,
    $$ScheduledNotificationsTableUpdateCompanionBuilder,
    (
      ScheduledNotificationEntry,
      BaseReferences<_$AppDatabase, $ScheduledNotificationsTable,
          ScheduledNotificationEntry>
    ),
    ScheduledNotificationEntry,
    PrefetchHooks Function()> {
  $$ScheduledNotificationsTableTableManager(
      _$AppDatabase db, $ScheduledNotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledNotificationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledNotificationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledNotificationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> scheduledTime = const Value.absent(),
            Value<String> payload = const Value.absent(),
          }) =>
              ScheduledNotificationsCompanion(
            id: id,
            taskId: taskId,
            type: type,
            scheduledTime: scheduledTime,
            payload: payload,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            required String type,
            required DateTime scheduledTime,
            Value<String> payload = const Value.absent(),
          }) =>
              ScheduledNotificationsCompanion.insert(
            id: id,
            taskId: taskId,
            type: type,
            scheduledTime: scheduledTime,
            payload: payload,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScheduledNotificationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ScheduledNotificationsTable,
        ScheduledNotificationEntry,
        $$ScheduledNotificationsTableFilterComposer,
        $$ScheduledNotificationsTableOrderingComposer,
        $$ScheduledNotificationsTableAnnotationComposer,
        $$ScheduledNotificationsTableCreateCompanionBuilder,
        $$ScheduledNotificationsTableUpdateCompanionBuilder,
        (
          ScheduledNotificationEntry,
          BaseReferences<_$AppDatabase, $ScheduledNotificationsTable,
              ScheduledNotificationEntry>
        ),
        ScheduledNotificationEntry,
        PrefetchHooks Function()>;
typedef $$ActivityHistoryTableCreateCompanionBuilder = ActivityHistoryCompanion
    Function({
  required String id,
  required String entityType,
  Value<String?> entityId,
  required String action,
  required String summary,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ActivityHistoryTableUpdateCompanionBuilder = ActivityHistoryCompanion
    Function({
  Value<String> id,
  Value<String> entityType,
  Value<String?> entityId,
  Value<String> action,
  Value<String> summary,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ActivityHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityHistoryTable> {
  $$ActivityHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ActivityHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityHistoryTable> {
  $$ActivityHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ActivityHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityHistoryTable> {
  $$ActivityHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ActivityHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ActivityHistoryTable,
    ActivityHistoryEntry,
    $$ActivityHistoryTableFilterComposer,
    $$ActivityHistoryTableOrderingComposer,
    $$ActivityHistoryTableAnnotationComposer,
    $$ActivityHistoryTableCreateCompanionBuilder,
    $$ActivityHistoryTableUpdateCompanionBuilder,
    (
      ActivityHistoryEntry,
      BaseReferences<_$AppDatabase, $ActivityHistoryTable, ActivityHistoryEntry>
    ),
    ActivityHistoryEntry,
    PrefetchHooks Function()> {
  $$ActivityHistoryTableTableManager(
      _$AppDatabase db, $ActivityHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityHistoryCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            action: action,
            summary: summary,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            Value<String?> entityId = const Value.absent(),
            required String action,
            required String summary,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityHistoryCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            action: action,
            summary: summary,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActivityHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ActivityHistoryTable,
    ActivityHistoryEntry,
    $$ActivityHistoryTableFilterComposer,
    $$ActivityHistoryTableOrderingComposer,
    $$ActivityHistoryTableAnnotationComposer,
    $$ActivityHistoryTableCreateCompanionBuilder,
    $$ActivityHistoryTableUpdateCompanionBuilder,
    (
      ActivityHistoryEntry,
      BaseReferences<_$AppDatabase, $ActivityHistoryTable, ActivityHistoryEntry>
    ),
    ActivityHistoryEntry,
    PrefetchHooks Function()>;
typedef $$XpEventsTableCreateCompanionBuilder = XpEventsCompanion Function({
  required String id,
  required String sourceKey,
  required String sourceType,
  required int amount,
  required String summary,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$XpEventsTableUpdateCompanionBuilder = XpEventsCompanion Function({
  Value<String> id,
  Value<String> sourceKey,
  Value<String> sourceType,
  Value<int> amount,
  Value<String> summary,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$XpEventsTableFilterComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceKey => $composableBuilder(
      column: $table.sourceKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$XpEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceKey => $composableBuilder(
      column: $table.sourceKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$XpEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$XpEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $XpEventsTable,
    XpEventEntry,
    $$XpEventsTableFilterComposer,
    $$XpEventsTableOrderingComposer,
    $$XpEventsTableAnnotationComposer,
    $$XpEventsTableCreateCompanionBuilder,
    $$XpEventsTableUpdateCompanionBuilder,
    (XpEventEntry, BaseReferences<_$AppDatabase, $XpEventsTable, XpEventEntry>),
    XpEventEntry,
    PrefetchHooks Function()> {
  $$XpEventsTableTableManager(_$AppDatabase db, $XpEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceKey = const Value.absent(),
            Value<String> sourceType = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              XpEventsCompanion(
            id: id,
            sourceKey: sourceKey,
            sourceType: sourceType,
            amount: amount,
            summary: summary,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceKey,
            required String sourceType,
            required int amount,
            required String summary,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              XpEventsCompanion.insert(
            id: id,
            sourceKey: sourceKey,
            sourceType: sourceType,
            amount: amount,
            summary: summary,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$XpEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $XpEventsTable,
    XpEventEntry,
    $$XpEventsTableFilterComposer,
    $$XpEventsTableOrderingComposer,
    $$XpEventsTableAnnotationComposer,
    $$XpEventsTableCreateCompanionBuilder,
    $$XpEventsTableUpdateCompanionBuilder,
    (XpEventEntry, BaseReferences<_$AppDatabase, $XpEventsTable, XpEventEntry>),
    XpEventEntry,
    PrefetchHooks Function()>;
typedef $$UnlockedAchievementsTableCreateCompanionBuilder
    = UnlockedAchievementsCompanion Function({
  required String id,
  required String category,
  required String title,
  required String description,
  required DateTime unlockedAt,
  Value<int> rowid,
});
typedef $$UnlockedAchievementsTableUpdateCompanionBuilder
    = UnlockedAchievementsCompanion Function({
  Value<String> id,
  Value<String> category,
  Value<String> title,
  Value<String> description,
  Value<DateTime> unlockedAt,
  Value<int> rowid,
});

class $$UnlockedAchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementsTable> {
  $$UnlockedAchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$UnlockedAchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementsTable> {
  $$UnlockedAchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$UnlockedAchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementsTable> {
  $$UnlockedAchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$UnlockedAchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnlockedAchievementsTable,
    UnlockedAchievementEntry,
    $$UnlockedAchievementsTableFilterComposer,
    $$UnlockedAchievementsTableOrderingComposer,
    $$UnlockedAchievementsTableAnnotationComposer,
    $$UnlockedAchievementsTableCreateCompanionBuilder,
    $$UnlockedAchievementsTableUpdateCompanionBuilder,
    (
      UnlockedAchievementEntry,
      BaseReferences<_$AppDatabase, $UnlockedAchievementsTable,
          UnlockedAchievementEntry>
    ),
    UnlockedAchievementEntry,
    PrefetchHooks Function()> {
  $$UnlockedAchievementsTableTableManager(
      _$AppDatabase db, $UnlockedAchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedAchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockedAchievementsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlockedAchievementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnlockedAchievementsCompanion(
            id: id,
            category: category,
            title: title,
            description: description,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String category,
            required String title,
            required String description,
            required DateTime unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UnlockedAchievementsCompanion.insert(
            id: id,
            category: category,
            title: title,
            description: description,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnlockedAchievementsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UnlockedAchievementsTable,
        UnlockedAchievementEntry,
        $$UnlockedAchievementsTableFilterComposer,
        $$UnlockedAchievementsTableOrderingComposer,
        $$UnlockedAchievementsTableAnnotationComposer,
        $$UnlockedAchievementsTableCreateCompanionBuilder,
        $$UnlockedAchievementsTableUpdateCompanionBuilder,
        (
          UnlockedAchievementEntry,
          BaseReferences<_$AppDatabase, $UnlockedAchievementsTable,
              UnlockedAchievementEntry>
        ),
        UnlockedAchievementEntry,
        PrefetchHooks Function()>;
typedef $$RadarDiscoveriesTableCreateCompanionBuilder
    = RadarDiscoveriesCompanion Function({
  required String id,
  required String canonicalUrl,
  required String title,
  required String discoveryType,
  required String primaryCategory,
  Value<String> categoriesJson,
  Value<String> tagsJson,
  Value<String> priorityTier,
  required String sourceName,
  Value<String> sourceDomain,
  Value<String?> authorOrOrg,
  Value<String?> publishedAtIso,
  required DateTime discoveredAt,
  Value<String> rawSummary,
  Value<String?> plainEnglishSummary,
  Value<String?> whyItMatters,
  Value<String?> whoItIsFor,
  Value<String?> howItCompares,
  Value<String?> practicalTakeaway,
  Value<String?> tryItSuggestion,
  Value<String?> beginnerNote,
  Value<String> analysisSource,
  Value<String?> primaryMetricLabel,
  Value<double?> primaryMetricValue,
  Value<String?> secondaryMetricLabel,
  Value<double?> secondaryMetricValue,
  Value<String?> metricDeltaLabel,
  Value<double?> metricDeltaValue,
  Value<String> sourcesJson,
  Value<double> rankScore,
  Value<bool> isExploratory,
  Value<bool> isBookmarked,
  Value<String?> bookmarkCollection,
  Value<String?> bookmarkNote,
  Value<bool> isRead,
  Value<bool> isExplored,
  Value<bool> isHidden,
  Value<int> rowid,
});
typedef $$RadarDiscoveriesTableUpdateCompanionBuilder
    = RadarDiscoveriesCompanion Function({
  Value<String> id,
  Value<String> canonicalUrl,
  Value<String> title,
  Value<String> discoveryType,
  Value<String> primaryCategory,
  Value<String> categoriesJson,
  Value<String> tagsJson,
  Value<String> priorityTier,
  Value<String> sourceName,
  Value<String> sourceDomain,
  Value<String?> authorOrOrg,
  Value<String?> publishedAtIso,
  Value<DateTime> discoveredAt,
  Value<String> rawSummary,
  Value<String?> plainEnglishSummary,
  Value<String?> whyItMatters,
  Value<String?> whoItIsFor,
  Value<String?> howItCompares,
  Value<String?> practicalTakeaway,
  Value<String?> tryItSuggestion,
  Value<String?> beginnerNote,
  Value<String> analysisSource,
  Value<String?> primaryMetricLabel,
  Value<double?> primaryMetricValue,
  Value<String?> secondaryMetricLabel,
  Value<double?> secondaryMetricValue,
  Value<String?> metricDeltaLabel,
  Value<double?> metricDeltaValue,
  Value<String> sourcesJson,
  Value<double> rankScore,
  Value<bool> isExploratory,
  Value<bool> isBookmarked,
  Value<String?> bookmarkCollection,
  Value<String?> bookmarkNote,
  Value<bool> isRead,
  Value<bool> isExplored,
  Value<bool> isHidden,
  Value<int> rowid,
});

class $$RadarDiscoveriesTableFilterComposer
    extends Composer<_$AppDatabase, $RadarDiscoveriesTable> {
  $$RadarDiscoveriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get canonicalUrl => $composableBuilder(
      column: $table.canonicalUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get discoveryType => $composableBuilder(
      column: $table.discoveryType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryCategory => $composableBuilder(
      column: $table.primaryCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoriesJson => $composableBuilder(
      column: $table.categoriesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priorityTier => $composableBuilder(
      column: $table.priorityTier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceName => $composableBuilder(
      column: $table.sourceName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceDomain => $composableBuilder(
      column: $table.sourceDomain, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorOrOrg => $composableBuilder(
      column: $table.authorOrOrg, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publishedAtIso => $composableBuilder(
      column: $table.publishedAtIso,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get discoveredAt => $composableBuilder(
      column: $table.discoveredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawSummary => $composableBuilder(
      column: $table.rawSummary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plainEnglishSummary => $composableBuilder(
      column: $table.plainEnglishSummary,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whyItMatters => $composableBuilder(
      column: $table.whyItMatters, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whoItIsFor => $composableBuilder(
      column: $table.whoItIsFor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get howItCompares => $composableBuilder(
      column: $table.howItCompares, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get practicalTakeaway => $composableBuilder(
      column: $table.practicalTakeaway,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tryItSuggestion => $composableBuilder(
      column: $table.tryItSuggestion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get beginnerNote => $composableBuilder(
      column: $table.beginnerNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get analysisSource => $composableBuilder(
      column: $table.analysisSource,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryMetricLabel => $composableBuilder(
      column: $table.primaryMetricLabel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get primaryMetricValue => $composableBuilder(
      column: $table.primaryMetricValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get secondaryMetricLabel => $composableBuilder(
      column: $table.secondaryMetricLabel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get secondaryMetricValue => $composableBuilder(
      column: $table.secondaryMetricValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metricDeltaLabel => $composableBuilder(
      column: $table.metricDeltaLabel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get metricDeltaValue => $composableBuilder(
      column: $table.metricDeltaValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rankScore => $composableBuilder(
      column: $table.rankScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExploratory => $composableBuilder(
      column: $table.isExploratory, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookmarkCollection => $composableBuilder(
      column: $table.bookmarkCollection,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookmarkNote => $composableBuilder(
      column: $table.bookmarkNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExplored => $composableBuilder(
      column: $table.isExplored, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHidden => $composableBuilder(
      column: $table.isHidden, builder: (column) => ColumnFilters(column));
}

class $$RadarDiscoveriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RadarDiscoveriesTable> {
  $$RadarDiscoveriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get canonicalUrl => $composableBuilder(
      column: $table.canonicalUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get discoveryType => $composableBuilder(
      column: $table.discoveryType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryCategory => $composableBuilder(
      column: $table.primaryCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoriesJson => $composableBuilder(
      column: $table.categoriesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priorityTier => $composableBuilder(
      column: $table.priorityTier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceName => $composableBuilder(
      column: $table.sourceName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceDomain => $composableBuilder(
      column: $table.sourceDomain,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorOrOrg => $composableBuilder(
      column: $table.authorOrOrg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publishedAtIso => $composableBuilder(
      column: $table.publishedAtIso,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get discoveredAt => $composableBuilder(
      column: $table.discoveredAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawSummary => $composableBuilder(
      column: $table.rawSummary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plainEnglishSummary => $composableBuilder(
      column: $table.plainEnglishSummary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whyItMatters => $composableBuilder(
      column: $table.whyItMatters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whoItIsFor => $composableBuilder(
      column: $table.whoItIsFor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get howItCompares => $composableBuilder(
      column: $table.howItCompares,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get practicalTakeaway => $composableBuilder(
      column: $table.practicalTakeaway,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tryItSuggestion => $composableBuilder(
      column: $table.tryItSuggestion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get beginnerNote => $composableBuilder(
      column: $table.beginnerNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get analysisSource => $composableBuilder(
      column: $table.analysisSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryMetricLabel => $composableBuilder(
      column: $table.primaryMetricLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get primaryMetricValue => $composableBuilder(
      column: $table.primaryMetricValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secondaryMetricLabel => $composableBuilder(
      column: $table.secondaryMetricLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get secondaryMetricValue => $composableBuilder(
      column: $table.secondaryMetricValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metricDeltaLabel => $composableBuilder(
      column: $table.metricDeltaLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get metricDeltaValue => $composableBuilder(
      column: $table.metricDeltaValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rankScore => $composableBuilder(
      column: $table.rankScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExploratory => $composableBuilder(
      column: $table.isExploratory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookmarkCollection => $composableBuilder(
      column: $table.bookmarkCollection,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookmarkNote => $composableBuilder(
      column: $table.bookmarkNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExplored => $composableBuilder(
      column: $table.isExplored, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHidden => $composableBuilder(
      column: $table.isHidden, builder: (column) => ColumnOrderings(column));
}

class $$RadarDiscoveriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RadarDiscoveriesTable> {
  $$RadarDiscoveriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get canonicalUrl => $composableBuilder(
      column: $table.canonicalUrl, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get discoveryType => $composableBuilder(
      column: $table.discoveryType, builder: (column) => column);

  GeneratedColumn<String> get primaryCategory => $composableBuilder(
      column: $table.primaryCategory, builder: (column) => column);

  GeneratedColumn<String> get categoriesJson => $composableBuilder(
      column: $table.categoriesJson, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get priorityTier => $composableBuilder(
      column: $table.priorityTier, builder: (column) => column);

  GeneratedColumn<String> get sourceName => $composableBuilder(
      column: $table.sourceName, builder: (column) => column);

  GeneratedColumn<String> get sourceDomain => $composableBuilder(
      column: $table.sourceDomain, builder: (column) => column);

  GeneratedColumn<String> get authorOrOrg => $composableBuilder(
      column: $table.authorOrOrg, builder: (column) => column);

  GeneratedColumn<String> get publishedAtIso => $composableBuilder(
      column: $table.publishedAtIso, builder: (column) => column);

  GeneratedColumn<DateTime> get discoveredAt => $composableBuilder(
      column: $table.discoveredAt, builder: (column) => column);

  GeneratedColumn<String> get rawSummary => $composableBuilder(
      column: $table.rawSummary, builder: (column) => column);

  GeneratedColumn<String> get plainEnglishSummary => $composableBuilder(
      column: $table.plainEnglishSummary, builder: (column) => column);

  GeneratedColumn<String> get whyItMatters => $composableBuilder(
      column: $table.whyItMatters, builder: (column) => column);

  GeneratedColumn<String> get whoItIsFor => $composableBuilder(
      column: $table.whoItIsFor, builder: (column) => column);

  GeneratedColumn<String> get howItCompares => $composableBuilder(
      column: $table.howItCompares, builder: (column) => column);

  GeneratedColumn<String> get practicalTakeaway => $composableBuilder(
      column: $table.practicalTakeaway, builder: (column) => column);

  GeneratedColumn<String> get tryItSuggestion => $composableBuilder(
      column: $table.tryItSuggestion, builder: (column) => column);

  GeneratedColumn<String> get beginnerNote => $composableBuilder(
      column: $table.beginnerNote, builder: (column) => column);

  GeneratedColumn<String> get analysisSource => $composableBuilder(
      column: $table.analysisSource, builder: (column) => column);

  GeneratedColumn<String> get primaryMetricLabel => $composableBuilder(
      column: $table.primaryMetricLabel, builder: (column) => column);

  GeneratedColumn<double> get primaryMetricValue => $composableBuilder(
      column: $table.primaryMetricValue, builder: (column) => column);

  GeneratedColumn<String> get secondaryMetricLabel => $composableBuilder(
      column: $table.secondaryMetricLabel, builder: (column) => column);

  GeneratedColumn<double> get secondaryMetricValue => $composableBuilder(
      column: $table.secondaryMetricValue, builder: (column) => column);

  GeneratedColumn<String> get metricDeltaLabel => $composableBuilder(
      column: $table.metricDeltaLabel, builder: (column) => column);

  GeneratedColumn<double> get metricDeltaValue => $composableBuilder(
      column: $table.metricDeltaValue, builder: (column) => column);

  GeneratedColumn<String> get sourcesJson => $composableBuilder(
      column: $table.sourcesJson, builder: (column) => column);

  GeneratedColumn<double> get rankScore =>
      $composableBuilder(column: $table.rankScore, builder: (column) => column);

  GeneratedColumn<bool> get isExploratory => $composableBuilder(
      column: $table.isExploratory, builder: (column) => column);

  GeneratedColumn<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked, builder: (column) => column);

  GeneratedColumn<String> get bookmarkCollection => $composableBuilder(
      column: $table.bookmarkCollection, builder: (column) => column);

  GeneratedColumn<String> get bookmarkNote => $composableBuilder(
      column: $table.bookmarkNote, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<bool> get isExplored => $composableBuilder(
      column: $table.isExplored, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);
}

class $$RadarDiscoveriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RadarDiscoveriesTable,
    RadarDiscoveryEntry,
    $$RadarDiscoveriesTableFilterComposer,
    $$RadarDiscoveriesTableOrderingComposer,
    $$RadarDiscoveriesTableAnnotationComposer,
    $$RadarDiscoveriesTableCreateCompanionBuilder,
    $$RadarDiscoveriesTableUpdateCompanionBuilder,
    (
      RadarDiscoveryEntry,
      BaseReferences<_$AppDatabase, $RadarDiscoveriesTable, RadarDiscoveryEntry>
    ),
    RadarDiscoveryEntry,
    PrefetchHooks Function()> {
  $$RadarDiscoveriesTableTableManager(
      _$AppDatabase db, $RadarDiscoveriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RadarDiscoveriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadarDiscoveriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadarDiscoveriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> canonicalUrl = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> discoveryType = const Value.absent(),
            Value<String> primaryCategory = const Value.absent(),
            Value<String> categoriesJson = const Value.absent(),
            Value<String> tagsJson = const Value.absent(),
            Value<String> priorityTier = const Value.absent(),
            Value<String> sourceName = const Value.absent(),
            Value<String> sourceDomain = const Value.absent(),
            Value<String?> authorOrOrg = const Value.absent(),
            Value<String?> publishedAtIso = const Value.absent(),
            Value<DateTime> discoveredAt = const Value.absent(),
            Value<String> rawSummary = const Value.absent(),
            Value<String?> plainEnglishSummary = const Value.absent(),
            Value<String?> whyItMatters = const Value.absent(),
            Value<String?> whoItIsFor = const Value.absent(),
            Value<String?> howItCompares = const Value.absent(),
            Value<String?> practicalTakeaway = const Value.absent(),
            Value<String?> tryItSuggestion = const Value.absent(),
            Value<String?> beginnerNote = const Value.absent(),
            Value<String> analysisSource = const Value.absent(),
            Value<String?> primaryMetricLabel = const Value.absent(),
            Value<double?> primaryMetricValue = const Value.absent(),
            Value<String?> secondaryMetricLabel = const Value.absent(),
            Value<double?> secondaryMetricValue = const Value.absent(),
            Value<String?> metricDeltaLabel = const Value.absent(),
            Value<double?> metricDeltaValue = const Value.absent(),
            Value<String> sourcesJson = const Value.absent(),
            Value<double> rankScore = const Value.absent(),
            Value<bool> isExploratory = const Value.absent(),
            Value<bool> isBookmarked = const Value.absent(),
            Value<String?> bookmarkCollection = const Value.absent(),
            Value<String?> bookmarkNote = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<bool> isExplored = const Value.absent(),
            Value<bool> isHidden = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarDiscoveriesCompanion(
            id: id,
            canonicalUrl: canonicalUrl,
            title: title,
            discoveryType: discoveryType,
            primaryCategory: primaryCategory,
            categoriesJson: categoriesJson,
            tagsJson: tagsJson,
            priorityTier: priorityTier,
            sourceName: sourceName,
            sourceDomain: sourceDomain,
            authorOrOrg: authorOrOrg,
            publishedAtIso: publishedAtIso,
            discoveredAt: discoveredAt,
            rawSummary: rawSummary,
            plainEnglishSummary: plainEnglishSummary,
            whyItMatters: whyItMatters,
            whoItIsFor: whoItIsFor,
            howItCompares: howItCompares,
            practicalTakeaway: practicalTakeaway,
            tryItSuggestion: tryItSuggestion,
            beginnerNote: beginnerNote,
            analysisSource: analysisSource,
            primaryMetricLabel: primaryMetricLabel,
            primaryMetricValue: primaryMetricValue,
            secondaryMetricLabel: secondaryMetricLabel,
            secondaryMetricValue: secondaryMetricValue,
            metricDeltaLabel: metricDeltaLabel,
            metricDeltaValue: metricDeltaValue,
            sourcesJson: sourcesJson,
            rankScore: rankScore,
            isExploratory: isExploratory,
            isBookmarked: isBookmarked,
            bookmarkCollection: bookmarkCollection,
            bookmarkNote: bookmarkNote,
            isRead: isRead,
            isExplored: isExplored,
            isHidden: isHidden,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String canonicalUrl,
            required String title,
            required String discoveryType,
            required String primaryCategory,
            Value<String> categoriesJson = const Value.absent(),
            Value<String> tagsJson = const Value.absent(),
            Value<String> priorityTier = const Value.absent(),
            required String sourceName,
            Value<String> sourceDomain = const Value.absent(),
            Value<String?> authorOrOrg = const Value.absent(),
            Value<String?> publishedAtIso = const Value.absent(),
            required DateTime discoveredAt,
            Value<String> rawSummary = const Value.absent(),
            Value<String?> plainEnglishSummary = const Value.absent(),
            Value<String?> whyItMatters = const Value.absent(),
            Value<String?> whoItIsFor = const Value.absent(),
            Value<String?> howItCompares = const Value.absent(),
            Value<String?> practicalTakeaway = const Value.absent(),
            Value<String?> tryItSuggestion = const Value.absent(),
            Value<String?> beginnerNote = const Value.absent(),
            Value<String> analysisSource = const Value.absent(),
            Value<String?> primaryMetricLabel = const Value.absent(),
            Value<double?> primaryMetricValue = const Value.absent(),
            Value<String?> secondaryMetricLabel = const Value.absent(),
            Value<double?> secondaryMetricValue = const Value.absent(),
            Value<String?> metricDeltaLabel = const Value.absent(),
            Value<double?> metricDeltaValue = const Value.absent(),
            Value<String> sourcesJson = const Value.absent(),
            Value<double> rankScore = const Value.absent(),
            Value<bool> isExploratory = const Value.absent(),
            Value<bool> isBookmarked = const Value.absent(),
            Value<String?> bookmarkCollection = const Value.absent(),
            Value<String?> bookmarkNote = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<bool> isExplored = const Value.absent(),
            Value<bool> isHidden = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarDiscoveriesCompanion.insert(
            id: id,
            canonicalUrl: canonicalUrl,
            title: title,
            discoveryType: discoveryType,
            primaryCategory: primaryCategory,
            categoriesJson: categoriesJson,
            tagsJson: tagsJson,
            priorityTier: priorityTier,
            sourceName: sourceName,
            sourceDomain: sourceDomain,
            authorOrOrg: authorOrOrg,
            publishedAtIso: publishedAtIso,
            discoveredAt: discoveredAt,
            rawSummary: rawSummary,
            plainEnglishSummary: plainEnglishSummary,
            whyItMatters: whyItMatters,
            whoItIsFor: whoItIsFor,
            howItCompares: howItCompares,
            practicalTakeaway: practicalTakeaway,
            tryItSuggestion: tryItSuggestion,
            beginnerNote: beginnerNote,
            analysisSource: analysisSource,
            primaryMetricLabel: primaryMetricLabel,
            primaryMetricValue: primaryMetricValue,
            secondaryMetricLabel: secondaryMetricLabel,
            secondaryMetricValue: secondaryMetricValue,
            metricDeltaLabel: metricDeltaLabel,
            metricDeltaValue: metricDeltaValue,
            sourcesJson: sourcesJson,
            rankScore: rankScore,
            isExploratory: isExploratory,
            isBookmarked: isBookmarked,
            bookmarkCollection: bookmarkCollection,
            bookmarkNote: bookmarkNote,
            isRead: isRead,
            isExplored: isExplored,
            isHidden: isHidden,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RadarDiscoveriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RadarDiscoveriesTable,
    RadarDiscoveryEntry,
    $$RadarDiscoveriesTableFilterComposer,
    $$RadarDiscoveriesTableOrderingComposer,
    $$RadarDiscoveriesTableAnnotationComposer,
    $$RadarDiscoveriesTableCreateCompanionBuilder,
    $$RadarDiscoveriesTableUpdateCompanionBuilder,
    (
      RadarDiscoveryEntry,
      BaseReferences<_$AppDatabase, $RadarDiscoveriesTable, RadarDiscoveryEntry>
    ),
    RadarDiscoveryEntry,
    PrefetchHooks Function()>;
typedef $$RadarTopicPrefsTableCreateCompanionBuilder = RadarTopicPrefsCompanion
    Function({
  required String categoryCode,
  required String categoryName,
  Value<String> priorityLevel,
  Value<bool> isMuted,
  Value<String> boostKeywordsJson,
  Value<String> mutedKeywordsJson,
  Value<double> affinityAdjustment,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RadarTopicPrefsTableUpdateCompanionBuilder = RadarTopicPrefsCompanion
    Function({
  Value<String> categoryCode,
  Value<String> categoryName,
  Value<String> priorityLevel,
  Value<bool> isMuted,
  Value<String> boostKeywordsJson,
  Value<String> mutedKeywordsJson,
  Value<double> affinityAdjustment,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$RadarTopicPrefsTableFilterComposer
    extends Composer<_$AppDatabase, $RadarTopicPrefsTable> {
  $$RadarTopicPrefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoryCode => $composableBuilder(
      column: $table.categoryCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priorityLevel => $composableBuilder(
      column: $table.priorityLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMuted => $composableBuilder(
      column: $table.isMuted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get boostKeywordsJson => $composableBuilder(
      column: $table.boostKeywordsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mutedKeywordsJson => $composableBuilder(
      column: $table.mutedKeywordsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get affinityAdjustment => $composableBuilder(
      column: $table.affinityAdjustment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RadarTopicPrefsTableOrderingComposer
    extends Composer<_$AppDatabase, $RadarTopicPrefsTable> {
  $$RadarTopicPrefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoryCode => $composableBuilder(
      column: $table.categoryCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priorityLevel => $composableBuilder(
      column: $table.priorityLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMuted => $composableBuilder(
      column: $table.isMuted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get boostKeywordsJson => $composableBuilder(
      column: $table.boostKeywordsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mutedKeywordsJson => $composableBuilder(
      column: $table.mutedKeywordsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get affinityAdjustment => $composableBuilder(
      column: $table.affinityAdjustment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RadarTopicPrefsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RadarTopicPrefsTable> {
  $$RadarTopicPrefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoryCode => $composableBuilder(
      column: $table.categoryCode, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<String> get priorityLevel => $composableBuilder(
      column: $table.priorityLevel, builder: (column) => column);

  GeneratedColumn<bool> get isMuted =>
      $composableBuilder(column: $table.isMuted, builder: (column) => column);

  GeneratedColumn<String> get boostKeywordsJson => $composableBuilder(
      column: $table.boostKeywordsJson, builder: (column) => column);

  GeneratedColumn<String> get mutedKeywordsJson => $composableBuilder(
      column: $table.mutedKeywordsJson, builder: (column) => column);

  GeneratedColumn<double> get affinityAdjustment => $composableBuilder(
      column: $table.affinityAdjustment, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RadarTopicPrefsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RadarTopicPrefsTable,
    RadarTopicPrefEntry,
    $$RadarTopicPrefsTableFilterComposer,
    $$RadarTopicPrefsTableOrderingComposer,
    $$RadarTopicPrefsTableAnnotationComposer,
    $$RadarTopicPrefsTableCreateCompanionBuilder,
    $$RadarTopicPrefsTableUpdateCompanionBuilder,
    (
      RadarTopicPrefEntry,
      BaseReferences<_$AppDatabase, $RadarTopicPrefsTable, RadarTopicPrefEntry>
    ),
    RadarTopicPrefEntry,
    PrefetchHooks Function()> {
  $$RadarTopicPrefsTableTableManager(
      _$AppDatabase db, $RadarTopicPrefsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RadarTopicPrefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadarTopicPrefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadarTopicPrefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> categoryCode = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<String> priorityLevel = const Value.absent(),
            Value<bool> isMuted = const Value.absent(),
            Value<String> boostKeywordsJson = const Value.absent(),
            Value<String> mutedKeywordsJson = const Value.absent(),
            Value<double> affinityAdjustment = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarTopicPrefsCompanion(
            categoryCode: categoryCode,
            categoryName: categoryName,
            priorityLevel: priorityLevel,
            isMuted: isMuted,
            boostKeywordsJson: boostKeywordsJson,
            mutedKeywordsJson: mutedKeywordsJson,
            affinityAdjustment: affinityAdjustment,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String categoryCode,
            required String categoryName,
            Value<String> priorityLevel = const Value.absent(),
            Value<bool> isMuted = const Value.absent(),
            Value<String> boostKeywordsJson = const Value.absent(),
            Value<String> mutedKeywordsJson = const Value.absent(),
            Value<double> affinityAdjustment = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarTopicPrefsCompanion.insert(
            categoryCode: categoryCode,
            categoryName: categoryName,
            priorityLevel: priorityLevel,
            isMuted: isMuted,
            boostKeywordsJson: boostKeywordsJson,
            mutedKeywordsJson: mutedKeywordsJson,
            affinityAdjustment: affinityAdjustment,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RadarTopicPrefsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RadarTopicPrefsTable,
    RadarTopicPrefEntry,
    $$RadarTopicPrefsTableFilterComposer,
    $$RadarTopicPrefsTableOrderingComposer,
    $$RadarTopicPrefsTableAnnotationComposer,
    $$RadarTopicPrefsTableCreateCompanionBuilder,
    $$RadarTopicPrefsTableUpdateCompanionBuilder,
    (
      RadarTopicPrefEntry,
      BaseReferences<_$AppDatabase, $RadarTopicPrefsTable, RadarTopicPrefEntry>
    ),
    RadarTopicPrefEntry,
    PrefetchHooks Function()>;
typedef $$RadarFollowsTableCreateCompanionBuilder = RadarFollowsCompanion
    Function({
  required String id,
  required String followType,
  required String targetKey,
  required String displayName,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RadarFollowsTableUpdateCompanionBuilder = RadarFollowsCompanion
    Function({
  Value<String> id,
  Value<String> followType,
  Value<String> targetKey,
  Value<String> displayName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RadarFollowsTableFilterComposer
    extends Composer<_$AppDatabase, $RadarFollowsTable> {
  $$RadarFollowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get followType => $composableBuilder(
      column: $table.followType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetKey => $composableBuilder(
      column: $table.targetKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RadarFollowsTableOrderingComposer
    extends Composer<_$AppDatabase, $RadarFollowsTable> {
  $$RadarFollowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get followType => $composableBuilder(
      column: $table.followType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetKey => $composableBuilder(
      column: $table.targetKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RadarFollowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RadarFollowsTable> {
  $$RadarFollowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get followType => $composableBuilder(
      column: $table.followType, builder: (column) => column);

  GeneratedColumn<String> get targetKey =>
      $composableBuilder(column: $table.targetKey, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RadarFollowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RadarFollowsTable,
    RadarFollowEntry,
    $$RadarFollowsTableFilterComposer,
    $$RadarFollowsTableOrderingComposer,
    $$RadarFollowsTableAnnotationComposer,
    $$RadarFollowsTableCreateCompanionBuilder,
    $$RadarFollowsTableUpdateCompanionBuilder,
    (
      RadarFollowEntry,
      BaseReferences<_$AppDatabase, $RadarFollowsTable, RadarFollowEntry>
    ),
    RadarFollowEntry,
    PrefetchHooks Function()> {
  $$RadarFollowsTableTableManager(_$AppDatabase db, $RadarFollowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RadarFollowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadarFollowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadarFollowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> followType = const Value.absent(),
            Value<String> targetKey = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarFollowsCompanion(
            id: id,
            followType: followType,
            targetKey: targetKey,
            displayName: displayName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String followType,
            required String targetKey,
            required String displayName,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarFollowsCompanion.insert(
            id: id,
            followType: followType,
            targetKey: targetKey,
            displayName: displayName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RadarFollowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RadarFollowsTable,
    RadarFollowEntry,
    $$RadarFollowsTableFilterComposer,
    $$RadarFollowsTableOrderingComposer,
    $$RadarFollowsTableAnnotationComposer,
    $$RadarFollowsTableCreateCompanionBuilder,
    $$RadarFollowsTableUpdateCompanionBuilder,
    (
      RadarFollowEntry,
      BaseReferences<_$AppDatabase, $RadarFollowsTable, RadarFollowEntry>
    ),
    RadarFollowEntry,
    PrefetchHooks Function()>;
typedef $$RadarFeedbackLogsTableCreateCompanionBuilder
    = RadarFeedbackLogsCompanion Function({
  required String id,
  required String discoveryId,
  required String action,
  required String categoryCode,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RadarFeedbackLogsTableUpdateCompanionBuilder
    = RadarFeedbackLogsCompanion Function({
  Value<String> id,
  Value<String> discoveryId,
  Value<String> action,
  Value<String> categoryCode,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RadarFeedbackLogsTableFilterComposer
    extends Composer<_$AppDatabase, $RadarFeedbackLogsTable> {
  $$RadarFeedbackLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get discoveryId => $composableBuilder(
      column: $table.discoveryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryCode => $composableBuilder(
      column: $table.categoryCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RadarFeedbackLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $RadarFeedbackLogsTable> {
  $$RadarFeedbackLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get discoveryId => $composableBuilder(
      column: $table.discoveryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryCode => $composableBuilder(
      column: $table.categoryCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RadarFeedbackLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RadarFeedbackLogsTable> {
  $$RadarFeedbackLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get discoveryId => $composableBuilder(
      column: $table.discoveryId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get categoryCode => $composableBuilder(
      column: $table.categoryCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RadarFeedbackLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RadarFeedbackLogsTable,
    RadarFeedbackLogEntry,
    $$RadarFeedbackLogsTableFilterComposer,
    $$RadarFeedbackLogsTableOrderingComposer,
    $$RadarFeedbackLogsTableAnnotationComposer,
    $$RadarFeedbackLogsTableCreateCompanionBuilder,
    $$RadarFeedbackLogsTableUpdateCompanionBuilder,
    (
      RadarFeedbackLogEntry,
      BaseReferences<_$AppDatabase, $RadarFeedbackLogsTable,
          RadarFeedbackLogEntry>
    ),
    RadarFeedbackLogEntry,
    PrefetchHooks Function()> {
  $$RadarFeedbackLogsTableTableManager(
      _$AppDatabase db, $RadarFeedbackLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RadarFeedbackLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadarFeedbackLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadarFeedbackLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> discoveryId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> categoryCode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarFeedbackLogsCompanion(
            id: id,
            discoveryId: discoveryId,
            action: action,
            categoryCode: categoryCode,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String discoveryId,
            required String action,
            required String categoryCode,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarFeedbackLogsCompanion.insert(
            id: id,
            discoveryId: discoveryId,
            action: action,
            categoryCode: categoryCode,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RadarFeedbackLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RadarFeedbackLogsTable,
    RadarFeedbackLogEntry,
    $$RadarFeedbackLogsTableFilterComposer,
    $$RadarFeedbackLogsTableOrderingComposer,
    $$RadarFeedbackLogsTableAnnotationComposer,
    $$RadarFeedbackLogsTableCreateCompanionBuilder,
    $$RadarFeedbackLogsTableUpdateCompanionBuilder,
    (
      RadarFeedbackLogEntry,
      BaseReferences<_$AppDatabase, $RadarFeedbackLogsTable,
          RadarFeedbackLogEntry>
    ),
    RadarFeedbackLogEntry,
    PrefetchHooks Function()>;
typedef $$RadarBriefingsTableCreateCompanionBuilder = RadarBriefingsCompanion
    Function({
  required String id,
  required String briefingType,
  required String briefingDate,
  required String headline,
  required String sectionsJson,
  Value<String> generatedBy,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RadarBriefingsTableUpdateCompanionBuilder = RadarBriefingsCompanion
    Function({
  Value<String> id,
  Value<String> briefingType,
  Value<String> briefingDate,
  Value<String> headline,
  Value<String> sectionsJson,
  Value<String> generatedBy,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RadarBriefingsTableFilterComposer
    extends Composer<_$AppDatabase, $RadarBriefingsTable> {
  $$RadarBriefingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get briefingType => $composableBuilder(
      column: $table.briefingType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get briefingDate => $composableBuilder(
      column: $table.briefingDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get headline => $composableBuilder(
      column: $table.headline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sectionsJson => $composableBuilder(
      column: $table.sectionsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get generatedBy => $composableBuilder(
      column: $table.generatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RadarBriefingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RadarBriefingsTable> {
  $$RadarBriefingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get briefingType => $composableBuilder(
      column: $table.briefingType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get briefingDate => $composableBuilder(
      column: $table.briefingDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get headline => $composableBuilder(
      column: $table.headline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sectionsJson => $composableBuilder(
      column: $table.sectionsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get generatedBy => $composableBuilder(
      column: $table.generatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RadarBriefingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RadarBriefingsTable> {
  $$RadarBriefingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get briefingType => $composableBuilder(
      column: $table.briefingType, builder: (column) => column);

  GeneratedColumn<String> get briefingDate => $composableBuilder(
      column: $table.briefingDate, builder: (column) => column);

  GeneratedColumn<String> get headline =>
      $composableBuilder(column: $table.headline, builder: (column) => column);

  GeneratedColumn<String> get sectionsJson => $composableBuilder(
      column: $table.sectionsJson, builder: (column) => column);

  GeneratedColumn<String> get generatedBy => $composableBuilder(
      column: $table.generatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RadarBriefingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RadarBriefingsTable,
    RadarBriefingEntry,
    $$RadarBriefingsTableFilterComposer,
    $$RadarBriefingsTableOrderingComposer,
    $$RadarBriefingsTableAnnotationComposer,
    $$RadarBriefingsTableCreateCompanionBuilder,
    $$RadarBriefingsTableUpdateCompanionBuilder,
    (
      RadarBriefingEntry,
      BaseReferences<_$AppDatabase, $RadarBriefingsTable, RadarBriefingEntry>
    ),
    RadarBriefingEntry,
    PrefetchHooks Function()> {
  $$RadarBriefingsTableTableManager(
      _$AppDatabase db, $RadarBriefingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RadarBriefingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RadarBriefingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RadarBriefingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> briefingType = const Value.absent(),
            Value<String> briefingDate = const Value.absent(),
            Value<String> headline = const Value.absent(),
            Value<String> sectionsJson = const Value.absent(),
            Value<String> generatedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarBriefingsCompanion(
            id: id,
            briefingType: briefingType,
            briefingDate: briefingDate,
            headline: headline,
            sectionsJson: sectionsJson,
            generatedBy: generatedBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String briefingType,
            required String briefingDate,
            required String headline,
            required String sectionsJson,
            Value<String> generatedBy = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RadarBriefingsCompanion.insert(
            id: id,
            briefingType: briefingType,
            briefingDate: briefingDate,
            headline: headline,
            sectionsJson: sectionsJson,
            generatedBy: generatedBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RadarBriefingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RadarBriefingsTable,
    RadarBriefingEntry,
    $$RadarBriefingsTableFilterComposer,
    $$RadarBriefingsTableOrderingComposer,
    $$RadarBriefingsTableAnnotationComposer,
    $$RadarBriefingsTableCreateCompanionBuilder,
    $$RadarBriefingsTableUpdateCompanionBuilder,
    (
      RadarBriefingEntry,
      BaseReferences<_$AppDatabase, $RadarBriefingsTable, RadarBriefingEntry>
    ),
    RadarBriefingEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db, _db.subtasks);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$MilestonesTableTableManager get milestones =>
      $$MilestonesTableTableManager(_db, _db.milestones);
  $$SkillsTableTableManager get skills =>
      $$SkillsTableTableManager(_db, _db.skills);
  $$LearningModulesTableTableManager get learningModules =>
      $$LearningModulesTableTableManager(_db, _db.learningModules);
  $$LearningTopicsTableTableManager get learningTopics =>
      $$LearningTopicsTableTableManager(_db, _db.learningTopics);
  $$LearningSessionsTableTableManager get learningSessions =>
      $$LearningSessionsTableTableManager(_db, _db.learningSessions);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitEntriesTableTableManager get habitEntries =>
      $$HabitEntriesTableTableManager(_db, _db.habitEntries);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$ScheduledNotificationsTableTableManager get scheduledNotifications =>
      $$ScheduledNotificationsTableTableManager(
          _db, _db.scheduledNotifications);
  $$ActivityHistoryTableTableManager get activityHistory =>
      $$ActivityHistoryTableTableManager(_db, _db.activityHistory);
  $$XpEventsTableTableManager get xpEvents =>
      $$XpEventsTableTableManager(_db, _db.xpEvents);
  $$UnlockedAchievementsTableTableManager get unlockedAchievements =>
      $$UnlockedAchievementsTableTableManager(_db, _db.unlockedAchievements);
  $$RadarDiscoveriesTableTableManager get radarDiscoveries =>
      $$RadarDiscoveriesTableTableManager(_db, _db.radarDiscoveries);
  $$RadarTopicPrefsTableTableManager get radarTopicPrefs =>
      $$RadarTopicPrefsTableTableManager(_db, _db.radarTopicPrefs);
  $$RadarFollowsTableTableManager get radarFollows =>
      $$RadarFollowsTableTableManager(_db, _db.radarFollows);
  $$RadarFeedbackLogsTableTableManager get radarFeedbackLogs =>
      $$RadarFeedbackLogsTableTableManager(_db, _db.radarFeedbackLogs);
  $$RadarBriefingsTableTableManager get radarBriefings =>
      $$RadarBriefingsTableTableManager(_db, _db.radarBriefings);
}
