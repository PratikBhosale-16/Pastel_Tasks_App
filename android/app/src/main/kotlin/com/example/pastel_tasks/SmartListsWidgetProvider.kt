package com.example.pastel_tasks

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class SmartListsWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_smart_lists)
            
            // Set up a default intent to launch the app
            val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                context, 
                MainActivity::class.java
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            
            // Add custom logic based on widgetData here
            
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
