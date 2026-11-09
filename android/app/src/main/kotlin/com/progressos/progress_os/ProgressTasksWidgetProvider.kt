package com.progressos.progress_os

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ProgressTasksWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_tasks)
            val widgetData = HomeWidgetPlugin.getData(context)

            // Task 1
            val t1Title = widgetData.getString("task_1_title", "")
            if (!t1Title.isNullOrEmpty()) {
                views.setViewVisibility(R.id.ll_task_item_1, View.VISIBLE)
                views.setTextViewText(R.id.tv_task_1_title, t1Title)
                views.setTextViewText(R.id.tv_task_1_priority, widgetData.getString("task_1_priority", "MED"))
                views.setTextViewText(R.id.tv_task_1_time, widgetData.getString("task_1_time", ""))
            } else {
                views.setViewVisibility(R.id.ll_task_item_1, View.GONE)
            }

            // Task 2
            val t2Title = widgetData.getString("task_2_title", "")
            if (!t2Title.isNullOrEmpty()) {
                views.setViewVisibility(R.id.ll_task_item_2, View.VISIBLE)
                views.setTextViewText(R.id.tv_task_2_title, t2Title)
                views.setTextViewText(R.id.tv_task_2_priority, widgetData.getString("task_2_priority", "MED"))
                views.setTextViewText(R.id.tv_task_2_time, widgetData.getString("task_2_time", ""))
            } else {
                views.setViewVisibility(R.id.ll_task_item_2, View.GONE)
            }

            // Task 3
            val t3Title = widgetData.getString("task_3_title", "")
            if (!t3Title.isNullOrEmpty()) {
                views.setViewVisibility(R.id.ll_task_item_3, View.VISIBLE)
                views.setTextViewText(R.id.tv_task_3_title, t3Title)
                views.setTextViewText(R.id.tv_task_3_priority, widgetData.getString("task_3_priority", "LOW"))
                views.setTextViewText(R.id.tv_task_3_time, widgetData.getString("task_3_time", ""))
            } else {
                views.setViewVisibility(R.id.ll_task_item_3, View.GONE)
            }

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                1,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_tasks_container, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
