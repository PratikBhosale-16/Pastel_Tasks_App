package com.example.pastel_tasks.widget

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.example.pastel_tasks.R

class WidgetRemoteViewsService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        val layoutId = intent.getIntExtra("layoutId", -1)
        return WidgetRemoteViewsFactory(this.applicationContext, layoutId)
    }
}

class WidgetRemoteViewsFactory(private val context: Context, private val layoutId: Int) : RemoteViewsService.RemoteViewsFactory {

    private var state: WidgetState = WidgetState()

    override fun onCreate() {
        // Initial setup
    }

    override fun onDataSetChanged() {
        // Triggered when appWidgetManager.notifyAppWidgetViewDataChanged is called
        val repository = WidgetRepository(context)
        state = repository.getWidgetState()
    }

    override fun onDestroy() {
    }

    override fun getCount(): Int {
        val tasks = getTasksForLayout()
        val maxItems = state.settings.maxTaskCount
        return minOf(tasks.size, maxItems)
    }

    private fun getTasksForLayout(): List<TaskItem> {
        // Here we could return different lists based on layout or settings.
        // For simplicity, we just combine what settings dictate.
        val list = mutableListOf<TaskItem>()
        if (state.settings.showOnlyToday) {
            list.addAll(state.todaysTasks)
        } else {
            if (state.settings.showUpcoming) list.addAll(state.upcomingTasks)
            else list.addAll(state.todaysTasks)
        }
        if (state.settings.showCompleted) {
            list.addAll(state.completedTasks)
        }
        return list.distinctBy { it.id }
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_task_item)
        val tasks = getTasksForLayout()
        
        try {
            if (position < tasks.size) {
                val task = tasks[position]
                
                // Set Title
                views.setTextViewText(R.id.task_title, task.title)
                
                // The main row action: Edit Task
                val rowFillInIntent = Intent().apply {
                    data = Uri.parse("pasteltasks://task/${task.id}")
                }
                views.setOnClickFillInIntent(R.id.task_title, rowFillInIntent)
                
                // The checkbox action: Complete Task in background
                val checkFillInIntent = Intent().apply {
                    data = Uri.parse("pasteltasks://complete/${task.id}")
                }
                views.setOnClickFillInIntent(R.id.task_checkbox, checkFillInIntent)
                
                // Bind Tags, Priority, Reminder depending on what we have in TaskItem
                if (task.tags.isNotEmpty()) {
                    views.setTextViewText(R.id.task_tag, task.tags.first())
                    views.setViewVisibility(R.id.task_tag, View.VISIBLE)
                } else {
                    views.setViewVisibility(R.id.task_tag, View.GONE)
                }

                if (task.hasReminder) {
                    views.setViewVisibility(R.id.task_reminder, View.VISIBLE)
                } else {
                    views.setViewVisibility(R.id.task_reminder, View.GONE)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return views
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return false
    }
}
