import 'package:flutter/material.dart';
import 'package:notarize/models/note.dart';
import 'package:notarize/storage/helper.dart';
import 'package:notarize/theme/app_theme.dart';

class CategorySelectionScreen extends StatefulWidget {
  final NoteCategory currentCategory;
  final String? customCategory;
  

  const CategorySelectionScreen({
    Key? key,
    required this.currentCategory,
    this.customCategory,
  }) : super(key: key);

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  late NoteCategory _selectedCategory;
  String? _selectedCustomCategory;
  final TextEditingController _newCategoryController = TextEditingController();
  bool _isAddingNewCategory = false;
  List<String> _customCategories = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.currentCategory;
    _selectedCustomCategory = widget.customCategory;
    _loadCustomCategories();
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    super.dispose();
  }

  // Load custom categories from SharedPreferences
  Future<void> _loadCustomCategories() async {
    _customCategories = await SharedPreferencesHelper.loadCustomCategories();
    setState(() {});
  }

  // Save custom categories to SharedPreferences
  Future<void> _saveCustomCategories() async {
    await SharedPreferencesHelper.saveCustomCategories(_customCategories);
  }

  // Toggle the option to add a new category
  void _toggleAddNewCategory() {
    setState(() {
      _isAddingNewCategory = !_isAddingNewCategory;
    });
  }

  // Save the selected category
  void _saveCategory() {
    Navigator.pop(context, {
      'category': _selectedCategory,
      'customCategory': _selectedCustomCategory,
    });
  }

  // Add a new custom category
void _addCustomCategory() async {
  final newCategoryName = _newCategoryController.text.trim();
  if (newCategoryName.isNotEmpty && !_customCategories.contains(newCategoryName)) {
    setState(() {
      _customCategories.add(newCategoryName);
      _selectedCategory = NoteCategory.all; // Set to all for custom categories
      _selectedCustomCategory = newCategoryName;
    });
    
    // Debug print before saving
    print('Adding new category: $newCategoryName');
    print('Updated custom categories list: $_customCategories');
    
    // Make sure to await this
    await _saveCustomCategories();
    
    // Debug print after saving
    final savedCategories = await SharedPreferencesHelper.loadCustomCategories();
    print('Categories after saving: $savedCategories');
    
    _newCategoryController.clear();
    _toggleAddNewCategory();
  } else if (newCategoryName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category name cannot be empty')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This category already exists')),
    );
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
                if (_isAddingNewCategory)
                  _buildNewCategoryInput()
                else
                  _buildAddNewButton(),
                ...NoteCategory.values
                    .where((e) => e != NoteCategory.all)
                    .map((e) => _buildCategoryItem(e)),
                ..._customCategories.map((e) => _buildCustomCategoryItem(e)),
              ],
            ),
          ),
          _buildSaveButton()
        ],
      ),
    );
  }

  // Build the category item
  Widget _buildCategoryItem(NoteCategory category) {
    final isSelected = _selectedCategory == category && _selectedCustomCategory == null;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _selectedCustomCategory = null;
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
            _buildCheckCircle(isSelected),
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

  // Build the custom category item
  Widget _buildCustomCategoryItem(String categoryName) {
    final isSelected = _selectedCustomCategory == categoryName;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = NoteCategory.all; // Always set to all for custom categories
          _selectedCustomCategory = categoryName;
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
            _buildCheckCircle(isSelected),
            const SizedBox(width: 16),
            Text(
              categoryName,
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

  // Build the check circle for selection
  Widget _buildCheckCircle(bool isSelected) {
    return Container(
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
      child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
    );
  }

  // Build the new category input
  Widget _buildNewCategoryInput() {
    return Container(
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
            onPressed: _addCustomCategory,
          ),
        ),
        onSubmitted: (_) => _addCustomCategory(),
      ),
    );
  }

  // Build the button to add a new category
  Widget _buildAddNewButton() {
    return InkWell(
      onTap: _toggleAddNewCategory,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.add, color: Colors.black),
            SizedBox(width: 16),
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
    );
  }

  // Build the save button
  Widget _buildSaveButton() {
    return Container(
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
    );
  }
}