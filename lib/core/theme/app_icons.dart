import 'package:flutter/material.dart';

/// Central Semantic Icon Mapping using consistent rounded Material Symbols.
/// Uses outline geometries by default and solid/filled variants only for active selection states.
class AppIcons {
  AppIcons._();

  // Primary Navigation (Outline -> Active)
  static const IconData home = Icons.home_outlined;
  static const IconData homeActive = Icons.home_rounded;

  static const IconData tasks = Icons.check_circle_outline_rounded;
  static const IconData tasksActive = Icons.check_circle_rounded;

  static const IconData projects = Icons.folder_outlined;
  static const IconData projectsActive = Icons.folder_rounded;

  static const IconData learning = Icons.school_outlined;
  static const IconData learningActive = Icons.school_rounded;

  static const IconData more = Icons.grid_view_outlined;
  static const IconData moreActive = Icons.grid_view_rounded;

  // Sub-modules
  static const IconData goals = Icons.flag_outlined;
  static const IconData goalsActive = Icons.flag_rounded;

  static const IconData habits = Icons.repeat_rounded;
  static const IconData focus = Icons.timer_outlined;
  static const IconData focusActive = Icons.timer_rounded;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData notes = Icons.menu_book_outlined;
  static const IconData journal = Icons.edit_note_rounded;
  static const IconData analytics = Icons.bar_chart_rounded;
  static const IconData settings = Icons.settings_outlined;

  // Common Actions & UI Indicators
  static const IconData search = Icons.search_rounded;
  static const IconData notifications = Icons.notifications_none_rounded;
  static const IconData notificationsActive = Icons.notifications_active_outlined;
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData filter = Icons.tune_rounded;
  static const IconData sort = Icons.swap_vert_rounded;
  static const IconData timer = Icons.hourglass_bottom_rounded;
  static const IconData reminder = Icons.alarm_outlined;
  static const IconData completion = Icons.check_rounded;
  static const IconData back = Icons.arrow_back_rounded;
  static const IconData forward = Icons.chevron_right_rounded;
  static const IconData close = Icons.close_rounded;
}

