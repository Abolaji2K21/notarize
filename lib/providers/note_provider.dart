// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/note.dart';
// import 'package:uuid/uuid.dart';

// class NoteProvider with ChangeNotifier {
//   List<Note> _notes = [];

//   List<Note> get notes => [..._notes];

//   Future<void> loadNotes() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? notesData = prefs.getString('notes');
//     if (notesData != null) {
//       final List<dynamic> decoded = jsonDecode(notesData);
//       // _notes = decoded.map((json) => Note.fromJson(json)).toList();
//       notifyListeners();
//     }
//   }

// Future<void> saveNotes() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString('notes', jsonEncode(_notes.map((note) => note.toJson()).toList()));
// }


//   void addNote(String title, String content) {
//     final newNote = Note(
//       id: Uuid().v4(),
//       title: title,
//       content: content,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//     _notes.insert(0, newNote);
//     saveNotes();
//     notifyListeners();
//   }

//   void updateNote(String id, String title, String content) {
//     final index = _notes.indexWhere((note) => note.id == id);
//     if (index >= 0) {
//       _notes[index] = Note(
//         id: id,
//         title: title,
//         content: content,
//         createdAt: _notes[index].createdAt,
//         updatedAt: DateTime.now(),
//       );
//       saveNotes();
//       notifyListeners();
//     }
//   }

//   void deleteNote(String id) {
//     _notes.removeWhere((note) => note.id == id);
//     saveNotes();
//     notifyListeners();
//   }

// Note? getNoteById(String id) {
//   try {
//     return _notes.firstWhere((note) => note.id == id);
//   } catch (e) {
//     return null;
//   }
// }

// }