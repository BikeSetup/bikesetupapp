import 'package:flutter/material.dart';

class FieldMeta {
  final IconData icon;
  final String unit;
  const FieldMeta(this.icon, this.unit);
}

const FieldMeta kDefaultFieldMeta = FieldMeta(Icons.tune_rounded, '');

const Map<String, FieldMeta> kFieldMeta = {
  'Pressure':    FieldMeta(Icons.speed_rounded,                    'psi'),
  'Rebound':     FieldMeta(Icons.unfold_more_rounded,              'clicks'),
  'Compression': FieldMeta(Icons.unfold_less_rounded,              'clicks'),
  'Tokens':      FieldMeta(Icons.radio_button_unchecked_rounded,   'count'),
  'Spring Rate': FieldMeta(Icons.compress_rounded,                 'N/mm'),
  'Reach':       FieldMeta(Icons.straighten_rounded,               'mm'),
  'Stack Height':FieldMeta(Icons.height_rounded,                   'mm'),
  'Seat Height': FieldMeta(Icons.airline_seat_recline_normal,      'mm'),
};

const Map<String, List<String>> kDefaultFieldKeys = {
  'Fork':            ['Pressure', 'Rebound', 'Compression', 'Tokens'],
  'Shock':           ['Pressure', 'Rebound', 'Compression', 'Tokens'],
  'FrontTire':       ['Pressure'],
  'RearTire':        ['Pressure'],
  'GeneralSettings': ['Reach', 'Stack Height', 'Seat Height'],
};

bool isDefaultField(String category, String key) =>
    kDefaultFieldKeys[category]?.contains(key) ?? false;
