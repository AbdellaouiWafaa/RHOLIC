import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Book {
  final String title;
  final String author;
  final List<Chapter> chapters;

  Book({
    required this.title,
    required this.author,
    required this.chapters,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      chapters: (json['chapters'] as List)
          .map((chapter) => Chapter.fromJson(chapter))
          .toList(),
    );
  }
}

class Chapter {
  final String title;
  final String content;

  Chapter({
    required this.title,
    required this.content,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      title: json['title'],
      content: json['content'],
    );
  }
}

class DigitalBookReaderScreen extends StatefulWidget {
  final String bookTitle;
  final String author;
  final String coverImageAsset;
  final DateTime expiryDate;

  const DigitalBookReaderScreen({
    super.key,
    required this.bookTitle,
    required this.author,
    required this.coverImageAsset,
    required this.expiryDate,
  });

  @override
  State<DigitalBookReaderScreen> createState() => _DigitalBookReaderScreenState();
}

class _DigitalBookReaderScreenState extends State<DigitalBookReaderScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showControls = true;
  double _fontSize = 20.0;
  String _fontFamily = 'Georgia';
  double _brightness = 0.5;
  Color _backgroundColor = const Color.fromARGB(255, 0, 0, 0);
  
  // Book data
  Book? _book;
  bool _isLoading = true;
  List<String> _pageContents = [];
  int _totalPages = 0;
  int _currentChapter = 0;

  @override
  void initState() {
    super.initState();
    _loadBookData();

    // Auto-hide controls after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }
  
  // Load book data from assets
  Future<void> _loadBookData() async {
    try {
      // Load JSON from assets
      final String jsonString = await rootBundle.loadString('assets/books/alice_in_wonderland.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      setState(() {
        _book = Book.fromJson(jsonData);
        _isLoading = false;
        
        // Process book content into pages
        _processBookIntoPages();
      });
    } catch (e) {
      debugPrint('Error loading book: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Process book content into readable pages
  void _processBookIntoPages() {
    if (_book == null) return;
    
    List<String> allPages = [];
    
    // Process each chapter
    for (var chapter in _book!.chapters) {
      // Add chapter title as its own page
      allPages.add('CHAPTER_TITLE:${chapter.title}');
      
      // Split chapter content into pages (roughly 2000 characters per page)
      final String content = chapter.content;
      const int charsPerPage = 2000;
      
      for (int i = 0; i < content.length; i += charsPerPage) {
        int end = i + charsPerPage;
        if (end > content.length) end = content.length;
        
        // Try to find a paragraph break or space to split on
        if (end < content.length) {
          int newEnd = content.lastIndexOf('\n\n', end);
          if (newEnd > i + 500) { // Ensure minimum page size
            end = newEnd;
          } else {
            newEnd = content.lastIndexOf('. ', end);
            if (newEnd > i + 500) {
              end = newEnd + 1; // Include the period
            } else {
              newEnd = content.lastIndexOf(' ', end);
              if (newEnd > i + 500) {
                end = newEnd;
              }
            }
          }
        }
        
        allPages.add(content.substring(i, end));
      }
    }
    
    setState(() {
      _pageContents = allPages;
      _totalPages = allPages.length;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Toggle controls visibility
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    // Auto-hide after delay
    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _showControls) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  // Format time remaining
  String _formatTimeRemaining() {
    final Duration remaining = widget.expiryDate.difference(DateTime.now());
    
    if (remaining.isNegative) {
      return "Expired";
    }
    
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    
    return "$days ${days == 1 ? 'day' : 'days'}, $hours ${hours == 1 ? 'hour' : 'hours'} remaining";
  }

  // Check if current page is a chapter title
  bool _isChapterTitle(String content) {
    return content.startsWith('CHAPTER_TITLE:');
  }
  
  // Extract chapter title from content
  String _extractChapterTitle(String content) {
    return content.substring('CHAPTER_TITLE:'.length);
  }
  
  // Track which chapter we're in based on page
  void _updateCurrentChapter(int pageIndex) {
    if (pageIndex < 0 || _pageContents.isEmpty) return;
    
    int chapter = 0;
    for (int i = 0; i <= pageIndex; i++) {
      if (_isChapterTitle(_pageContents[i])) {
        chapter++;
      }
    }
    
    if (_currentChapter != chapter) {
      setState(() {
        _currentChapter = chapter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 165, 133, 36),
          ),
        ),
      );
    }
    
    if (_book == null || _pageContents.isEmpty) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                "Failed to load book content",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 165, 133, 36),
                ),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Book content
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
                _updateCurrentChapter(page);
              },
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final String content = _pageContents[index];
                final bool isTitle = _isChapterTitle(content);
                
                // Inside the itemBuilder of PageView.builder
if (isTitle) {
  // Render chapter title page with extra spacing and larger font
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add extra space above the chapter title
          const SizedBox(height: 60),  // Added extra space here
          Text(
            _extractChapterTitle(content),
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: _fontSize + 20,  // Increased from +8 to +16
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 165, 133, 36),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Text(
            "Alice's Adventures in Wonderland",
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: _fontSize - 2,
              color: Colors.white38,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "by Lewis Carroll",
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: _fontSize - 2,
              color: Colors.white38,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
                
                // Render regular content page
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content,
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: _fontSize,
                            height: 1.8,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Top controls (header) - conditionally shown
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Visibility(
                visible: _showControls,
                child: Container(
                  color: Colors.black38,
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      
                      // Title
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _book?.title ?? widget.bookTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "by ${_book?.author ?? widget.author}",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      
                      // Settings button
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: _showSettingsBottomSheet,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom controls (footer) - conditionally shown
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Visibility(
                visible: _showControls,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black38,
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16, top: 16, left: 16, right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page navigation controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                              onPressed: _currentPage > 0 ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } : null,
                              color: _currentPage > 0 ? Colors.white : Colors.grey,
                            ),
                            
                            // Page indicator
                            Text(
                              "Page ${_currentPage + 1} of $_totalPages",
                              style: const TextStyle(color: Colors.white),
                            ),
                            
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                              onPressed: _currentPage < _totalPages - 1 ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } : null,
                              color: _currentPage < _totalPages - 1 ? Colors.white : Colors.grey,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Timer indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_clock, color: Color.fromARGB(255, 165, 133, 36), size: 14),
                            const SizedBox(width: 6),
                            Text(
                              _formatTimeRemaining(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 165, 133, 36),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Secure reading watermark
            Positioned(
              bottom: 10,
              right: 10,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.1,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: const Text(
                      "RHOLIC",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show settings bottom sheet
  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A1A3F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Reading Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Font size adjustment
                  Row(
                    children: [
                      const Text(
                        "Text Size",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: _fontSize > 12 ? () {
                          setModalState(() {
                            _fontSize -= 1;
                          });
                          setState(() {});
                        } : null,
                      ),
                      Text(
                        _fontSize.toStringAsFixed(0),
                        style: const TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _fontSize < 24 ? () {
                          setModalState(() {
                            _fontSize += 1;
                          });
                          setState(() {});
                        } : null,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Font family selection
                  Row(
                    children: [
                      const Text(
                        "Font",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: _fontFamily,
                        dropdownColor: const Color(0xFF142349),
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        underline: Container(
                          height: 1,
                          color: Colors.white24,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setModalState(() {
                              _fontFamily = newValue;
                            });
                            setState(() {});
                          }
                        },
                        items: <String>['Georgia', 'Roboto', 'Times New Roman', 'Open Sans']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Brightness adjustment
                  Row(
                    children: [
                      const Text(
                        "Brightness",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Slider(
                          value: _brightness,
                          min: 0.0,
                          max: 1.0,
                          activeColor: const Color.fromARGB(255, 165, 133, 36),
                          inactiveColor: Colors.grey[700],
                          onChanged: (value) {
                            setModalState(() {
                              _brightness = value;
                              // Adjust background color based on brightness
                              _backgroundColor = HSLColor.fromColor(const Color(0xFF0A0A32))
                                  .withLightness(0.05 + (_brightness * 0.25))
                                  .toColor();
                            });
                            setState(() {});
                          },
                        ),
                      ),
                      Icon(
                        Icons.brightness_6,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Status information
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color.fromARGB(255, 165, 133, 36),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "This book has been securely downloaded to your device for offline reading until ${widget.expiryDate.day}/${widget.expiryDate.month}/${widget.expiryDate.year}.",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}