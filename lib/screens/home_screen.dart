import 'package:flutter/material.dart';
import 'package:notarize/data/sample_data.dart';
import 'package:notarize/models/note.dart';
import 'package:notarize/screens/calendar_screen.dart';
import 'package:notarize/screens/note_editor_screen.dart';
import 'package:notarize/theme/app_theme.dart';
import 'package:notarize/widgets/note_card.dart';
import 'package:notarize/storage/note_storage.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Note> _notes;
  late List<Note> _filteredNotes;
  late DateTime _selectedDay;
  late List<DateTime> _weekDays;
  final List<Color> noteBoxColors = [
  const Color(0xFFC2DCFD),
  const Color(0xFFFFD8F4),
  const Color(0xFFFBF6AA),
  const Color(0xFFB0E9CA),
  const Color(0xFFFCFAD9),
  const Color(0xFFF1DBF5),
  const Color(0xFFD9E8FC),
  const Color(0xFFFFDBE3),
];

  NoteCategory _selectedCategory = NoteCategory.all;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _generateWeekDays();
    _notes = [];
    _loadNotes();
    // NoteStorage.clearAllPreferences();
  }

  void _generateWeekDays() {
    final today = DateTime.now();
    _selectedDay = today;

    _weekDays = List.generate(
      6,
      (index) => today.add(Duration(days: index)),
    );
  }

  Future<void> _loadNotes() async {
    _notes = await NoteStorage.loadNotes();
    _filterNotes();
  }

  void _filterNotes() {
    setState(() {
      _filteredNotes = _notes.where((note) {
        // Filter by category
        if (_selectedCategory != NoteCategory.all &&
            note.category != _selectedCategory) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _selectDay(DateTime day) {
    setState(() {
      _selectedDay = day;
    });
  }

  void _selectCategory(NoteCategory category) {
    setState(() {
      _selectedCategory = category;
      _filterNotes();
    });
  }

  void _openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(
          selectedDay: _selectedDay,
          onDaySelected: (day) {
            _selectDay(day);
            _generateWeekDays();
          },
        ),
      ),
    );
  }

  void _addNewNote() {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      content: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: NoteCategory.todoList,
      date: _selectedDay,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          note: newNote,
          isNewNote: true,
          onSave: (updatedNote) {
            setState(() {
              _notes.add(updatedNote);
              _filterNotes();
              NoteStorage.saveNotes(_notes);
            });
          },
        ),
      ),
    );
  }

  void _openNote(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          note: note,
          isNewNote: false,
          onSave: (updatedNote) {
            setState(() {
              final index = _notes.indexWhere((n) => n.id == updatedNote.id);
              if (index != -1) {
                _notes[index] = updatedNote;
                _filterNotes();
                NoteStorage.saveNotes(_notes);
              }
            });
          },
        ),
      ),
    );

    // Handle deletion if user selected "delete" from popup menu
    if (result == 'delete') {
      setState(() {
        _notes.removeWhere((n) => n.id == note.id);
        _filterNotes();
        NoteStorage.saveNotes(_notes);
      });
    }
  }

  void _togglePin(Note note) {
    setState(() {
      note.isPinned = !note.isPinned;
      // Optionally reorder list: Pinned notes first
      NoteStorage.saveNotes(_notes);
      _filteredNotes
          .sort((a, b) => (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _openCalendar,
                    child: Row(
                      children: [
                        Text(
                          DateFormat('yyyy MMMM').format(_selectedDay),
                          style: AppTheme.headingStyle,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons
                        .more_vert), // Using the more icon from iconography
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for notes',
                  prefixIcon: const Icon(Icons.search,
                      color: Colors
                          .grey), // Using the search icon from iconography
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),

              // Week days
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _weekDays.length,
                  itemBuilder: (context, index) {
                    final day = _weekDays[index];
                    final today = DateTime.now();

                    final isToday = day.day == today.day &&
                        day.month == today.month &&
                        day.year == today.year;

                    final isSelected = isToday;

                    final dayName = DateFormat('E').format(day).substring(0, 3);

                    return IgnorePointer(
                      // This disables all taps
                      ignoring: !isToday, // Only allow tap for today
                      child: GestureDetector(
                        onTap: () {
                          if (isToday) {
                            _selectDay(
                                day); // You may keep this even though today is auto-selected
                          }
                        },
                        child: Container(
                          width: 50,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected ? Colors.white : Colors.grey,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                day.day.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Categories
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: SampleData.getCategories().length,
                  itemBuilder: (context, index) {
                    final category = SampleData.getCategories()[index];
                    final isSelected = category == _selectedCategory;

                    return GestureDetector(
                      onTap: () => _selectCategory(category),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Notes grid
              Expanded(
                child: _filteredNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_alt_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notes found',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _filteredNotes.length,
                        itemBuilder: (context, index) {
                            final note = _filteredNotes[index];
                            final color = noteBoxColors[index % noteBoxColors.length];

                            return NoteCard(
                                 note: note,
                                  onTap: () => _openNote(note),
                                onTogglePin: () => _togglePin(note),
                                color: color, // ✅ New parameter passed
                                );
                              },
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add), // Using the add icon from iconography
      ),
    );
  }
}
