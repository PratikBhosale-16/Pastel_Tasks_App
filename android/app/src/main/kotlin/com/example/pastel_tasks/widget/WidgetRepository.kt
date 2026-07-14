package com.example.pastel_tasks.widget

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject

class WidgetRepository(private val context: Context) {
    private val prefs: SharedPreferences by lazy {
        context.getSharedPreferences("es.antonborri.home_widget.preferences", Context.MODE_PRIVATE)
    }

    fun getWidgetState(): WidgetState {
        return WidgetState(
            todaysTasks = parseTasks(prefs.getString("todays_tasks", "[]")),
            upcomingTasks = parseTasks(prefs.getString("upcoming_tasks", "[]")),
            completedTasks = parseTasks(prefs.getString("completed_tasks", "[]")),
            pinnedTasks = parseTasks(prefs.getString("pinned_tasks", "[]")),
            overdueTasks = parseTasks(prefs.getString("overdue_tasks", "[]")),
            progressCompleted = prefs.getInt("progress_completed", 0),
            progressTotal = prefs.getInt("progress_total", 0),
            countToday = prefs.getInt("count_today", 0),
            countOverdue = prefs.getInt("count_overdue", 0),
            settings = parseSettings(prefs.getString("widget_settings", "{}"))
        )
    }

    private fun parseTasks(jsonString: String?): List<TaskItem> {
        if (jsonString.isNullOrEmpty()) return emptyList()
        val list = mutableListOf<TaskItem>()
        try {
            val array = JSONArray(jsonString)
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                val tagsArray = obj.optJSONArray("tags")
                val tags = mutableListOf<String>()
                if (tagsArray != null) {
                    for (j in 0 until tagsArray.length()) {
                        tags.add(tagsArray.getString(j))
                    }
                }
                list.add(
                    TaskItem(
                        id = obj.getString("id"),
                        title = obj.getString("title"),
                        priority = obj.optInt("priority", 0),
                        dueDate = if (obj.has("dueDate") && !obj.isNull("dueDate")) obj.getLong("dueDate") else null,
                        hasReminder = obj.optBoolean("hasReminder", false),
                        isRepeat = obj.optBoolean("isRepeat", false),
                        isPinned = obj.optBoolean("isPinned", false),
                        status = obj.optInt("status", 0),
                        tags = tags
                    )
                )
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return list
    }

    private fun parseSettings(jsonString: String?): WidgetSettings {
        if (jsonString.isNullOrEmpty()) return WidgetSettings()
        try {
            val obj = JSONObject(jsonString)
            return WidgetSettings(
                showCompleted = obj.optBoolean("showCompleted", true),
                showUpcoming = obj.optBoolean("showUpcoming", true),
                showOnlyToday = obj.optBoolean("showOnlyToday", false),
                showArchived = obj.optBoolean("showArchived", false),
                maxTaskCount = obj.optInt("maxTaskCount", 5),
                accentColor = obj.optString("accentColor", ""),
                transparency = obj.optDouble("transparency", 1.0),
                cornerRadius = obj.optDouble("cornerRadius", 16.0),
                compactMode = obj.optBoolean("compactMode", false),
                showGreeting = obj.optBoolean("showGreeting", true),
                showProgress = obj.optBoolean("showProgress", true),
                autoRefreshInterval = obj.optInt("autoRefreshInterval", 15)
            )
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return WidgetSettings()
    }
}
