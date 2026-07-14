package com.example.pastel_tasks.widget

data class TaskItem(
    val id: String,
    val title: String,
    val priority: Int,
    val dueDate: Long?,
    val hasReminder: Boolean,
    val isRepeat: Boolean,
    val isPinned: Boolean,
    val status: Int,
    val tags: List<String>
)

data class WidgetSettings(
    val showCompleted: Boolean = true,
    val showUpcoming: Boolean = true,
    val showOnlyToday: Boolean = false,
    val showArchived: Boolean = false,
    val maxTaskCount: Int = 5,
    val accentColor: String = "",
    val transparency: Double = 1.0,
    val cornerRadius: Double = 16.0,
    val compactMode: Boolean = false,
    val showGreeting: Boolean = true,
    val showProgress: Boolean = true,
    val autoRefreshInterval: Int = 15
)

data class WidgetState(
    val todaysTasks: List<TaskItem> = emptyList(),
    val upcomingTasks: List<TaskItem> = emptyList(),
    val completedTasks: List<TaskItem> = emptyList(),
    val pinnedTasks: List<TaskItem> = emptyList(),
    val overdueTasks: List<TaskItem> = emptyList(),
    val progressCompleted: Int = 0,
    val progressTotal: Int = 0,
    val countToday: Int = 0,
    val countOverdue: Int = 0,
    val settings: WidgetSettings = WidgetSettings()
)
