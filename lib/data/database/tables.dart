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
  TextColumn get status => text().withDefault(const Constant('active'))(); // not_started, in_progress, on_hold, completed, archived
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get techStack => text().withDefault(const Constant(''))(); // Comma-separated tech list
  TextColumn get repositoryUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get timeSpentMinutes => integer().withDefault(const Constant(0))();
  TextColumn get completionCriteria => text().withDefault(const Constant('milestone'))(); // milestone, task, deliverable, manual
  RealColumn get manualProgressPercentage => real().withDefault(const Constant(0.0))();
  RealColumn get targetHours => real().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get completionNote => text().nullable()();
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
  IntColumn get weight => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

// Project Deliverables Table
@DataClassName('ProjectDeliverableEntry')
class ProjectDeliverables extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 250)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

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
  TextColumn get progressMethod => text().withDefault(const Constant('topics'))(); // topics, time, manual
  IntColumn get targetMinutes => integer().withDefault(const Constant(0))();
  IntColumn get targetTopicsCount => integer().withDefault(const Constant(0))();
  RealColumn get manualProgressPercentage => real().withDefault(const Constant(0.0))();
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
  IntColumn get breakMinutes => integer().withDefault(const Constant(0))();
  TextColumn get sessionType => text().withDefault(const Constant('pomodoro'))(); // pomodoro, short_break, long_break, custom
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get notes => text().nullable()();

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

// Auditable XP Reward Ledger Table (duplicate-guarded by unique sourceKey)
@DataClassName('XpEventEntry')
class XpEvents extends Table {
  TextColumn get id => text()();
  TextColumn get sourceKey => text().unique()();
  TextColumn get sourceType => text()(); // task, learning, focus, habit, milestone, goal
  IntColumn get amount => integer()();
  TextColumn get summary => text().withLength(min: 1, max: 240)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Unlocked Achievement Badges Table
@DataClassName('UnlockedAchievementEntry')
class UnlockedAchievements extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()(); // consistency, learning, focus, projects, exploration, milestones
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get description => text().withLength(min: 1, max: 260)();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ProgressOS Radar: Synced & Cached Technology Discoveries (Zero Secrets Stored)
@DataClassName('RadarDiscoveryEntry')
class RadarDiscoveries extends Table {
  TextColumn get id => text()();
  TextColumn get canonicalUrl => text().unique()();
  TextColumn get title => text()();
  TextColumn get discoveryType => text()(); // repo, video, research, article, product, community, model
  TextColumn get primaryCategory => text()(); // A..R
  TextColumn get categoriesJson => text().withDefault(const Constant('[]'))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get priorityTier => text().withDefault(const Constant('P1'))();
  TextColumn get sourceName => text()();
  TextColumn get sourceDomain => text().withDefault(const Constant(''))();
  TextColumn get authorOrOrg => text().nullable()();
  TextColumn get publishedAtIso => text().nullable()();
  DateTimeColumn get discoveredAt => dateTime()();
  TextColumn get rawSummary => text().withDefault(const Constant(''))();
  TextColumn get plainEnglishSummary => text().nullable()();
  TextColumn get whyItMatters => text().nullable()();
  TextColumn get whoItIsFor => text().nullable()();
  TextColumn get howItCompares => text().nullable()();
  TextColumn get practicalTakeaway => text().nullable()();
  TextColumn get tryItSuggestion => text().nullable()();
  TextColumn get beginnerNote => text().nullable()();
  TextColumn get analysisSource => text().withDefault(const Constant('source_reported'))();
  TextColumn get primaryMetricLabel => text().nullable()();
  RealColumn get primaryMetricValue => real().nullable()();
  TextColumn get secondaryMetricLabel => text().nullable()();
  RealColumn get secondaryMetricValue => real().nullable()();
  TextColumn get metricDeltaLabel => text().nullable()();
  RealColumn get metricDeltaValue => real().nullable()();
  TextColumn get sourcesJson => text().withDefault(const Constant('[]'))();
  RealColumn get rankScore => real().withDefault(const Constant(0.0))();
  BoolColumn get isExploratory => boolean().withDefault(const Constant(false))();
  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();
  TextColumn get bookmarkCollection => text().nullable()();
  TextColumn get bookmarkNote => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  BoolColumn get isExplored => boolean().withDefault(const Constant(false))();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// ProgressOS Radar: Configurable 18 Topic Preferences (A..R across P0..P3)
@DataClassName('RadarTopicPrefEntry')
class RadarTopicPrefs extends Table {
  TextColumn get categoryCode => text()();
  TextColumn get categoryName => text()();
  TextColumn get priorityLevel => text().withDefault(const Constant('P1'))();
  BoolColumn get isMuted => boolean().withDefault(const Constant(false))();
  TextColumn get boostKeywordsJson => text().withDefault(const Constant('[]'))();
  TextColumn get mutedKeywordsJson => text().withDefault(const Constant('[]'))();
  RealColumn get affinityAdjustment => real().withDefault(const Constant(0.0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {categoryCode};
}

// ProgressOS Radar: Followed Topics, Repos, Orgs & Creators
@DataClassName('RadarFollowEntry')
class RadarFollows extends Table {
  TextColumn get id => text()();
  TextColumn get followType => text()(); // topic, creator, repo, org
  TextColumn get targetKey => text()();
  TextColumn get displayName => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ProgressOS Radar: User Feedback & Engagement Log (Relevant / Not Relevant / Explored)
@DataClassName('RadarFeedbackLogEntry')
class RadarFeedbackLogs extends Table {
  TextColumn get id => text()();
  TextColumn get discoveryId => text()();
  TextColumn get action => text()(); // relevant, not_relevant, more_like_this, hide, explored, opened
  TextColumn get categoryCode => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ProgressOS Radar: Cached Daily Briefings & Weekly Recaps
@DataClassName('RadarBriefingEntry')
class RadarBriefings extends Table {
  TextColumn get id => text()();
  TextColumn get briefingType => text()(); // daily, weekly
  TextColumn get briefingDate => text()();
  TextColumn get headline => text()();
  TextColumn get sectionsJson => text()();
  TextColumn get generatedBy => text().withDefault(const Constant('radar_curator'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

