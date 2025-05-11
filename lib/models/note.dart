import 'package:flutter/material.dart';
import 'package:notarize/theme/app_theme.dart';

enum NoteCategory {
  all,
  important,
  lectureNotes,
  todoList,
  shoppingList,
  homework,
  evening,
  classes,
  tour,
  rollerCoaster,
}

extension NoteCategoryExtension on NoteCategory {
  String get name {
    switch (this) {
      case NoteCategory.all:
        return 'All';
      case NoteCategory.important:
        return 'Important';
      case NoteCategory.lectureNotes:
        return 'Lecture notes';
      case NoteCategory.todoList:
        return 'To-do lists';
      case NoteCategory.shoppingList:
        return 'Shopping list';
      case NoteCategory.homework:
        return 'Homework';
      case NoteCategory.evening:
        return 'In the late evening';
      case NoteCategory.classes:
        return 'Afternoon classes';
      case NoteCategory.tour:
        return 'Campus Tour';
      case NoteCategory.rollerCoaster:
        return 'Roller coaster day';
    }
  }
  
  Color get color {
    switch (this) {
      case NoteCategory.todoList:
        return AppTheme.todoColor;
      case NoteCategory.homework:
        return AppTheme.homeworkColor;
      case NoteCategory.evening:
        return AppTheme.eveningColor;
      case NoteCategory.classes:
        return AppTheme.classesColor;
      case NoteCategory.tour:
        return AppTheme.tourColor;
      case NoteCategory.rollerCoaster:
        return AppTheme.rollerCoasterColor;
      case NoteCategory.important:
        return Colors.amber.shade100;
      case NoteCategory.lectureNotes:
        return Colors.blue.shade100;
      case NoteCategory.shoppingList:
        return Colors.green.shade100;
      case NoteCategory.all:
        return Colors.grey.shade200;
    }
  }
  
  IconData get icon {
    switch (this) {
      case NoteCategory.all:
        return Icons.notes;
      case NoteCategory.important:
        return Icons.star;
      case NoteCategory.lectureNotes:
        return Icons.book;
      case NoteCategory.todoList:
        return Icons.check_circle;
      case NoteCategory.shoppingList:
        return Icons.shopping_cart;
      case NoteCategory.homework:
        return Icons.assignment;
      case NoteCategory.evening:
        return Icons.nightlight;
      case NoteCategory.classes:
        return Icons.school;
      case NoteCategory.tour:
        return Icons.tour;
      case NoteCategory.rollerCoaster:
        return Icons.attractions;
    }
  }
}

class Note {
  final String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  NoteCategory category;
  DateTime? date;
  Color? iconColor;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    this.date,
    this.iconColor,
    this.isPinned = false,
  });

  Note copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
    NoteCategory? category,
    DateTime? date,
    Color? iconColor,
    bool? isPinned
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      date: date ?? this.date,
      iconColor: iconColor ?? this.iconColor,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      isPinned: map['isPinned'] == 1, // SQLite stores bool as 1 or 0
      category: NoteCategory.values.firstWhere((e) => e.toString() == map['category']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isPinned': isPinned ? 1 : 0,
      'category': category.toString(),
      'date': date?.millisecondsSinceEpoch,
    };
  }
}
