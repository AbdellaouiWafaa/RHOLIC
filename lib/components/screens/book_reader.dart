import 'package:flutter/material.dart';


class BookReaderScreen extends StatefulWidget {
  final String bookTitle;
  final String author;
  final DateTime expiryDate;

  const BookReaderScreen({
    super.key,
    required this.bookTitle,
    required this.author,
    required this.expiryDate,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  // Reading settings
  double _fontSize = 16.0;
  String _fontFamily = 'Georgia';
  double _brightness = 0.7;
  Color _backgroundColor = const Color(0xFF0A153A);
  
  // Page control
  final PageController _pageController = PageController();
  int _currentPage = 1;
  final int _totalPages = 25; // This should match the actual number of pages in _getPageContent
  
  // UI control
  bool _showControls = true;
  
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }
  
  // Format time remaining
  String _formatTimeRemaining(){
  final DateTime oneMonthAgo = DateTime.now().subtract(Duration(days: 30));
  final Duration elapsed = DateTime.now().difference(oneMonthAgo);
  final days = elapsed.inDays;
  final hours = elapsed.inHours % 24;
  
  return "$days ${days == 1 ? 'day' : 'days'}, $hours ${hours == 1 ? 'hour' : 'hours'} remaining";
}

  // Sample book content from Alice in Wonderland
  String _getPageContent(int page) {
    final Map<String, dynamic> aliceBookData = {
      "title": "Alice's Adventures in Wonderland",
      "author": "Lewis Carroll",
      "chapters": [
        {
          "title": "CHAPTER I. Down the Rabbit-Hole",
          "content": "Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, 'and what is the use of a book,' thought Alice 'without pictures or conversation?'\n\nSo she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.\n\nThere was nothing so very remarkable in that; nor did Alice think it so very much out of the way to hear the Rabbit say to itself, 'Oh dear! Oh dear! I shall be late!' (when she thought it over afterwards, it occurred to her that she ought to have wondered at this, but at the time it all seemed quite natural); but when the Rabbit actually took a watch out of its waistcoat-pocket, and looked at it, and then hurried on, Alice started to her feet, for it flashed across her mind that she had never before seen a rabbit with either a waistcoat-pocket, or a watch to take out of it, and burning with curiosity, she ran across the field after it, and fortunately was just in time to see it pop down a large rabbit-hole under the hedge."
        },
        {
          "title": "CHAPTER II. The Pool of Tears",
          "content": "'Curiouser and curiouser!' cried Alice (she was so much surprised, that for the moment she quite forgot how to speak good English); 'now I'm opening out like the largest telescope that ever was! Good-bye, feet!' (for when she looked down at her feet, they seemed to be almost out of sight, they were getting so far off). 'Oh, my poor little feet, I wonder who will put on your shoes and stockings for you now, dears? I'm sure I shan't be able! I shall be a great deal too far off to trouble myself about you: you must manage the best way you can;—but I must be kind to them,' thought Alice, 'or perhaps they won't walk the way I want to go! Let me see: I'll give them a new pair of boots every Christmas.'\n\nAnd she went on planning to herself how she would manage it. 'They must go by the carrier,' she thought; 'and how funny it'll seem, sending presents to one's own feet! And how odd the directions will look!"
        },
        {
          "title": "CHAPTER III. A Caucus-Race and a Long Tale",
          "content": "They were indeed a queer-looking party that assembled on the bank—the birds with draggled feathers, the animals with their fur clinging close to them, and all dripping wet, cross, and uncomfortable.\n\nThe first question of course was, how to get dry again: they had a consultation about this, and after a few minutes it seemed quite natural to Alice to find herself talking familiarly with them, as if she had known them all her life. Indeed, she had quite a long argument with the Lory, who at last turned sulky, and would only say, 'I am older than you, and must know better'; and this Alice would not allow without knowing how old it was, and, as the Lory positively refused to tell its age, there was no more to be said.\n\nAt last the Mouse, who seemed to be a person of authority among them, called out, 'Sit down, all of you, and listen to me! I'll soon make you dry enough!' They all sat down at once, in a large ring, with the Mouse in the middle. Alice kept her eyes anxiously fixed on it, for she felt sure she would catch a bad cold if she did not get dry very soon."
        },
        // Additional chapters would continue here...
      ]
    };
    
    List<String> allPages = [];
    
    // First, add the book title and author as the first page
    allPages.add("${aliceBookData['title']}\nby ${aliceBookData['author']}");
    
    // Process each chapter
    for (var chapter in aliceBookData['chapters']) {
      // Add chapter title as its own page
      allPages.add(chapter['title']);
      
      // Split chapter content into paragraphs
      String content = chapter['content'];
      List<String> paragraphs = content.split("\n\n");
      
      // Variables to build each page
      String currentPage = "";
      int charCount = 0;
      final int maxCharsPerPage = 1000; // Adjust based on screen size/preferences
      
      // Process paragraphs into pages
      for (var paragraph in paragraphs) {
        // If adding this paragraph would make the page too long, create a new page
        if (charCount + paragraph.length > maxCharsPerPage && currentPage.isNotEmpty) {
          allPages.add(currentPage);
          currentPage = paragraph;
          charCount = paragraph.length;
        } else {
          // Add paragraph to current page
          if (currentPage.isNotEmpty) {
            currentPage += "\n\n";
            charCount += 2; // Account for the newlines
          }
          currentPage += paragraph;
          charCount += paragraph.length;
        }
      }
      
      // Add the last page of the chapter if not empty
      if (currentPage.isNotEmpty) {
        allPages.add(currentPage);
      }
    }
    
    // Return the requested page or end message
    if (page >= 1 && page <= allPages.length) {
      return allPages[page - 1];
    } else {
      return "End of preview. The full book contains many more adventures of Alice in Wonderland.";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _currentPage = page + 1;
                });
              },
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 17),
                        // Page content
                        Text(
                          _getPageContent(index + 1),
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: _fontSize + 6,
                            height: 1.6,
                            color: const Color.fromARGB(255, 255, 255, 255)
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
                  color: Colors.black45,
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
                            widget.bookTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "by ${widget.author}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 230, 230, 230),
                              fontSize: 14,
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
                    color: Colors.black45,
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
                              onPressed: _currentPage > 1 ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } : null,
                              color: _currentPage > 1 ? Colors.white : Colors.grey,
                            ),
                            
                            // Page indicator
                            Text(
                              "Page $_currentPage of $_totalPages",
                              style: const TextStyle(color: Colors.white),
                            ),
                            
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                              onPressed: _currentPage < _totalPages ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } : null,
                              color: _currentPage < _totalPages ? Colors.white : Colors.grey,
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
                                fontSize: 12,
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
                      "RHOLIC RHOLIC RHOLIC RHOLIC RHOLIC RHOLIC",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
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
                        items: <String>['Georgia', 'Roboto']
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
                      const Icon(
                        Icons.brightness_6,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                 
                  
                ],
              ),
            );
          },
        );
      },
    );
  }
}