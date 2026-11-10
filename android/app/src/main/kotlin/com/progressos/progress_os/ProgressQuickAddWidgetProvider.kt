package com.progressos.progress_os

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class ProgressQuickAddWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_quick_add)

            views.setOnClickPendingIntent(
                R.id.btn_quick_task,
                buildActionIntent(context, "new_task", 50)
            )
            views.setOnClickPendingIntent(
                R.id.btn_quick_note,
                buildActionIntent(context, "new_note", 51)
            )
            views.setOnClickPendingIntent(
                R.id.btn_quick_focus,
                buildActionIntent(context, "open_focus", 52)
            )
            views.setOnClickPendingIntent(
                R.id.btn_quick_learn,
                buildActionIntent(context, "open_learning", 53)
            )

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun buildActionIntent(context: Context, action: String, reqCode: Int): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("action", action)
        }
        return PendingIntent.getActivity(
            context,
            reqCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
