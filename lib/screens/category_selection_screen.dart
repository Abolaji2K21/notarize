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

  Future<void> _loadCustomCategories() async {
    _customCategories = await SharedPreferencesHelper.loadCustomCategories();
    setState(() {});
  }

  Future<void> _saveCustomCategories() async {
    await SharedPreferencesHelper.saveCustomCategories(_customCategories);
  }

  void _toggleAddNewCategory() {
    setState(() {
      _isAddingNewCategory = !_isAddingNewCategory;
    });
  }

  void _saveCategory() {
    Navigator.pop(context, {
      'category': _selectedCategory,
      'customCategory': _selectedCustomCategory,
    });
  }

  void _deleteCustomCategory(String categoryName) async {
    setState(() {
      _customCategories.remove(categoryName);
      if (_selectedCustomCategory == categoryName) {
        _selectedCustomCategory = null;
      }
    });
    await _saveCustomCategories();
  }

  void _confirmDeleteCategory(String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Are you sure you want to delete "$categoryName"?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCustomCategory(categoryName);
              },
            ),
          ],
        );
      },
    );
  }

  void _addCustomCategory() async {
    final newCategoryName = _newCategoryController.text.trim();
    if (newCategoryName.isNotEmpty && !_customCategories.contains(newCategoryName)) {
      setState(() {
        _customCategories.add(newCategoryName);
        _selectedCategory = NoteCategory.all;
        _selectedCustomCategory = newCategoryName;
      });

      await _saveCustomCategories();
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

  Widget _buildCustomCategoryItem(String categoryName) {
    final isSelected = _selectedCustomCategory == categoryName;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = NoteCategory.all;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDeleteCategory(categoryName),
            ),
          ],
        ),
      ),
    );
  }

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
