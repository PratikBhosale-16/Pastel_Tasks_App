package com.example.pastel_tasks

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.os.Bundle
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import org.json.JSONArray
import android.view.View
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetPlugin
import kotlin.math.max
import kotlin.math.min

class ResponsiveWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val options = appWidgetManager.getAppWidgetOptions(widgetId)
            updateAppWidgetResponsive(context, appWidgetManager, widgetId, options, widgetData)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        
        // home_widget stores data using standard shared preferences in Flutter, which maps to:
        // By default on Android it uses context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        // Wait, HomeWidgetPlugin provides a helper `getData` but we can just use SharedPreferences.
        val widgetData = context.getSharedPreferences("es.antonborri.home_widget.preferences", Context.MODE_PRIVATE)
        
        updateAppWidgetResponsive(context, appWidgetManager, appWidgetId, newOptions, widgetData)
    }

    private fun updateAppWidgetResponsive(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int,
        options: Bundle,
        widgetData: SharedPreferences
    ) {
        // Calculate size bucket. Standard formula: n * 70 - 30
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val maxHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT)

        val columns = getCellsForSize(minWidth)
        val rows = getCellsForSize(maxHeight)

        val layoutId = when {
            columns <= 1 && rows <= 1 -> R.layout.widget_1x1
            columns >= 3 && rows >= 3 -> R.layout.widget_4x3
            columns >= 3 && rows == 2 -> R.layout.widget_3x2
            columns >= 2 && rows >= 2 -> R.layout.widget_2x2
            columns >= 2 && rows <= 1 -> R.layout.widget_2x1
            else -> R.layout.widget_2x2 // fallback
        }

        val views = RemoteViews(context.packageName, layoutId)

        // Common Actions
        val appIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        views.setOnClickPendingIntent(R.id.widget_root, appIntent)
        
        try { views.setOnClickPendingIntent(R.id.btn_add, HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("pasteltasks://add"))) } catch (e: Exception) {}
        try { views.setOnClickPendingIntent(R.id.btn_refresh, HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("pasteltasks://refresh"))) } catch (e: Exception) {}
        try { views.setOnClickPendingIntent(R.id.btn_settings, HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("pasteltasks://settings"))) } catch (e: Exception) {}

        // Progress Data
        val completed = widgetData.getInt("progress_completed", 0)
        val total = widgetData.getInt("progress_total", 0)
        val progress = if (total > 0) (completed.toFloat() / total * 100).toInt() else 0
        try {
            views.setProgressBar(R.id.progress_bar, 100, progress, false)
            views.setTextViewText(R.id.progress_text, "$progress%")
        } catch (e: Exception) {}

        // Date String (For larger widgets)
        try {
            val sdf = java.text.SimpleDateFormat("EEEE, MMM d", java.util.Locale.getDefault())
            views.setTextViewText(R.id.date_text, sdf.format(java.util.Date()))
        } catch (e: Exception) {}

        // Tasks List (For widgets that support list)
        val tasksJsonString = widgetData.getString("todays_tasks", "[]")
        try {
            val tasksJson = JSONArray(tasksJsonString)
            val textViews = listOf(R.id.task_1, R.id.task_2, R.id.task_3)
            val checkboxes = listOf(R.id.check_1, R.id.check_2, R.id.check_3)
            val containers = listOf(R.id.container_1, R.id.container_2, R.id.container_3)
            
            if (tasksJson.length() == 0) {
                try { views.setViewVisibility(R.id.empty_text, View.VISIBLE) } catch (e: Exception) {}
                for (c in containers) {
                    try { views.setViewVisibility(c, View.GONE) } catch (e: Exception) {}
                }
            } else {
                try { views.setViewVisibility(R.id.empty_text, View.GONE) } catch (e: Exception) {}
                for (i in 0..2) {
                    if (i < tasksJson.length()) {
                        val task = tasksJson.getJSONObject(i)
                        val taskId = task.getString("id")
                        
                        try {
                            views.setTextViewText(textViews[i], task.getString("title"))
                            views.setViewVisibility(containers[i], View.VISIBLE)
                            
                            val checkIntent = es.antonborri.home_widget.HomeWidgetBackgroundIntent.getBroadcast(
                                context,
                                Uri.parse("pasteltasks://complete/$taskId")
                            )
                            views.setOnClickPendingIntent(checkboxes[i], checkIntent)
                        } catch (e: Exception) {}
                    } else {
                        try { views.setViewVisibility(containers[i], View.GONE) } catch (e: Exception) {}
                    }
                }
            }
        } catch (e: Exception) {}

        appWidgetManager.updateAppWidget(widgetId, views)
    }

    private fun getCellsForSize(size: Int): Int {
        var n = 2
        while (70 * n - 30 < size) {
            ++n
        }
        return n - 1
    }
}
