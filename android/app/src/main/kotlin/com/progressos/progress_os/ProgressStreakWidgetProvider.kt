package com.progressos.progress_os

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ProgressStreakWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_streak)
            val widgetData = HomeWidgetPlugin.getData(context)

            val streak = widgetData.getInt("streak_days", 0)
            val hours = widgetData.getString("learning_hours", "0.0")

            views.setTextViewText(R.id.tv_streak_days, streak.toString())
            views.setTextViewText(R.id.tv_learning_hours, "$hours hrs total learning")

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("action", "open_habits")
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                2,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_streak_container, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

