import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteStorage {
  static const String _notesKey = 'notes';

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => jsonEncode(note.toMap())).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }

  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey);
    if (notesJson == null) return [];

    return notesJson.map((jsonString) {
      final map = jsonDecode(jsonString);
      return Note.fromMap(map);
    }).toList();
  }

  static Future<void> clearAllPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
}
