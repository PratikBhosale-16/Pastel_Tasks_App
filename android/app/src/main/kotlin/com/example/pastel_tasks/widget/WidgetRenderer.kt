package com.example.pastel_tasks.widget

import android.content.Context
import com.example.pastel_tasks.R
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.LocalSize
import androidx.glance.action.ActionParameters
import androidx.glance.action.clickable
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.appWidgetBackground
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.lazy.LazyColumn
import androidx.glance.appwidget.lazy.items
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider

class PastelTasksWidget : GlanceAppWidget() {
    
    override val sizeMode = SizeMode.Exact

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val state = WidgetRepository.getWidgetState(context)
        
        provideContent {
            GlanceTheme {
                val size = LocalSize.current
                WidgetContent(size, state)
            }
        }
    }

    @Composable
    private fun WidgetContent(size: DpSize, state: WidgetState) {
        val width = size.width
        val height = size.height
        
        // Use custom accent color if provided, else Material You primary
        val primaryColor = if (state.accentColor != null) {
            ColorProvider(androidx.compose.ui.graphics.Color(state.accentColor.toInt()))
        } else {
            GlanceTheme.colors.primary
        }

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .appWidgetBackground()
                .cornerRadius(16.dp)
                .background(GlanceTheme.colors.surface)
        ) {
            when {
                // 1x1
                width < 110.dp && height < 110.dp -> ExtraSmallLayout(state, primaryColor)
                // 4x1 (Count Down)
                width >= 110.dp && height < 110.dp -> SmallLayout(state, primaryColor)
                // 2x2 (Compact)
                width < 250.dp && height >= 110.dp -> MediumLayout(state, primaryColor)
                // 4x3+ (Normal / Standard)
                else -> LargeLayout(state, primaryColor)
            }
        }
    }

    @Composable
    private fun ExtraSmallLayout(state: WidgetState, primaryColor: ColorProvider) {
        Column(
            modifier = GlanceModifier.fillMaxSize().padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "${state.progressPercent}%",
                style = TextStyle(color = primaryColor, fontSize = 24.sp, fontWeight = FontWeight.Bold)
            )
        }
    }

    @Composable
    private fun SmallLayout(state: WidgetState, primaryColor: ColorProvider) {
        val topTask = state.tasks.firstOrNull { !it.isCompleted } ?: state.tasks.firstOrNull()
        Row(
            modifier = GlanceModifier.fillMaxSize().padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            if (topTask != null) {
                Column(modifier = GlanceModifier.defaultWeight()) {
                    Text("Next Task", style = TextStyle(color = primaryColor, fontSize = 12.sp, fontWeight = FontWeight.Medium))
                    Text(topTask.title, style = TextStyle(color = GlanceTheme.colors.onSurface, fontSize = 16.sp, fontWeight = FontWeight.Bold), maxLines = 1)
                }
                if (topTask.dueTime != null) {
                    val dateStr = topTask.dueTime.take(10)
                    Text(
                        text = dateStr,
                        style = TextStyle(color = GlanceTheme.colors.onSurfaceVariant, fontSize = 14.sp)
                    )
                }
            } else {
                Text("No upcoming tasks", style = TextStyle(color = GlanceTheme.colors.onSurfaceVariant, fontSize = 14.sp))
            }
        }
    }

    @Composable
    private fun WidgetHeader(title: String, primaryColor: ColorProvider) {
        Row(
            modifier = GlanceModifier.fillMaxWidth().background(primaryColor).padding(horizontal = 16.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = title, 
                style = TextStyle(color = ColorProvider(androidx.compose.ui.graphics.Color.White), fontSize = 16.sp, fontWeight = FontWeight.Bold), 
                modifier = GlanceModifier.defaultWeight()
            )
            Image(
                provider = ImageProvider(R.drawable.ic_add_rounded),
                contentDescription = "Add Task",
                modifier = GlanceModifier.size(26.dp).cornerRadius(13.dp).clickable(actionRunCallback<CreateTaskAction>()),
                colorFilter = androidx.glance.ColorFilter.tint(ColorProvider(androidx.compose.ui.graphics.Color.White))
            )
            Spacer(modifier = GlanceModifier.width(16.dp))
            Image(
                provider = ImageProvider(R.drawable.ic_cached_rounded),
                contentDescription = "Refresh",
                modifier = GlanceModifier.size(22.dp).cornerRadius(11.dp).clickable(actionRunCallback<RefreshAction>()),
                colorFilter = androidx.glance.ColorFilter.tint(ColorProvider(androidx.compose.ui.graphics.Color.White))
            )
            Spacer(modifier = GlanceModifier.width(16.dp))
            Image(
                provider = ImageProvider(R.drawable.ic_settings_rounded),
                contentDescription = "Settings",
                modifier = GlanceModifier.size(22.dp).cornerRadius(11.dp).clickable(actionRunCallback<OpenSettingsAction>()),
                colorFilter = androidx.glance.ColorFilter.tint(ColorProvider(androidx.compose.ui.graphics.Color.White))
            )
        }
    }

    @Composable
    private fun MediumLayout(state: WidgetState, primaryColor: ColorProvider) {
        Column(modifier = GlanceModifier.fillMaxSize()) {
            WidgetHeader("All Tasks", primaryColor)
            LazyColumn(modifier = GlanceModifier.defaultWeight().padding(12.dp)) {
                val todayTasks = state.tasks.filter { it.group != "Completed" }
                val completedTasks = state.tasks.filter { it.group == "Completed" }
                
                if (todayTasks.isNotEmpty()) {
                    item { 
                        Text("Today", style = TextStyle(color = primaryColor, fontSize = 14.sp, fontWeight = FontWeight.Bold), modifier = GlanceModifier.padding(vertical = 8.dp)) 
                    }
                    items(todayTasks) { task -> 
                        TaskItem(task, primaryColor, showDetails = false) 
                    }
                }
                
                if (completedTasks.isNotEmpty()) {
                    item { 
                        Text("Completed", style = TextStyle(color = GlanceTheme.colors.onSurfaceVariant, fontSize = 14.sp, fontWeight = FontWeight.Bold), modifier = GlanceModifier.padding(vertical = 8.dp)) 
                    }
                    items(completedTasks) { task -> 
                        TaskItem(task, primaryColor, showDetails = false) 
                    }
                }

                if (state.tasks.isEmpty()) {
                    item { Text("No tasks", style = TextStyle(color = GlanceTheme.colors.onSurfaceVariant)) }
                }
            }
        }
    }

    @Composable
    private fun LargeLayout(state: WidgetState, primaryColor: ColorProvider) {
        Column(modifier = GlanceModifier.fillMaxSize()) {
            WidgetHeader("All Tasks", primaryColor)
            LazyColumn(modifier = GlanceModifier.defaultWeight().padding(12.dp)) {
                val todayTasks = state.tasks.filter { it.group != "Completed" }
                val completedTasks = state.tasks.filter { it.group == "Completed" }
                
                if (todayTasks.isNotEmpty()) {
                    item { 
                        Text("Today", style = TextStyle(color = primaryColor, fontSize = 14.sp, fontWeight = FontWeight.Bold), modifier = GlanceModifier.padding(vertical = 8.dp)) 
                    }
                    items(todayTasks) { task -> 
                        TaskItem(task, primaryColor, showDetails = true) 
                    }
                }
                
                if (completedTasks.isNotEmpty()) {
                    item { 
                        Text("Completed", style = TextStyle(color = GlanceTheme.colors.onSurfaceVariant, fontSize = 14.sp, fontWeight = FontWeight.Bold), modifier = GlanceModifier.padding(vertical = 8.dp)) 
                    }
                    items(completedTasks) { task -> 
                        TaskItem(task, primaryColor, showDetails = true) 
                    }
                }

                if (state.tasks.isEmpty()) {
                    item { Text("No tasks", style = TextStyle(color = GlanceTheme.colors.onSurfaceVariant)) }
                }
            }
        }
    }

    @Composable
    private fun TaskItem(task: WidgetTask, primaryColor: ColorProvider, showDetails: Boolean) {
        Row(
            modifier = GlanceModifier
                .fillMaxWidth()
                .padding(vertical = 6.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            val symbol = if (task.isCompleted) "☑" else "○"
            val checkColor = if (task.isCompleted) GlanceTheme.colors.onSurfaceVariant else primaryColor
            Text(
                text = symbol,
                style = TextStyle(color = checkColor, fontSize = 20.sp),
                modifier = GlanceModifier.cornerRadius(12.dp).clickable(actionRunCallback<ToggleTaskAction>())
            )
            Spacer(modifier = GlanceModifier.width(12.dp))
            Column(modifier = GlanceModifier.defaultWeight()) {
                val textStyle = if (task.isCompleted) {
                    TextStyle(color = GlanceTheme.colors.onSurfaceVariant, fontSize = 14.sp, fontWeight = FontWeight.Normal)
                } else {
                    TextStyle(color = GlanceTheme.colors.onSurface, fontSize = 14.sp, fontWeight = FontWeight.Medium)
                }
                Text(text = task.title, style = textStyle, maxLines = 1)
                
                if (showDetails && task.dueTime != null && !task.isCompleted) {
                    val dateStr = task.dueTime.take(10)
                    Text(text = dateStr, style = TextStyle(color = primaryColor, fontSize = 12.sp))
                }
            }
        }
    }
}
