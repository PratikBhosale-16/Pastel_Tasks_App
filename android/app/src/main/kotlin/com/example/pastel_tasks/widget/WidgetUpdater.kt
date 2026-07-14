package com.example.pastel_tasks.widget

import android.content.Context
import androidx.glance.appwidget.updateAll
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

object WidgetUpdater {
    fun updateAllWidgets(context: Context) {
        CoroutineScope(Dispatchers.IO).launch {
            PastelTasksWidget().updateAll(context)
        }
    }
}
