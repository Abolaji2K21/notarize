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

    // If both fields are empty, show message and return without saving
    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot save an empty note')),
      );
      return; // Don't save, just show the snack bar
    }

    final updatedNote = _note.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );

    widget.onSave(updatedNote);
    Navigator.pop(context); // Go back after saving
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _selectCategory() async {
    final selectedCategory = await Navigator.push<NoteCategory>(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(
          currentCategory: _note.category,
        ),
      ),
    );

    if (selectedCategory != null) {
      setState(() {
        _note = _note.copyWith(category: selectedCategory);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final title = _titleController.text.trim();
            final content = _contentController.text.trim();

            // If note is empty, just go back without saving
            if (title.isEmpty && content.isEmpty) {
              Navigator.pop(context);
            } else {
              _saveNote(); // Save the note if there's content
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder, size: 20,), // Using the share icon from iconography
            onPressed: () {},
          ),
          // IconButton(
          //   icon: Icon(_isEditing ? Icons.check : Icons.edit),
          //   onPressed: _toggleEditing,
          // ),
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
            icon: Icon(Icons.ios_share_outlined, size: 20,),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pin') {
                setState(() {
                  _note = _note.copyWith(isPinned: !_note.isPinned);
                });
                widget.onSave(_note);
                Navigator.pop(context); // go back
              } else if (value == 'delete') {
                Navigator.pop(context, 'delete');
              }
            },
            itemBuilder: (BuildContext context) => [
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
        title: Text(_isEditing ? 'New Note' : _note.title),
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
                                  _note.category.name,
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
    );
  }
}
