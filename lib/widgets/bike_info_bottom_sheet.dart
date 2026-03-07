import 'package:bikesetupapp/bike_enums/bike_type.dart';
import 'package:bikesetupapp/bike_enums/new_bike_mode.dart';
import 'package:bikesetupapp/database_service/database.dart';
import 'package:bikesetupapp/widgets/new_bike_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> showBikeInfoSheet(
  BuildContext context,
  User user,
  String uBikeID,
  String uSetupID,
  String setupName,
  String bikeName,
  BikeType bikeType,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _BikeInfoSheetContent(
      user: user,
      uBikeID: uBikeID,
      uSetupID: uSetupID,
      setupName: setupName,
      bikeName: bikeName,
      bikeType: bikeType,
    ),
  );
}

class _BikeInfoSheetContent extends StatelessWidget {
  final User user;
  final String uBikeID;
  final String uSetupID;
  final String setupName;
  final String bikeName;
  final BikeType bikeType;

  const _BikeInfoSheetContent({
    required this.user,
    required this.uBikeID,
    required this.uSetupID,
    required this.setupName,
    required this.bikeName,
    required this.bikeType,
  });

  List<(String, String)> _buildRows(Map<String, dynamic> data) {
    return [
      if (bikeType.hasFork) ('Fork Type', data['fork']?.toString() ?? '—'),
      if (bikeType.hasShock) ('Shock Type', data['shock']?.toString() ?? '—'),
      if (bikeType.hasFork)
        ('Front Travel', '${data['front_travel']?.toString() ?? '—'} mm'),
      if (bikeType.hasShock)
        ('Rear Travel', '${data['rear_travel']?.toString() ?? '—'} mm'),
      ('Front Wheel Size', '${data['front_wheel_size']?.toString() ?? '—'}"'),
      ('Rear Wheel Size', '${data['rear_wheel_size']?.toString() ?? '—'}"'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  setupName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                  showNewBikeSheet(
                    context,
                    user,
                    NewBikeMode.editSetup,
                    bikeType: bikeType,
                    uBikeID: uBikeID,
                    bikeName: bikeName,
                    uSetupID: uSetupID,
                    setupName: setupName,
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: FutureBuilder(
            future: DatabaseService(user.uid).getSetupInformation(uBikeID, uSetupID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                );
              }
              if (snapshot.hasError || snapshot.data == null) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('Failed to load')),
                );
              }
              final data = snapshot.data!.data() as Map<String, dynamic>;
              final rows = _buildRows(data);
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < rows.length; i++) ...[
                      _InfoRow(label: rows[i].$1, value: rows[i].$2),
                      if (i < rows.length - 1) const Divider(height: 1),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
