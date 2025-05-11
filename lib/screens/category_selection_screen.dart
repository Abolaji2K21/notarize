import 'package:flutter/material.dart';
import 'package:notarize/models/note.dart';
import 'package:notarize/theme/app_theme.dart';

class CategorySelectionScreen extends StatefulWidget {
  final NoteCategory currentCategory;

  const CategorySelectionScreen({
    super.key,
    required this.currentCategory,
  });

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  late NoteCategory _selectedCategory;
  final TextEditingController _newCategoryController = TextEditingController();
  bool _isAddingNewCategory = false;
  
  // List to store custom categories
  List<String> _customCategories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.currentCategory;
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  void _toggleAddNewCategory() {
    setState(() {
      _isAddingNewCategory = !_isAddingNewCategory;
    });
  }

  void _saveCategory() {
    Navigator.pop(context, _selectedCategory);
  }

  // Function to handle adding new custom categories
  void _addCustomCategory() {
    final newCategoryName = _newCategoryController.text.trim();
    if (newCategoryName.isNotEmpty) {
      setState(() {
        _customCategories.add(newCategoryName);
        _selectedCategory = NoteCategory.values.firstWhere(
            (e) => e.toString() == 'NoteCategory.all', // You can choose a default
            orElse: () => NoteCategory.all);
      });
      _newCategoryController.clear();
      _toggleAddNewCategory(); // Close text field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Add new category input
                if (_isAddingNewCategory)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _newCategoryController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Add a new category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.add),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: _addCustomCategory, // Add custom category
                        ),
                      ),
                    ),
                  )
                else
                  InkWell(
                    onTap: _toggleAddNewCategory,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Add a new category',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Category list from enum
                _buildCategoryItem(NoteCategory.important),
                _buildCategoryItem(NoteCategory.lectureNotes),
                _buildCategoryItem(NoteCategory.todoList),
                _buildCategoryItem(NoteCategory.shoppingList),
                _buildCategoryItem(NoteCategory.homework),
                _buildCategoryItem(NoteCategory.evening),
                _buildCategoryItem(NoteCategory.classes),
                _buildCategoryItem(NoteCategory.tour),
                _buildCategoryItem(NoteCategory.rollerCoaster),
                
                // Custom category list
                for (var category in _customCategories)
                  _buildCustomCategoryItem(category),
              ],
            ),
          ),
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(NoteCategory category) {
    final isSelected = _selectedCategory == category;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textColor,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display custom category
  Widget _buildCustomCategoryItem(String category) {
    final isSelected = _selectedCategory.name == category;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = NoteCategory.values.firstWhere(
              (e) => e.name == 'all', orElse: () => NoteCategory.all);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              category,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textColor,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
