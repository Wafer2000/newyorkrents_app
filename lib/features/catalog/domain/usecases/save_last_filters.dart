import 'dart:convert';
import 'package:newyorkrents_app/core/storage/prefs_service.dart';

class SaveLastFilters {
  final PrefsService prefs;
  SaveLastFilters(this.prefs);
  Future<void> call(List<String> inputs) => prefs.setLastFilterInputs(jsonEncode(inputs));
}
