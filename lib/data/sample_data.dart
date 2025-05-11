import 'package:flutter/material.dart';
import 'package:notarize/models/note.dart';

class SampleData {
  static List<Note> getNotes() {
    return [
      Note(
        id: '1',
        title: 'To-do list',
        content: '1. Reply to emails\n2. Prepare presentation slides for the marketing meeting\n3. Conduct research on competitor products\n4. Schedule and plan',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: NoteCategory.todoList,
        date: DateTime(2023, 5, 25),
        iconColor: Colors.blue,
      ),
      Note(
        id: '2',
        title: 'Homework',
        content: '1. Read chapter 7 for Psychology class\n2. Write a 2-page reflection on the assigned literature\n3. Prepare reading for English class',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: NoteCategory.homework,
        date: DateTime(2023, 5, 25),
        iconColor: Colors.pink,
      ),
      Note(
        id: '3',
        title: 'In the late evening',
        content: 'I retreated to my dorm room, finding solace in the quiet moments. Sometimes, I\'d call home to catch up with my family, reassuring them that I\'m doing well and',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        category: NoteCategory.evening,
        date: DateTime(2023, 5, 26),
        iconColor: Colors.amber,
      ),
      Note(
        id: '4',
        title: 'Afternoon classes',
        content: 'Classes were equally demanding, but I felt more at ease, thanks to the familiar faces I\'ve come to know throughout my time here',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: NoteCategory.classes,
        date: DateTime(2023, 5, 26),
        iconColor: Colors.green,
      ),
      Note(
        id: '5',
        title: 'Campus Tour',
        content: 'I joined the sea of students bustling around, all with different destinations in mind. The campus was alive with energy, as everyone seemed to be on a...',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        category: NoteCategory.tour,
        date: DateTime(2023, 5, 27),
        iconColor: Colors.purple,
      ),
      Note(
        id: '6',
        title: 'Roller coaster day',
        content: 'Juggling between college life\'s demands and the desire to savor every moment of this exhilarating journey waking up to the sound of my alarm',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
        category: NoteCategory.rollerCoaster,
        date: DateTime(2023, 5, 28),
        iconColor: Colors.lightBlue,
      ),
    ];
  }
  
  static List<NoteCategory> getCategories() {
    return [
      NoteCategory.all,
      NoteCategory.important,
      NoteCategory.lectureNotes,
      NoteCategory.todoList,
      NoteCategory.shoppingList,
    ];
  }
}
