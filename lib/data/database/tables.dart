import 'package:drift/drift.dart';

// Tasks Table
@DataClassName('TaskEntry')
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 250)();
  TextColumn get description => text().nullable()();
  TextColumn get priority => text().withDefault(const Constant('medium'))(); // low, medium, high, urgent
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get hasDueTime => boolean().withDefault(const Constant(false))();
  DateTimeColumn get reminderAt => dateTime().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get skillId => text().nullable()();
  IntColumn get estimatedMinutes => integer().withDefault(const Constant(0))();
  IntColumn get actualMinutes => integer().withDefault(const Constant(0))();
  TextColumn get recurrence => text().withDefault(const Constant('none'))(); // none, daily, weekly, monthly, weekdays
  TextColumn get tags => text().withDefault(const Constant(''))(); // comma separated
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Subtasks Table
@DataClassName('SubtaskEntry')
class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 250)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Projects Table
@DataClassName('ProjectEntry')
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('Development'))(); // Startup, Web, Flutter, ML, IoT, College, OSS
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get targetDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))(); // planning, active, on_hold, completed, archived
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get techStack => text().withDefault(const Constant(''))(); // Comma-separated tech list
  TextColumn get repositoryUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get timeSpentMinutes => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Milestones Table
@DataClassName('MilestoneEntry')
class Milestones extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 250)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get targetDate => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// Skills Table
@DataClassName('SkillEntry')
class Skills extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get category => text().withDefault(const Constant('General'))(); // Language, Framework, AI, Systems, etc.
  TextColumn get currentLevel => text().withDefault(const Constant('beginner'))(); // beginner, elementary, intermediate, advanced, expert
  TextColumn get targetLevel => text().withDefault(const Constant('intermediate'))();
  TextColumn get notes => text().nullable()();
  IntColumn get learningMinutes => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Learning Modules Table
@DataClassName('LearningModuleEntry')
class LearningModules extends Table {
  TextColumn get id => text()();
  TextColumn get skillId => text().references(Skills, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// Learning Topics Table
@DataClassName('LearningTopicEntry')
class LearningTopics extends Table {
  TextColumn get id => text()();
  TextColumn get moduleId => text().references(LearningModules, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get status => text().withDefault(const Constant('planned'))(); // planned, in_progress, completed
  TextColumn get resources => text().withDefault(const Constant(''))();
  TextColumn get notes => text().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Learning Sessions Table
@DataClassName('LearningSessionEntry')
class LearningSessions extends Table {
  TextColumn get id => text()();
  TextColumn get skillId => text().references(Skills, #id, onDelete: KeyAction.cascade)();
  TextColumn get topicId => text().nullable()();
  IntColumn get durationMinutes => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Goals Table
@DataClassName('GoalEntry')
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('daily'))(); // daily, weekly, monthly, long_term
  RealColumn get targetValue => real()();
  RealColumn get currentValue => real().withDefault(const Constant(0.0))();
  TextColumn get unit => text().withDefault(const Constant('hrs'))();
  DateTimeColumn get deadline => dateTime().nullable()();
  BoolColumn get isAchieved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Habits Table
@DataClassName('HabitEntryRecord')
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get frequency => text().withDefault(const Constant('daily'))(); // daily, weekdays, custom
  IntColumn get targetDaysPerWeek => integer().withDefault(const Constant(7))();
  TextColumn get reminderTime => text().nullable()(); // e.g. "20:00"
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Habit Entries (Daily Check-ins)
@DataClassName('HabitDailyLog')
class HabitEntries extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get dateStr => text()(); // YYYY-MM-DD
  BoolColumn get isCompleted => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Focus Sessions Table
@DataClassName('FocusSessionEntry')
class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get skillId => text().nullable()();
  IntColumn get durationMinutes => integer()();
  TextColumn get sessionType => text().withDefault(const Constant('pomodoro'))(); // pomodoro, short_break, long_break, custom
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Notes Table (Knowledge Vault)
@DataClassName('NoteEntry')
class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get content => text()();
  TextColumn get category => text().withDefault(const Constant('general'))(); // quick, technical, idea, resource, general
  TextColumn get tags => text().withDefault(const Constant(''))();
  TextColumn get projectId => text().nullable()();
  TextColumn get skillId => text().nullable()();
  TextColumn get taskId => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Scheduled Notifications Table
@DataClassName('ScheduledNotificationEntry')
class ScheduledNotifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskId => text().nullable()();
  TextColumn get type => text()(); // task_reminder, deadline, daily_agenda, habit
  DateTimeColumn get scheduledTime => dateTime()();
  TextColumn get payload => text().withDefault(const Constant(''))();
}

// Activity History Table
@DataClassName('ActivityHistoryEntry')
class ActivityHistory extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()(); // task, project, skill, milestone, focus, habit
  TextColumn get entityId => text().nullable()();
  TextColumn get action => text()(); // created, completed, progressed, logged
  TextColumn get summary => text().withLength(min: 1, max: 300)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

