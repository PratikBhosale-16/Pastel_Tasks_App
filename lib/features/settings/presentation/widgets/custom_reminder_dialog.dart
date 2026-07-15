import 'package:flutter/material.dart';

Future<String?> showCustomReminderDialog(BuildContext context) async {
  int value = 1;
  String unit = 'hours';

  return showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Custom Reminder'),
            content: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: value.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      value = int.tryParse(val) ?? 1;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: unit,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'minutes', child: Text('Minutes')),
                      DropdownMenuItem(value: 'hours', child: Text('Hours')),
                      DropdownMenuItem(value: 'days', child: Text('Days')),
                      DropdownMenuItem(value: 'weeks', child: Text('Weeks')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => unit = val);
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  String finalUnit = unit;
                  if (value == 1 && unit.endsWith('s')) {
                    finalUnit = unit.substring(0, unit.length - 1);
                  } else if (value != 1 && !unit.endsWith('s')) {
                    finalUnit = '${unit}s';
                  }
                  Navigator.of(context).pop('$value $finalUnit before');
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
