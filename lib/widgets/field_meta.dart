import 'package:flutter/material.dart';

class FieldMeta {
  final IconData icon;
  final String unit;
  const FieldMeta(this.icon, this.unit);
}

const FieldMeta kDefaultFieldMeta = FieldMeta(Icons.tune_rounded, '');

const Map<String, FieldMeta> kFieldMeta = {
  'Pressure':              FieldMeta(Icons.speed_rounded,                    'psi'),
  'Rebound':               FieldMeta(Icons.unfold_more_rounded,              'clicks'),
  'High Speed Rebound':    FieldMeta(Icons.unfold_more_rounded,              'clicks'),
  'Low Speed Rebound':     FieldMeta(Icons.unfold_more_rounded,              'clicks'),
  'Compression':           FieldMeta(Icons.unfold_less_rounded,              'clicks'),
  'High Speed Compression':FieldMeta(Icons.unfold_less_rounded,              'clicks'),
  'Low Speed Compression': FieldMeta(Icons.unfold_less_rounded,              'clicks'),
  'Tokens':                FieldMeta(Icons.radio_button_unchecked_rounded,   'count'),
  'Spring Rate':           FieldMeta(Icons.compress_rounded,                 'N/mm'),
  'Preload':               FieldMeta(Icons.density_medium_rounded,           'mm'),
  'Reach':                 FieldMeta(Icons.straighten_rounded,               'mm'),
  'Stack Height':          FieldMeta(Icons.height_rounded,                   'mm'),
  'Seat Height':           FieldMeta(Icons.airline_seat_recline_normal,      'mm'),
};

// Single source of truth for per-category field configuration.
// defaultKeys doubles as requiredKeys — required fields cannot be deleted.
class _CategoryConfig {
  final List<String> defaultKeys;
  final List<String> suggestedKeys;
  const _CategoryConfig({required this.defaultKeys, this.suggestedKeys = const []});
}

const Map<String, _CategoryConfig> _kCategoryConfigs = {
  'Fork': _CategoryConfig(
    defaultKeys:   ['Pressure', 'Rebound', 'Compression', 'Tokens'],
    suggestedKeys: ['High Speed Rebound', 'Low Speed Rebound', 'High Speed Compression', 'Low Speed Compression', 'Spring Rate'],
  ),
  'Shock': _CategoryConfig(
    defaultKeys:   ['Pressure', 'Preload', 'Spring Rate', 'Rebound', 'Compression', 'Tokens'],
    suggestedKeys: ['High Speed Rebound', 'Low Speed Rebound', 'High Speed Compression', 'Low Speed Compression'],
  ),
  'FrontTire':       _CategoryConfig(defaultKeys: ['Pressure']),
  'RearTire':        _CategoryConfig(defaultKeys: ['Pressure']),
  'GeneralSettings': _CategoryConfig(defaultKeys: ['Reach', 'Stack Height', 'Seat Height']),
};

// Public derived views — callers use these unchanged.
final Map<String, List<String>> kDefaultFieldKeys = {
  for (final e in _kCategoryConfigs.entries) e.key: e.value.defaultKeys,
};

final Map<String, List<String>> kSuggestedFieldKeys = {
  for (final e in _kCategoryConfigs.entries) e.key: e.value.suggestedKeys,
};

bool isDefaultField(String category, String key) =>
    _kCategoryConfigs[category]?.defaultKeys.contains(key) ?? false;

/// A required field cannot be deleted. Currently identical to [isDefaultField].
bool isRequiredField(String category, String key) => isDefaultField(category, key);
