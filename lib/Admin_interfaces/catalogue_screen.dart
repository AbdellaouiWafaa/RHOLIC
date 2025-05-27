import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'book_service.dart'; // Importer le service

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final ScrollController _categoryScrollController = ScrollController();
  final BookService _bookService = BookService();

  final List<String> _categories = [
    'All',
    'Fiction',
    'Non-fiction',
    'Science',
    'Technology',
    'Adventure',
    'Art',
    'Health',
    'Personal Development',
    'Psychology',
    'Philosophy',
    'Horror',
    'Business',
    'Economics',
    'Comics',
    'History',
    'Biography',
    'Children',
    'Reference',
  ];

  bool _showLeftShadow = false;
  bool _showRightShadow = true;

  @override
  void initState() {
    super.initState();
    _categoryScrollController.addListener(_updateShadows);
    // Écouter les changements du service
    _bookService.addListener(_onBooksChanged);
  }

  void _onBooksChanged() {
    if (mounted) {
      setState(() {});
    }
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
    _bookService.removeListener(_onBooksChanged);
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
    final totalCopiesController = TextEditingController(text: '1');
    String selectedCategory = _categories[1]; // Fiction par défaut

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                    hintStyle: const TextStyle(
                      color: Color(0x80FFFFFF),
                    ),
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
                    hintStyle: const TextStyle(
                      color: Color(0x80FFFFFF),
                    ),
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
                  controller: totalCopiesController,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Total Copies',
                    hintStyle: const TextStyle(
                      color: Color(0x80FFFFFF),
                    ),
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
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFFB19E44),
                      ),
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null && newValue != 'All') {
                          setDialogState(() {
                            selectedCategory = newValue;
                          });
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
                    authorController.text.isNotEmpty &&
                    totalCopiesController.text.isNotEmpty) {
                  
                  // Ajouter le livre via le service
                  _bookService.addBook({
                    'title': titleController.text,
                    'author': authorController.text,
                    'category': selectedCategory,
                    'totalCopies': int.parse(totalCopiesController.text),
                    'availableCopies': int.parse(totalCopiesController.text),
                    'coverImage': 'assets/images/default_book.jpg',
                    'image': 'assets/images/default_book.jpg',
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
      ),
    );
  }

  void _showDeleteConfirmDialog(int index) {
    final books = _bookService.adminBooks;
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
          'Are you sure you want to delete "${books[index]['title']}"?',
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _bookService.removeBook(index);
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

  List<Map<String, dynamic>> _getFilteredBooks() {
    List<Map<String, dynamic>> books = _bookService.adminBooks;

    // Filtrer par catégorie
    if (_selectedCategory != 'All') {
      books = books.where((book) => book['category'] == _selectedCategory).toList();
    }

    // Filtrer par recherche
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      books = books.where((book) {
        return book['title'].toString().toLowerCase().contains(query) ||
               book['author'].toString().toLowerCase().contains(query);
      }).toList();
    }

    return books;
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _getFilteredBooks();
    final allBooks = _bookService.adminBooks;

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
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for books...',
                    hintStyle: const TextStyle(color: Color(0x80FFFFFF)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFB19E44),
                    ),
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
                        color: const Color(0x1AFFFFFF),
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
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              ..._categories.map((category) {
                                final isSelected = category == _selectedCategory;
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
                                      horizontal: 16,
                                    ),
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
                                    Color(0xCC121921),
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
                                    Color(0xCC121921),
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
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 100,
              ),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                final originalIndex = allBooks.indexOf(book);

                return Dismissible(
                  key: Key(book['title'] + originalIndex.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    _showDeleteConfirmDialog(originalIndex);
                    return false;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2A3B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Couverture du livre
                        Container(
                          width: 60,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: Color(0x33808080),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.book,
                              color: Color(0xFFB19E44),
                              size: 30,
                            ),
                          ),
                        ),
                        // Contenu principal
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Titre
                                Text(
                                  book['title'],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                // Auteur
                                Text(
                                  'by ${book['author']}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: const Color(0xB3FFFFFF),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                // Catégorie et contrôles
                                Row(
                                  children: [
                                    // Catégorie
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF121921),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        book['category'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 9,
                                          color: const Color(0xB3FFFFFF),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    // Compteur compact
                                    Container(
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF121921),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (book['availableCopies'] > 0) {
                                                _bookService.updateBookCopies(
                                                  originalIndex,
                                                  book['availableCopies'] - 1,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 26,
                                              height: 26,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            constraints: const BoxConstraints(
                                              minWidth: 30,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${book['availableCopies']}/${book['totalCopies']}',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 9,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (book['availableCopies'] <
                                                  book['totalCopies']) {
                                                _bookService.updateBookCopies(
                                                  originalIndex,
                                                  book['availableCopies'] + 1,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 26,
                                              height: 26,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Bouton delete
                        Container(
                          width: 36,
                          height: 90,
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Colors.red,
                            ),
                            onPressed: () => _showDeleteConfirmDialog(originalIndex),
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