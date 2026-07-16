import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pastel_tasks/app/providers/date_time_format_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pastel_tasks/features/backup/domain/enums/backup_type.dart';
import 'package:pastel_tasks/features/backup/presentation/providers/backup_providers.dart';
import 'package:pastel_tasks/shared/layout/app_scaffold.dart';
import 'package:pastel_tasks/shared/layout/app_app_bar.dart';
import 'package:pastel_tasks/shared/widgets/buttons/primary_button.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  BackupType _selectedType = BackupType.local;
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backupState = ref.watch(backupServiceStateProvider);
    final backups = ref.watch(availableBackupsProvider(_selectedType));
    final formatter = ref.watch(dateTimeFormatterProvider);

    ref.listen<AsyncValue<void>>(backupServiceStateProvider, (previous, next) {
      next.whenOrNull(
        error: (err, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err'), backgroundColor: theme.colorScheme.error),
          );
        },
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Success!')),
            );
            ref.invalidate(availableBackupsProvider(_selectedType));
          }
        },
      );
    });

    return AppScaffold(
      appBar: const AppAppBar(title: 'Backup & Restore'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<BackupType>(
                    segments: const [
                      ButtonSegment(value: BackupType.local, label: Text('Local')),
                      ButtonSegment(value: BackupType.googleDrive, label: Text('Google Drive')),
                    ],
                    selected: {_selectedType},
                    onSelectionChanged: (set) {
                      setState(() {
                        _selectedType = set.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedType == BackupType.googleDrive) ...[
                    // Google Drive Sign-In state could be handled here or inside the provider automatically
                    Text('Backups will be securely stored in your hidden Google Drive AppData folder.', style: theme.textTheme.bodySmall),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedType == BackupType.local) ...[
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Backup Password (Optional for Local)',
                        border: OutlineInputBorder(),
                        helperText: 'Required to encrypt backup.',
                      ),
                      obscureText: true,
                      onChanged: (val) => _password = val,
                    ),
                    const SizedBox(height: 16),
                  ],
                  PrimaryButton(
                    label: 'Create Backup',
                    onPressed: backupState.isLoading
                        ? null
                        : () {
                            ref.read(backupServiceStateProvider.notifier).createBackup(
                                  type: _selectedType,
                                  password: _password,
                                );
                          },
                    isLoading: backupState.isLoading,
                  ),
                  const SizedBox(height: 16),
                  if (_selectedType == BackupType.local) ...[
                    OutlinedButton.icon(
                      onPressed: backupState.isLoading ? null : _importBackup,
                      icon: const Icon(Icons.file_upload),
                      label: const Text('Import Backup File'),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    'Backup History',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          backups.when(
            data: (list) {
              if (list.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text('No backups found.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final backup = list[index];
                    final date = formatter.formatDateTime(backup['date'] as DateTime);
                    final size = (backup['size'] as int) / 1024;
                    final isEncrypted = backup['isEncrypted'] as bool;
                    
                    return ListTile(
                      title: Text(backup['name']),
                      subtitle: Text('$date • ${size.toStringAsFixed(1)} KB${isEncrypted ? ' • Encrypted' : ''}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) {
                          if (action == 'restore') {
                            _showRestoreDialog(backup['reference'], isEncrypted);
                          } else if (action == 'share') {
                            Share.shareXFiles([XFile(backup['reference'])], text: 'PastelTasks Backup');
                          } else if (action == 'delete') {
                            ref.read(backupServiceStateProvider.notifier).deleteBackup(backup['reference'], type: _selectedType);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'restore', child: Text('Restore')),
                          if (_selectedType == BackupType.local)
                            const PopupMenuItem(value: 'share', child: Text('Share / Export')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                  childCount: list.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => SliverToBoxAdapter(child: Center(child: Text('Failed to load backups'))),
          ),
        ],
      ),
    );
  }

  Future<void> _importBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final isEncrypted = path.endsWith('.enc.json') || path.endsWith('.enc');
      _showRestoreDialog(path, isEncrypted);
    }
  }

  void _showRestoreDialog(String reference, bool isEncrypted) {
    String restorePassword = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Do you want to merge this backup with your existing data, or replace everything?'),
            const SizedBox(height: 16),
            if (isEncrypted)
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (val) => restorePassword = val,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(backupServiceStateProvider.notifier).restoreBackup(
                    reference,
                    type: _selectedType,
                    password: restorePassword,
                    merge: true,
                  );
            },
            child: const Text('Merge'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(backupServiceStateProvider.notifier).restoreBackup(
                    reference,
                    type: _selectedType,
                    password: restorePassword,
                    merge: false,
                  );
            },
            child: const Text('Replace', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
