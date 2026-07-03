import 'package:equatable/equatable.dart';
import 'package:pastel_tasks/features/settings/domain/models/settings_item.dart';

class SettingsSection extends Equatable {
  final String id;
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({
    required this.id,
    required this.title,
    required this.items,
  });

  @override
  List<Object?> get props => [id, title, items];
}
