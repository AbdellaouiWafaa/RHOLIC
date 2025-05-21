import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final ScrollController _categoryScrollController = ScrollController();

  final List<String> _categories = [
    'All',
    'Fiction',
    'Non-fiction',
    'Science',
    'History',
    'Biography',
    'Children',
    'Reference'
  ];

  bool _showLeftShadow = false;
  bool _showRightShadow = true;

  final List<Map<String, dynamic>> _books = [
    {
      'title': 'The Great Gatsby',
      'author': 'F. Scott Fitzgerald',
      'category': 'Fiction',
      'available': true,
      'coverImage': 'assets/images/book1.jpg',
    },
    {
      'title': 'To Kill a Mockingbird',
      'author': 'Harper Lee',
      'category': 'Fiction',
      'available': false,
      'coverImage': 'assets/images/book2.jpg',
    },
    {
      'title': 'A Brief History of Time',
      'author': 'Stephen Hawking',
      'category': 'Science',
      'available': true,
      'coverImage': 'assets/images/book3.jpg',
    },
    {
      'title': 'The Diary of a Young Girl',
      'author': 'Anne Frank',
      'category': 'Biography',
      'available': true,
      'coverImage': 'assets/images/book4.jpg',
    },
    {
      'title': 'Pride and Prejudice',
      'author': 'Jane Austen',
      'category': 'Fiction',
      'available': true,
      'coverImage': 'assets/images/book5.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _categoryScrollController.addListener(_updateShadows);
  }

  void _updateShadows() {
    final maxScroll = _categoryScrollController.position.maxScrollExtent;
    final currentScroll = _categoryScrollController.offset;
    setState(() {
      _showLeftShadow = currentScroll > 0;
      _showRightShadow = currentScroll < maxScroll;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(String category) {
    final index = _categories.indexOf(category);
    if (index >= 0) {
      final estimatedPosition = index * 100.0;
      _categoryScrollController.animateTo(
        estimatedPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    String selectedCategory =
        _categories[1]; // Default to first category after 'All'
    bool isAvailable = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3B),
        title: Text(
          'Add New Book',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: GoogleFonts.montserrat(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Book Title',
                  hintStyle: const TextStyle(color: Color(0x80FFFFFF)), // 50% white
                  filled: true,
                  fillColor: const Color(0xFF121921),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: authorController,
                style: GoogleFonts.montserrat(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Author Name',
                  hintStyle: const TextStyle(color: Color(0x80FFFFFF)), // 50% white
                  filled: true,
                  fillColor: const Color(0xFF121921),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF121921),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF1E2A3B),
                    value: selectedCategory,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFFB19E44)),
                    style: GoogleFonts.montserrat(color: Colors.white),
                    onChanged: (String? newValue) {
                      if (newValue != null && newValue != 'All') {
                        selectedCategory = newValue;
                      }
                    },
                    items: _categories
                        .where((category) => category != 'All')
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Available',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                  const Spacer(),
                  Switch(
                    value: isAvailable,
                    onChanged: (value) {
                      isAvailable = value;
                    },
                    activeColor: const Color(0xFFB19E44),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB19E44),
            ),
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  authorController.text.isNotEmpty) {
                setState(() {
                  _books.add({
                    'title': titleController.text,
                    'author': authorController.text,
                    'category': selectedCategory,
                    'available': isAvailable,
                    'coverImage': 'assets/images/default_book.jpg',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Book added successfully!',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please fill in all fields',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(
              'Add',
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3B),
        title: Text(
          'Delete Book',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${_books[index]['title']}"?',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _books.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Book deleted successfully!',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121921),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        backgroundColor: const Color(0xFFB19E44),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Books Catalogue',
                  style: GoogleFonts.islandMoments(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  style:
                      GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search for books...',
                    hintStyle: const TextStyle(color: Color(0x80FFFFFF)), // 50% white
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFFB19E44)),
                    filled: true,
                    fillColor: const Color(0xFF1E2A3B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0x1AFFFFFF), // 10% white
                        width: 1,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SingleChildScrollView(
                          controller: _categoryScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              ..._categories.map((category) {
                                final isSelected =
                                    category == _selectedCategory;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                    _scrollToCategory(category);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFB19E44)
                                          : const Color(0xFF1E2A3B),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        category,
                                        style: GoogleFonts.montserrat(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      if (_showRightShadow)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Container(
                              width: 40,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xCC121921), // 80% opacity
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_showLeftShadow)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Container(
                              width: 40,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xCC121921), // 80% opacity
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];

                if (_selectedCategory != 'All' &&
                    book['category'] != _selectedCategory) {
                  return const SizedBox.shrink();
                }

                if (_searchController.text.isNotEmpty &&
                    !book['title']
                        .toString()
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) &&
                    !book['author']
                        .toString()
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }

                return Dismissible(
                  key: Key(book['title'] + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    _showDeleteConfirmDialog(index);
                    return false; // prevent dismiss, we'll handle it manually
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: const Color(0xFF1E2A3B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Color(0x33808080), // 20% grey
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.book,
                              color: Color(0xFFB19E44),
                              size: 40,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['title'],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'by ${book['author']}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: const Color(0xB3FFFFFF), // 70% white
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF121921),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        book['category'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: const Color(0xB3FFFFFF), // 70% white
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: book['available']
                                            ? const Color(0x33008000) // 20% green
                                            : const Color(0x33FF0000), // 20% red
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        book['available']
                                            ? 'Available'
                                            : 'Borrowed',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: book['available']
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _showDeleteConfirmDialog(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}