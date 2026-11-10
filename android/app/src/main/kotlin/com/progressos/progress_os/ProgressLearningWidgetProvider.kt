package com.progressos.progress_os

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ProgressLearningWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_learning)
            val widgetData = HomeWidgetPlugin.getData(context)

            val skillName = widgetData.getString("learning_skill_name", "Start a Skill Roadmap")
            val topicsDone = widgetData.getInt("learning_topics_done", 0)
            val topicsTotal = widgetData.getInt("learning_topics_total", 0)
            val hours = widgetData.getString("learning_hours", "0.0")

            val pct = if (topicsTotal > 0) ((topicsDone * 100) / topicsTotal).coerceIn(0, 100) else 0
            val subtitle = if (topicsTotal > 0) {
                "$topicsDone of $topicsTotal topics • ${hours}h studied"
            } else {
                "Tap to add your first learning roadmap"
            }

            views.setTextViewText(R.id.tv_learning_skill, skillName)
            views.setTextViewText(R.id.tv_learning_meta, subtitle)
            views.setProgressBar(R.id.pb_learning_progress, 100, pct, false)

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("action", "open_learning")
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                6,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_learning_container, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

