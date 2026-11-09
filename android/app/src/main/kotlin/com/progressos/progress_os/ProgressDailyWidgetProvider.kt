package com.progressos.progress_os

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ProgressDailyWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_daily_progress)
            val widgetData = HomeWidgetPlugin.getData(context)

            val rate = widgetData.getInt("daily_completion_rate", 0)
            val completed = widgetData.getInt("completed_tasks_count", 0)
            val remaining = widgetData.getInt("remaining_tasks_count", 0)
            val dateStr = widgetData.getString("today_date_str", "Today")

            views.setTextViewText(R.id.tv_daily_percent, "$rate%")
            views.setProgressBar(R.id.pb_daily_progress, 100, rate, false)
            views.setTextViewText(R.id.tv_daily_tasks_summary, "$completed completed • $remaining remaining")
            views.setTextViewText(R.id.tv_daily_date, dateStr)

            // Click opens the app
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_daily_container, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
