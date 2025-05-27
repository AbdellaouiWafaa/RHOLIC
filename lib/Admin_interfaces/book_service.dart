import 'package:flutter/foundation.dart';

class BookService extends ChangeNotifier {
  static final BookService _instance = BookService._internal();
  factory BookService() => _instance;
  BookService._internal();

  // Liste des livres pour l'admin (catalogue complet)
   List<Map<String, dynamic>> _adminBooks = [
    
    {
      'title': 'Frankenstein',
      'author': 'Mary Shelley',
      'category': 'Fiction',
      'totalCopies': 3,
      'availableCopies': 1,
      'coverImage': 'assets/images/book2.jpg',
      'image': 'assets/images/frankenstein.png',
    },
    {
      'title': 'Dracula',
      'author': 'Bram Stoker',
      'category': 'Fiction',
      'totalCopies': 2,
      'availableCopies': 2,
      'coverImage': 'assets/images/book5.jpg',
      'image': 'assets/images/dracula.png',
    },
    {
      'title': 'Alice Wonderland',
      'author': 'Lewis Carroll',
      'category': 'Fiction',
      'totalCopies': 5,
      'availableCopies': 3,
      'coverImage': 'assets/images/book1.jpg',
      'image': 'assets/images/alice.png',
    },
    {
      'title': 'War and Peace',
      'author': 'Leo Tolstoy',
      'category': 'Adventure',
      'totalCopies': 4,
      'availableCopies': 2,
      'image': 'assets/images/war_peace.png',
      'coverImage': 'assets/images/war_peace.png',
    },
    {
      'author': 'Rebecca Yarrons',
      'title': 'The Forth Wing',
      'category': 'Biography',
      'totalCopies': 6,
      'availableCopies': 2,
      'image': 'assets/images/forth_wing.png',
      'coverImage': 'assets/images/forth_wing.png',
    },
  ];

  // Getters
  List<Map<String, dynamic>> get adminBooks => List.unmodifiable(_adminBooks);
  
  // Conversion pour l'affichage utilisateur (format simplifié)
  List<Map<String, String>> get userBooks {
    return _adminBooks.map((book) => {
      'title': book['title'].toString(),
      'author': book['author'].toString(),
      'image': book['image']?.toString() ?? book['coverImage']?.toString() ?? 'assets/images/default_book.jpg',
    }).toList();
  }

  // Méthodes pour l'admin
  void addBook(Map<String, dynamic> book) {
    // Ajouter les champs image et coverImage par défaut si non présents
    if (!book.containsKey('image')) {
      book['image'] = book['coverImage'] ?? 'assets/images/default_book.jpg';
    }
    if (!book.containsKey('coverImage')) {
      book['coverImage'] = book['image'] ?? 'assets/images/default_book.jpg';
    }
    
    _adminBooks.add(book);
    notifyListeners();
  }

  void removeBook(int index) {
    if (index >= 0 && index < _adminBooks.length) {
      _adminBooks.removeAt(index);
      notifyListeners();
    }
  }

  void updateBookCopies(int index, int availableCopies) {
    if (index >= 0 && index < _adminBooks.length) {
      _adminBooks[index]['availableCopies'] = availableCopies;
      notifyListeners();
    }
  }

  // Méthodes utilitaires
  int get totalBooks => _adminBooks.length;
  
  bool isBookAvailable(int index) {
    if (index >= 0 && index < _adminBooks.length) {
      return _adminBooks[index]['availableCopies'] > 0;
    }
    return false;
  }

  Map<String, dynamic>? getBookByIndex(int index) {
    if (index >= 0 && index < _adminBooks.length) {
      return _adminBooks[index];
    }
    return null;
  }

  List<Map<String, dynamic>> searchBooks(String query) {
    if (query.isEmpty) return _adminBooks;
    
    return _adminBooks.where((book) {
      return book['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
             book['author'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> getBooksByCategory(String category) {
    if (category == 'All') return _adminBooks;
    
    return _adminBooks.where((book) {
      return book['category'] == category;
    }).toList();
  }
}