package com.example.pastel_tasks.widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.SizeF
import android.view.View
import android.widget.RemoteViews
import com.example.pastel_tasks.R
import java.util.Locale

class WidgetRenderer(private val context: Context) {

    fun render(appWidgetId: Int, state: WidgetState): RemoteViews {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val viewMapping: Map<SizeF, RemoteViews> = mapOf(
                SizeF(70f, 70f) to buildExtraSmallView(state, appWidgetId),
                SizeF(130f, 70f) to buildSmallView(state, appWidgetId),
                SizeF(130f, 130f) to buildMediumView(state, appWidgetId),
                SizeF(200f, 130f) to buildLargeView(state, appWidgetId),
                SizeF(270f, 200f) to buildExtraLargeView(state, appWidgetId)
            )
            return RemoteViews(viewMapping)
        } else {
            // Fallback for older Android versions (using Large as default)
            return buildExtraLargeView(state, appWidgetId)
        }
    }

    private fun buildExtraSmallView(state: WidgetState, widgetId: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_1x1)
        bindProgress(views, state, true)
        bindRootAction(views)
        return views
    }

    private fun buildSmallView(state: WidgetState, widgetId: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_2x1)
        bindProgress(views, state, false)
        bindActionButtons(views, state, isSmall = true)
        bindRootAction(views)
        return views
    }

    private fun buildMediumView(state: WidgetState, widgetId: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_2x2)
        bindActionButtons(views, state, isSmall = false)
        bindList(views, widgetId, R.layout.widget_2x2)
        bindRootAction(views)
        return views
    }

    private fun buildLargeView(state: WidgetState, widgetId: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_3x2)
        bindHeader(views, state)
        bindProgress(views, state, false)
        bindActionButtons(views, state, isSmall = false)
        bindList(views, widgetId, R.layout.widget_3x2)
        bindRootAction(views)
        return views
    }

    private fun buildExtraLargeView(state: WidgetState, widgetId: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_4x4)
        bindHeader(views, state)
        bindProgress(views, state, false)
        bindActionButtons(views, state, isSmall = false)
        bindList(views, widgetId, R.layout.widget_4x4)
        bindRootAction(views)
        return views
    }

    private fun bindRootAction(views: RemoteViews) {
        val appIntent = WidgetActions.getAddIntent(context) // or simply launch app
        views.setOnClickPendingIntent(R.id.widget_root, appIntent)
    }

    private fun bindHeader(views: RemoteViews, state: WidgetState) {
        if (state.settings.showGreeting) {
            views.setViewVisibility(R.id.header_greeting_container, View.VISIBLE)
            views.setTextViewText(R.id.widget_greeting, WidgetUtils.getGreeting())
            views.setTextViewText(R.id.widget_date, WidgetUtils.getCurrentDateFormatted())
        } else {
            views.setViewVisibility(R.id.header_greeting_container, View.GONE)
        }
    }

    private fun bindProgress(views: RemoteViews, state: WidgetState, isExtraSmall: Boolean) {
        if (state.settings.showProgress) {
            views.setViewVisibility(R.id.header_progress_container, View.VISIBLE)
            val progress = if (state.progressTotal > 0) (state.progressCompleted.toFloat() / state.progressTotal * 100).toInt() else 0
            views.setProgressBar(R.id.progress_bar, 100, progress, false)
            views.setTextViewText(R.id.progress_text, "$progress%")
            
            if (isExtraSmall) {
                views.setTextViewText(R.id.progress_subtitle, "${state.progressCompleted} / ${state.progressTotal}")
            }
        } else {
            views.setViewVisibility(R.id.header_progress_container, View.GONE)
        }
    }

    private fun bindActionButtons(views: RemoteViews, state: WidgetState, isSmall: Boolean) {
        views.setOnClickPendingIntent(R.id.btn_add, WidgetActions.getAddIntent(context))
        views.setOnClickPendingIntent(R.id.btn_refresh, WidgetActions.getRefreshIntent(context))
        
        if (!isSmall) {
            views.setOnClickPendingIntent(R.id.btn_settings, WidgetActions.getSettingsIntent(context))
        }
    }

    private fun bindList(views: RemoteViews, widgetId: Int, layoutId: Int) {
        val intent = Intent(context, WidgetRemoteViewsService::class.java)
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
        intent.putExtra("layoutId", layoutId)
        intent.data = Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME))
        
        views.setRemoteAdapter(R.id.widget_task_list, intent)
        views.setEmptyView(R.id.widget_task_list, R.id.widget_empty_text)
        
        val clickIntentTemplate = WidgetActions.getCompleteTaskIntentTemplate(context)
        views.setPendingIntentTemplate(R.id.widget_task_list, clickIntentTemplate)
    }
}
