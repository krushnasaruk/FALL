package com.progressos.progress_os

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ProgressProjectWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_project)
            val widgetData = HomeWidgetPlugin.getData(context)

            val name = widgetData.getString("project_name", "No Active Project")
            val progress = widgetData.getInt("project_progress", 0)
            val milestone = widgetData.getString("next_milestone", "No Pending Milestones")

            views.setTextViewText(R.id.tv_project_name, name)
            views.setProgressBar(R.id.pb_project_progress, 100, progress, false)
            views.setTextViewText(R.id.tv_next_milestone, "Next: $milestone")

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                3,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_project_container, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
