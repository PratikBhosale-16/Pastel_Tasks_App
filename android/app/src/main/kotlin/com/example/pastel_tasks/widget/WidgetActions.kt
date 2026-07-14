package com.example.pastel_tasks.widget

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import com.example.pastel_tasks.MainActivity

object WidgetActions {
    const val ACTION_COMPLETE_TASK = "pasteltasks://complete"
    const val ACTION_REFRESH = "pasteltasks://refresh"
    const val ACTION_ADD = "pasteltasks://add"
    const val ACTION_SETTINGS = "pasteltasks://settings"

    fun getAddIntent(context: Context): PendingIntent {
        return HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(ACTION_ADD))
    }

    fun getSettingsIntent(context: Context): PendingIntent {
        return HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(ACTION_SETTINGS))
    }

    fun getRefreshIntent(context: Context): PendingIntent {
        return HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse(ACTION_REFRESH))
    }

    fun getCompleteTaskIntentTemplate(context: Context): PendingIntent {
        val intent = Intent(context, com.example.pastel_tasks.widget.WidgetActionReceiver::class.java)
        return PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
    }
}
