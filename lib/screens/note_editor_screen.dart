import 'package:flutter/material.dart';
import 'package:notarize/models/note.dart';
import 'package:notarize/screens/category_selection_screen.dart';
import 'package:notarize/theme/app_theme.dart';
import 'package:notarize/widgets/editor_toolbar.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note note;
  final bool isNewNote;
  final Function(Note) onSave;

  const NoteEditorScreen({
    super.key,
    required this.note,
    required this.isNewNote,
    required this.onSave,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Note _note;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _titleController = TextEditingController(text: _note.title);
    _contentController = TextEditingController(text: _note.content);
    _isEditing = widget.isNewNote;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot save an empty note')),
      );
      return;
    }

    final updatedNote = _note.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );

    widget.onSave(updatedNote);
    Navigator.pop(context);
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _selectCategory() async {
    try {
      final result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => CategorySelectionScreen(
            currentCategory: _note.category,
            customCategory: _note.customCategory,
          ),
        ),
      );

      if (result != null) {
        // Safely extract values from the result map
        final category = result['category'];
        final customCategory = result['customCategory'];
        
        if (category is NoteCategory) {
          setState(() {
            _note = _note.copyWith(
              category: category,
              customCategory: customCategory as String?,
            );
          });
          
          debugPrint('Selected category: ${_note.category}, custom: ${_note.customCategory}');
        } else {
          debugPrint('Invalid category type: ${category.runtimeType}');
        }
      }
    } catch (e) {
      debugPrint('Error selecting category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final title = _titleController.text.trim();
        final content = _contentController.text.trim();

        if (title.isEmpty && content.isEmpty) {
          return true; // Allow pop
        } else {
          _saveNote();
          return false; // We'll handle the navigation
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final title = _titleController.text.trim();
              final content = _contentController.text.trim();

              if (title.isEmpty && content.isEmpty) {
                Navigator.pop(context);
              } else {
                _saveNote();
              }
            },
          ),
          actions: [
            if (!_isEditing)
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: _toggleEditing,
              ),
            IconButton(
              icon: Icon(
                _note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                size: 20,
              ),
              onPressed: () {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();

                if (title.isEmpty && content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot pin an empty note')),
                  );
                  return;
                }

                setState(() {
                  _note = _note.copyWith(isPinned: !_note.isPinned);
                });
                widget.onSave(_note);
              },
            ),
            IconButton(
              icon: const Icon(Icons.ios_share_outlined, size: 20),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'pin') {
                  setState(() {
                    _note = _note.copyWith(isPinned: !_note.isPinned);
                  });
                  widget.onSave(_note);
                } else if (value == 'delete') {
                  Navigator.pop(context, 'delete');
                } else if (value == 'edit') {
                  _toggleEditing();
                }
              },
              itemBuilder: (BuildContext context) => [
                if (!_isEditing)
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                PopupMenuItem(
                  value: 'pin',
                  child: Text(_note.isPinned ? 'Unpin' : 'Pin'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
          title: Text(_isEditing ? 'Edit Note' : _note.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isEditing)
                      TextField(
                        controller: _titleController,
                        style: AppTheme.headingStyle,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    else
                      Text(
                        _note.title,
                        style: AppTheme.headingStyle,
                      ),
                    const SizedBox(height: 16),
                    if (_isEditing)
                      TextField(
                        controller: _contentController,
                        style: AppTheme.bodyStyle,
                        decoration: const InputDecoration(
                          hintText: 'Start typing...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: null,
                      )
                    else
                      Text(
                        _note.content,
                        style: AppTheme.bodyStyle,
                      ),
                  ],
                ),
              ),
            ),
            if (_isEditing)
              Column(
                children: [
                  const EditorToolbar(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectCategory,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _note.customCategory ?? _note.category.name,
                                    style: const TextStyle(
                                      color: AppTheme.textColor,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppTheme.secondaryTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _saveNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(100, 48),
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}