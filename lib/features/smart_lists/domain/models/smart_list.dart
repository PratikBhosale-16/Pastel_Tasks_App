import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pastel_tasks/features/filter/domain/models/task_filter.dart';
import 'package:pastel_tasks/features/sorting/domain/enums/sort_option.dart';
import 'package:pastel_tasks/features/sorting/domain/models/sort_preferences.dart';

/// Represents a predefined smart list which is essentially a saved query
/// of a TaskFilter and optional SortPreferences.
class SmartList extends Equatable {
  const SmartList({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.filter,
    this.sortPrefs,
  });

  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final TaskFilter filter;
  final SortPreferences? sortPrefs;

  @override
  List<Object?> get props => [id, title, icon, color, filter, sortPrefs];
}
