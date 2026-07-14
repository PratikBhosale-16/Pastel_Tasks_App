package com.example.pastel_tasks.widget

import java.util.Calendar
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

object WidgetUtils {
    fun getGreeting(): String {
        val hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
        return when (hour) {
            in 0..11 -> "Good Morning"
            in 12..16 -> "Good Afternoon"
            in 17..20 -> "Good Evening"
            else -> "Good Night"
        }
    }

    fun getCurrentDateFormatted(): String {
        val sdf = SimpleDateFormat("EEEE, MMM d", Locale.getDefault())
        return sdf.format(Date())
    }

    fun formatDueDate(timestamp: Long?): String {
        if (timestamp == null) return ""
        val sdf = SimpleDateFormat("MMM d", Locale.getDefault())
        return sdf.format(Date(timestamp))
    }
}
