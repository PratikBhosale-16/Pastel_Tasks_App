package com.example.pastel_tasks.widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import com.example.pastel_tasks.MainActivity

class WidgetActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val dataString = intent.dataString ?: return

        if (dataString.startsWith("pasteltasks://complete") || dataString.startsWith("pasteltasks://refresh")) {
            // Forward to Background Handler (Dart)
            val bgIntent = HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse(dataString))
            bgIntent.send()
        } else if (dataString.startsWith("pasteltasks://task")) {
            // Launch App via PendingIntent
            try {
                val launchIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(dataString))
                launchIntent.send()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
