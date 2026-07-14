package com.example.pastel_tasks.widget

import android.appwidget.AppWidgetManager
import android.content.Context

class WidgetUpdater(private val context: Context) {
    private val repository = WidgetRepository(context)
    private val renderer = WidgetRenderer(context)

    fun updateAllWidgets(appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        val state = repository.getWidgetState()
        
        for (widgetId in appWidgetIds) {
            val views = renderer.render(widgetId, state)
            
            // Notify list view adapter to refresh its data
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, com.example.pastel_tasks.R.id.widget_task_list)
            
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
