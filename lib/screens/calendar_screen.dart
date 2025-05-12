import 'package:flutter/material.dart';
import 'package:notarize/data/sample_data.dart';
import 'package:notarize/models/note.dart';
import 'package:notarize/theme/app_theme.dart';
import 'package:notarize/widgets/note_card.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  final DateTime selectedDay;

  const CalendarScreen({
    super.key, 
    required this.onDaySelected,
    required this.selectedDay,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late List<Note> _notes;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  final List<Color> noteBoxColors = [
  const Color(0xFFC2DCFD),
  const Color(0xFFFFD8F4),
  const Color(0xFFFBF6AA),
  const Color(0xFFB0E9CA),
  const Color(0xFFF1DBF5),
  const Color(0xFFD9E8FC),
  const Color(0xFFFCFAD9),
  const Color(0xFFFFDBE3),
];

  
  final Map<DateTime, List<Note>> _events = {};
  
  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
    _focusedDay = widget.selectedDay;
    _calendarFormat = CalendarFormat.month;
    _notes = SampleData.getNotes();
    
    // Group notes by date
    for (var note in _notes) {
      if (note.date != null) {
        final date = DateTime(note.date!.year, note.date!.month, note.date!.day);
        if (_events[date] == null) {
          _events[date] = [];
        }
        _events[date]!.add(note);
      }
    }
  }
  
  List<Note> _getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }
  
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }
  
  void _selectDay() {
    widget.onDaySelected(_selectedDay);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    final monthFormatter = DateFormat('MMMM yyyy');
    
    return Scaffold(
      appBar: AppBar(
        title: Text(monthFormatter.format(_focusedDay)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              markersMaxCount: 3,
              markerDecoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              titleTextStyle: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              formatButtonTextStyle: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Notes for ${DateFormat('MMM d, yyyy').format(_selectedDay)}',
                  style: AppTheme.subheadingStyle,
                ),
                const Spacer(),
                Text(
                  '${_getEventsForDay(_selectedDay).length} notes',
                  style: AppTheme.captionStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final note = _getEventsForDay(_selectedDay)[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: NoteCard(
                    note: note,
                    onTap: () {},
                    onTogglePin: () {
                      
                      // Handle pin toggle
                    },
                    color: noteBoxColors[index % noteBoxColors.length], 

                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectDay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Select This Day'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
