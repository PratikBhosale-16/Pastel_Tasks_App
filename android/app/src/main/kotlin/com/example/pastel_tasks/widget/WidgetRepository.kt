package com.example.pastel_tasks.widget

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONException

object WidgetRepository {

    private fun getPrefs(context: Context): SharedPreferences {
        // home_widget uses "HomeWidgetPreferences" by default
        return context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
    }

    fun getWidgetState(context: Context): WidgetState {
        val prefs = getPrefs(context)
        
        val greeting = prefs.getString("widget_greeting", "Hello") ?: "Hello"
        val date = prefs.getString("widget_date", "") ?: ""
        val progressPercent = prefs.getInt("widget_progress_percent", 0)
        val completedCount = prefs.getInt("widget_completed_count", 0)
        val totalCount = prefs.getInt("widget_total_count", 0)
        val showCompleted = prefs.getBoolean("widget_show_completed", true)
        val accentColor = if (prefs.contains("widget_accent_color")) prefs.getLong("widget_accent_color", 0L) else null
        
        val tasksJson = prefs.getString("widget_tasks", "[]") ?: "[]"
        val tasks = mutableListOf<WidgetTask>()
        
        try {
            val jsonArray = JSONArray(tasksJson)
            for (i in 0 until jsonArray.length()) {
                val obj = jsonArray.getJSONObject(i)
                tasks.add(
                    WidgetTask(
                        id = obj.optString("id"),
                        title = obj.optString("title"),
                        isCompleted = obj.optBoolean("isCompleted", false),
                        dueTime = if (obj.has("dueTime") && !obj.isNull("dueTime")) obj.getString("dueTime") else null,
                        priority = obj.optInt("priority", 0),
                        tag = if (obj.has("tag") && !obj.isNull("tag")) obj.getString("tag") else null,
                        hasReminder = obj.optBoolean("hasReminder", false),
                        isPinned = obj.optBoolean("isPinned", false),
                        isRepeat = obj.optBoolean("isRepeat", false),
                        group = obj.optString("group", "Tasks")
                    )
                )
            }
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        
        return WidgetState(
            greeting = greeting,
            date = date,
            progressPercent = progressPercent,
            completedCount = completedCount,
            totalCount = totalCount,
            tasks = tasks,
            showCompleted = showCompleted,
            accentColor = accentColor
        )
    }
}
