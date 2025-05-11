import 'package:flutter/material.dart';

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.text_fields), // T icon
            onPressed: () {},
            color: Colors.grey.shade700,
          ),
          IconButton(
            icon: const Icon(Icons.format_bold), // B icon
            onPressed: () {},
            color: Colors.grey.shade700,
          ),
          IconButton(
            icon: const Icon(Icons.format_italic), // I icon
            onPressed: () {},
            color: Colors.grey.shade700,
          ),
          IconButton(
            icon: const Icon(Icons.format_underlined), // U icon
            onPressed: () {},
            color: Colors.grey.shade700,
          ),
          IconButton(
            icon: const Icon(Icons.format_align_left), // Align left
            onPressed: () {},
            color: Colors.grey.shade700,
          ),
          IconButton(
            icon: const Icon(Icons.format_align_center), // Align center
            onPressed: () {},
            color: Colors.grey.shade700,
          ),
          IconButton(
            icon: const Icon(Icons.format_align_right), // Align right
            onPressed: () {},
            color: Colors.grey.shade700,
          ),
          IconButton(
            icon: const Icon(Icons.format_align_justify), // Justify
            onPressed: () {},
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }
}
