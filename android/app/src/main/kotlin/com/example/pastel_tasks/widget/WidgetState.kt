package com.example.pastel_tasks.widget

data class WidgetTask(
    val id: String,
    val title: String,
    val isCompleted: Boolean,
    val dueTime: String?,
    val priority: Int,
    val tag: String?,
    val hasReminder: Boolean,
    val isPinned: Boolean,
    val isRepeat: Boolean,
    val group: String
)

data class WidgetState(
    val greeting: String,
    val date: String,
    val progressPercent: Int,
    val completedCount: Int,
    val totalCount: Int,
    val tasks: List<WidgetTask>,
    val showCompleted: Boolean,
    val accentColor: Long?
)
