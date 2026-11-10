import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted settings for haptics, in-app subtle sounds, and notification sound behavior.
class FeedbackSettings {
  final bool hapticsEnabled;
  final bool soundEffectsEnabled;
  final bool notificationSoundsEnabled;

  const FeedbackSettings({
    this.hapticsEnabled = true,
    this.soundEffectsEnabled = true,
    this.notificationSoundsEnabled = true,
  });

  FeedbackSettings copyWith({
    bool? hapticsEnabled,
    bool? soundEffectsEnabled,
    bool? notificationSoundsEnabled,
  }) {
    return FeedbackSettings(
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      notificationSoundsEnabled: notificationSoundsEnabled ?? this.notificationSoundsEnabled,
    );
  }
}

class FeedbackSettingsNotifier extends StateNotifier<FeedbackSettings> {
  static const _keyHaptics = 'feedback_haptics_enabled';
  static const _keySounds = 'feedback_sound_effects_enabled';
  static const _keyNotifSounds = 'feedback_notification_sounds_enabled';

  FeedbackSettingsNotifier() : super(const FeedbackSettings()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = FeedbackSettings(
        hapticsEnabled: prefs.getBool(_keyHaptics) ?? true,
        soundEffectsEnabled: prefs.getBool(_keySounds) ?? true,
        notificationSoundsEnabled: prefs.getBool(_keyNotifSounds) ?? true,
      );
    } catch (_) {
      // Graceful fallback in restricted or test environments
    }
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    state = state.copyWith(hapticsEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHaptics, enabled);
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    state = state.copyWith(soundEffectsEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySounds, enabled);
  }

  Future<void> setNotificationSoundsEnabled(bool enabled) async {
    state = state.copyWith(notificationSoundsEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifSounds, enabled);
  }
}

final feedbackSettingsProvider =
    StateNotifierProvider<FeedbackSettingsNotifier, FeedbackSettings>((ref) {
  return FeedbackSettingsNotifier();
});

/// Centralized Haptic & Sound Interaction Feedback Service.
/// Prevents scattered haptic/audio calls, throttles burst triggers, and respects
/// both in-app user toggles and platform silent/ringer policies.
class FeedbackService {
  static const MethodChannel _channel = MethodChannel('com.progressos.progress_os/feedback');

  final Ref _ref;
  DateTime? _lastHapticAt;
  DateTime? _lastSoundAt;

  FeedbackService(this._ref);

  FeedbackSettings get _settings => _ref.read(feedbackSettingsProvider);

  bool _canTriggerHaptic() {
    if (!_settings.hapticsEnabled) return false;
    final now = DateTime.now();
    if (_lastHapticAt != null && now.difference(_lastHapticAt!).inMilliseconds < 45) {
      return false;
    }
    _lastHapticAt = now;
    return true;
  }

  bool _canPlaySound() {
    if (!_settings.soundEffectsEnabled || kIsWeb) return false;
    final now = DateTime.now();
    if (_lastSoundAt != null && now.difference(_lastSoundAt!).inMilliseconds < 120) {
      return false;
    }
    _lastSoundAt = now;
    return true;
  }

  Future<void> _playAssetSound(String soundKey) async {
    if (!_canPlaySound()) return;
    try {
      await _channel.invokeMethod('playSound', {'name': soundKey});
    } on MissingPluginException {
      // Safe no-op on widget tests / unsupported platforms
    } catch (e) {
      debugPrint('FeedbackService sound skipped ($soundKey): $e');
    }
  }

  /// Safely triggers a button haptic through Riverpod if available in [context],
  /// preventing standalone widget tests without a ProviderScope from failing.
  static void triggerButtonTapSafely(BuildContext context) {
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      container.read(feedbackServiceProvider).buttonTap();
    } catch (_) {
      // No ProviderScope ancestor (e.g. isolated design-system widget tests)
    }
  }

  /// Light impact for standard button taps & selection switches
  Future<void> buttonTap() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Selection click for filters, habit check-ins, and drag reordering
  Future<void> selectionClick() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Gentle positive feedback & soft chime on completing a task
  Future<void> taskCompleted({bool completed = true}) async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.lightImpact();
    }
    if (completed) {
      await _playAssetSound('task_complete');
    }
  }

  /// Habit daily check-in feedback
  Future<void> habitCheckedIn() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Medium success feedback for milestones & project breakthroughs
  Future<void> milestoneAchieved() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.mediumImpact();
    }
    await _playAssetSound('milestone_achieved');
  }

  /// Dedicated goal achieved celebration chime
  Future<void> goalAchieved() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.mediumImpact();
    }
    await _playAssetSound('goal_achieved');
  }

  /// Soft celebration chime on unlocking an achievement badge
  Future<void> achievementUnlocked() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.mediumImpact();
    }
    await _playAssetSound('achievement_unlocked');
  }

  /// Drag-and-drop reorder feedback
  Future<void> reorder() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Focus session start feedback
  Future<void> timerStart() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.lightImpact();
    }
    await _playAssetSound('focus_start');
  }

  /// Distinct completion feedback & warm arpeggio chime on Pomodoro completion
  Future<void> timerComplete() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 110));
      await HapticFeedback.mediumImpact();
    }
    await _playAssetSound('focus_complete');
  }

  /// Soft alert chime for previewing reminders in Settings
  Future<void> playPreviewAlert() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.lightImpact();
    }
    await _playAssetSound('reminder_alert');
  }

  /// Distinct warning feedback before or during destructive actions
  Future<void> destructiveAction() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Validation error haptic
  Future<void> validationError() async {
    if (_canTriggerHaptic()) {
      await HapticFeedback.vibrate();
    }
  }

  /// Launches an external http/https URL natively via Android Intent; returns false if unavailable.
  Future<bool> openExternalUrl(String url) async {
    final trimmed = url.trim();
    if (!trimmed.startsWith('https://') && !trimmed.startsWith('http://')) {
      return false;
    }
    try {
      final launched = await _channel.invokeMethod<bool>('openUrl', {'url': trimmed});
      if (launched == true) return true;
    } catch (_) {
      // Missing platform handler on headless tests or desktop targets
    }
    try {
      await Clipboard.setData(ClipboardData(text: trimmed));
    } catch (_) {}
    return false;
  }
}

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return FeedbackService(ref);
});

