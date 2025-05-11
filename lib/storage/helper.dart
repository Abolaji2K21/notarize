import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notarize/models/note.dart';

class SharedPreferencesHelper {
  static const String _notesKey = 'notes';

  // Save notes to SharedPreferences
  static Future<void> saveNotes(List<Note> notes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notesJson = notes.map((note) => jsonEncode(note.toMap())).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }

  // Load notes from SharedPreferences
  static Future<List<Note>> loadNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notesJson = prefs.getStringList(_notesKey);
    
    if (notesJson == null) {
      return [];
    }

    return notesJson
        .map((noteJson) => Note.fromMap(jsonDecode(noteJson)))
        .toList();
  }

  // Update a specific note in SharedPreferences
  static Future<void> updateNote(Note updatedNote) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notesJson = prefs.getStringList(_notesKey);

    if (notesJson != null) {
      List<Note> notes = notesJson
          .map((noteJson) => Note.fromMap(jsonDecode(noteJson)))
          .toList();
      int index = notes.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        notes[index] = updatedNote;
        saveNotes(notes);  // Save updated list back
      }
    }
  }

  // Delete a note from SharedPreferences
  static Future<void> deleteNote(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notesJson = prefs.getStringList(_notesKey);

    if (notesJson != null) {
      List<Note> notes = notesJson
          .map((noteJson) => Note.fromMap(jsonDecode(noteJson)))
          .toList();
      notes.removeWhere((note) => note.id == id);
      saveNotes(notes);  // Save updated list back
    }
  }
}
