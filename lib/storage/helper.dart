import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notarize/models/note.dart';
import 'package:flutter/foundation.dart';

class SharedPreferencesHelper {
  static const String _notesKey = 'notes';
  static const String _customCategoriesKey = 'customCategories'; // Key for custom categories

  // Save notes to SharedPreferences
  static Future<void> saveNotes(List<Note> notes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notesJson = notes.map((note) => jsonEncode(note.toMap())).toList();
    await prefs.setStringList(_notesKey, notesJson);
    debugPrint('Saved ${notes.length} notes to SharedPreferences');
  }

  // Load notes from SharedPreferences
  static Future<List<Note>> loadNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notesJson = prefs.getStringList(_notesKey);
    
    if (notesJson == null) {
      debugPrint('No notes found in SharedPreferences');
      return [];
    }

    final notes = notesJson
        .map((noteJson) => Note.fromMap(jsonDecode(noteJson)))
        .toList();
    
    debugPrint('Loaded ${notes.length} notes from SharedPreferences');
    return notes;
  }

  // Save custom categories to SharedPreferences
  static Future<void> saveCustomCategories(List<String> customCategories) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await prefs.setStringList(_customCategoriesKey, customCategories);
    debugPrint('Saved ${customCategories.length} custom categories to SharedPreferences: $customCategories');
    debugPrint('Save result: $result');
  }

  // Load custom categories from SharedPreferences
  static Future<List<String>> loadCustomCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList(_customCategoriesKey) ?? [];
    debugPrint('Loaded ${categories.length} custom categories from SharedPreferences: $categories');
    return categories;
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
        await saveNotes(notes);  // Save updated list back
        debugPrint('Updated note with ID: ${updatedNote.id}');
      } else {
        debugPrint('Note with ID: ${updatedNote.id} not found for update');
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
      await saveNotes(notes);  // Save updated list back
      debugPrint('Deleted note with ID: $id');
    }
  }

  // Debug method to print all stored data
  static Future<void> debugPrintAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    
    debugPrint('=== SharedPreferences Debug ===');
    debugPrint('All keys: $allKeys');
    
    final customCategories = prefs.getStringList(_customCategoriesKey);
    debugPrint('Custom categories: $customCategories');
    
    final notesJson = prefs.getStringList(_notesKey);
    debugPrint('Notes count: ${notesJson?.length ?? 0}');
    
    debugPrint('==============================');
  }

  // Clear all data (for testing)
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint('Cleared all SharedPreferences data');
  }
}