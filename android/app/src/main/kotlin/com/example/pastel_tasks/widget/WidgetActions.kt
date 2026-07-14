package com.example.pastel_tasks.widget

import android.content.Context
import android.net.Uri
import androidx.glance.GlanceId
import androidx.glance.action.ActionParameters
import androidx.glance.appwidget.action.ActionCallback
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class RefreshAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        // Trigger background sync in Flutter
        val intent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("pasteltasks://widget/refresh")
        )
        intent.send()
    }
}

class ToggleTaskAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        // In a real implementation, we would pass the task ID in parameters
        // and send it via URI
        val intent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("pasteltasks://widget/toggle")
        )
        intent.send()
    }
}

class CreateTaskAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val intent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("pasteltasks://widget/create")
        )
        intent.send()
    }
}

class OpenSettingsAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val intent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("pasteltasks://widget/settings")
        )
        intent.send()
    }
}
