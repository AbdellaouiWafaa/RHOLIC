import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/dashboard.dart';


BookDetailsScreen getAliceInWonderlandDetailsScreen() {
  return BookDetailsScreen(
    key: const Key('Alice in Wonderland'),
    bookTitle: "Alice in Wonderland",
    author: "Lewis Carroll",
    coverImageAsset: 'assets/images/alice.png',
    description: "Alice's Adventures in Wonderland by Lewis Carroll is a classic children's novel written in the mid-19th century. The story follows a young girl named Alice who, feeling bored and sleepy while sitting by a riverbank, encounters a White Rabbit and follows it down a rabbit hole, plunging into a fantastical world filled with curious creatures and whimsical adventures. The opening of the book introduces Alice as she daydreams about her surroundings before spotting the White Rabbit, who is both flustered and animated. Curious, Alice pursues the Rabbit and finds herself tumbling down a deep rabbit hole, leading to a curious hall filled with doors, all locked. After experiencing a series of bizarre changes in size from eating and drinking mysterious substances, she begins exploring this new world, initially frustrated by her newfound challenges as she navigates her size and the peculiar inhabitants she meets. The narrative sets the tone for Alice's whimsical and often nonsensical adventures that characterize the entire tale.",
    rating: 4.7,
    totalRatings: 4,
    reviews: [
      ReviewModel(
        userName: "Emma T.",
        userAvatarUrl: "https://example.com/avatar1.jpg",
        date: "March 15, 2025",
        rating: 4.5,
        comment: "I couldn't put this book down! The world-building is incredible and the characters are so well developed. The romance subplot adds just the right amount of tension to the story.",
        likes: 28,
      ),
      ReviewModel(
        userName: "James R.",
        userAvatarUrl: "https://example.com/avatar2.jpg",
        date: "March 10, 2025",
        rating: 5.0,
        comment: "One of the best fantasy books I've read this year. The dragon training sequences are thrilling and the political intrigue keeps you guessing until the end.",
        likes: 43,
      ),
      ReviewModel(
        userName: "Sarah M.",
        userAvatarUrl: "https://example.com/avatar3.jpg",
        date: "March 5, 2025",
        rating: 4.8,
        comment: "The character development in this book is phenomenal. I love how the protagonist grows throughout the story and faces her fears.",
        likes: 35,
      ),
      ReviewModel(
        userName: "David L.",
        userAvatarUrl: "https://example.com/avatar4.jpg",
        date: "February 28, 2025",
        rating: 4.7,
        comment: "The action scenes are so well written! I felt like I was right there with the characters during the dragon flights.",
        likes: 22,
      ),
    ],
  );
}

enum LoanType {
  digital,
  physical,
  none
}

enum LoanStatus {
  none,
  downloading,
  available,
  expired,
  pickedUp
}

class BookDetailsScreen extends StatefulWidget {
  final String bookTitle;
  final String author;
  final String coverImageAsset;
  final String description;
  final double rating;
  final int totalRatings;
  final List<ReviewModel> reviews;

  const BookDetailsScreen({
    required Key key,
    required this.bookTitle,
    required this.author,
    required this.coverImageAsset,
    required this.description,
    required this.rating,
    required this.totalRatings,
    required this.reviews,
  }) : super(key: key);

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool showAllReviews = false;
  final ScrollController _scrollController = ScrollController();
  
  // Added state variables for loan functionality
  LoanType selectedLoanType = LoanType.none;
  LoanStatus loanStatus = LoanStatus.none;
  DateTime? expiryDate;
  
  // Add controllers and state for new review
  final TextEditingController _commentController = TextEditingController();
  double _userRating = 0.0;
  bool _isSubmittingReview = false;

  // Placeholder for getting the logged-in user's name
  String getLoggedInUserName() {

    return 'Current User';
  }

  void _scrollToReviews() {
    setState(() {
      showAllReviews = true;
    });
    // Allow the widget to rebuild with all reviews
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Show loan options dialog
  void _showLoanOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0A1A3F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Choose Loan Option",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLoanOption(
                context: context,
                icon: Icons.smartphone,
                title: "Digital (5 days offline)",
                description: "Download to read on this app",
                onTap: () {
                  setState(() {
                    selectedLoanType = LoanType.digital;
                  });
                  Navigator.pop(context);
                  _processDigitalLoan();
                },
              ),
              const SizedBox(height: 16),
              _buildLoanOption(
                context: context,
                icon: Icons.menu_book,
                title: "Physical (Pick up at library)",
                description: "Ready for pickup in 24h",
                onTap: () {
                  setState(() {
                    selectedLoanType = LoanType.physical;
                  });
                  Navigator.pop(context);
                  _processPhysicalLoan();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Build individual loan option item
  Widget _buildLoanOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF142349),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 165, 133, 36), size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Process digital loan
  void _processDigitalLoan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalBookReaderScreen(
          bookTitle: widget.bookTitle,
          author: widget.author,
          coverImageAsset: widget.coverImageAsset,
          expiryDate: DateTime.now().add(const Duration(days: 5)),
        ),
      ),
    );
  }

  
  void _processPhysicalLoan() {
  
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0A1A3F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Physical Loan Confirmed",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Color.fromARGB(255, 165, 133, 36),
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                "${widget.bookTitle} will be available for pickup at our library within 24 hours.",
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                "Pickup ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                style: const TextStyle(
                  color: Color.fromARGB(255, 165, 133, 36),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  loanStatus = LoanStatus.pickedUp;
                });
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Color.fromARGB(255, 165, 133, 36)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show notification
  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF142349),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Open book reader
  void _openBookReader() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalBookReaderScreen(
          bookTitle: widget.bookTitle,
          author: widget.author,
          coverImageAsset: widget.coverImageAsset,
          expiryDate: expiryDate!,
        ),
      ),
    );
  }

  String _getLoanButtonText() {
    switch (loanStatus) {
      case LoanStatus.none:
        return "Loan Book";
      case LoanStatus.downloading:
        return "Downloading...";
      case LoanStatus.available:
        return "Open Book";
      case LoanStatus.expired:
        return "Loan Expired";
      case LoanStatus.pickedUp:
        return "Pick up at Library";
    }
  }

  Color _getLoanButtonColor() {
    switch (loanStatus) {
      case LoanStatus.expired:
        return Colors.grey;
      default:
        return const Color.fromARGB(255, 165, 133, 36);
    }
  }


  void _handleLoanButtonTap() {
    switch (loanStatus) {
      case LoanStatus.none:
        _showLoanOptionsDialog();
        break;
      case LoanStatus.available:
        _openBookReader();
        break;
      case LoanStatus.expired:
        _showLoanOptionsDialog();
        break;
      case LoanStatus.pickedUp:
       
        _showNotification("Visit our library to pick up your book");
        break;
      default:
     
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_userRating == 0.0 || _commentController.text.trim().isEmpty) {
      _showNotification('Please provide a rating and a comment.');
      return;
    }
    setState(() {
      _isSubmittingReview = true;
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        widget.reviews.insert(0, ReviewModel(
          userName: getLoggedInUserName(),
          userAvatarUrl: 'https://example.com/default_avatar.png', // Replace with actual avatar if available
          date: "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
          rating: _userRating,
          comment: _commentController.text.trim(),
          likes: 0,
        ));
        _userRating = 0.0;
        _commentController.clear();
        _isSubmittingReview = false;
        showAllReviews = true;
      });
      _showNotification('Thank you for your review!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A32),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A32),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Color.fromARGB(255, 165, 133, 36)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color.fromARGB(255, 165, 133, 36)),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content - scrollable
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 100), // Space for the button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book cover and basic info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book cover - changed to use Asset
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.coverImageAsset,
                          height: 180,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              width: 120,
                              color: Colors.grey[800],
                              child: const Icon(Icons.book, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Book details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.author,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Rating
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  widget.rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "(${widget.totalRatings} ratings)",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Show loan status if applicable
                            if (loanStatus == LoanStatus.available || loanStatus == LoanStatus.expired) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    loanStatus == LoanStatus.available 
                                        ? Icons.access_time 
                                        : Icons.timer_off,
                                    color: loanStatus == LoanStatus.available 
                                        ? const Color.fromARGB(255, 165, 133, 36)
                                        : Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    loanStatus == LoanStatus.available
                                        ? "Expires: ${expiryDate?.day}/${expiryDate?.month}/${expiryDate?.year}"
                                        : "Loan expired",
                                    style: TextStyle(
                                      color: loanStatus == LoanStatus.available
                                          ? const Color.fromARGB(255, 165, 133, 36)
                                          : Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Description section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Reviews section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Reader Reviews",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _scrollToReviews,
                            child: const Text(
                              "See All",
                              style: TextStyle(
                                color: Color.fromARGB(255, 165, 133, 36),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      
                      // Review list - now showing all reviews when "See All" is clicked
                      ...widget.reviews
                          .take(showAllReviews ? widget.reviews.length : 2)
                          .map((review) => InteractiveReviewCard(review: review)),
                      const SizedBox(height: 24),
                      // New review form
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    _userRating > index ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _userRating = (index + 1).toDouble();
                                    });
                                  },
                                );
                              }),
                            ),
                            const SizedBox(height: 8),
                         
                            TextField(
                              controller: _commentController,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Write a Review...',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[850],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: _isSubmittingReview ? null : _submitReview,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 165, 133, 36),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isSubmittingReview
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text(
                                        'Submit',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed "Loan Book" button at bottom with dynamic text based on status
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(38, 13, 33, 120),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(38, 13, 33, 120),
                    blurRadius: 20,
                    spreadRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: loanStatus == LoanStatus.downloading ? null : _handleLoanButtonTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getLoanButtonColor(),
                  foregroundColor: const Color(0xFF0A0A32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: loanStatus == LoanStatus.downloading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Color(0xFF0A0A32),
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _getLoanButtonText(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        _getLoanButtonText(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// New Digital Book Reader Screen
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
  int _currentPage = 1;
  final int _totalPages = 42; // Simulated total pages
  bool _showControls = true;
  double _fontSize = 16.0;
  String _fontFamily = 'Georgia';
  double _brightness = 0.5;
  Color _backgroundColor = const Color(0xFF0A0A32);

  @override
  void initState() {
    super.initState();

    // Auto-hide controls after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
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

  // Sample book content (first few paragraphs of Dracula)
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
      {
        "title": "CHAPTER IV. The Rabbit Sends in a Little Bill",
        "content": "It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself 'The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She'll get me executed, as sure as ferrets are ferrets! Where can I have dropped them, I wonder?' Alice guessed in a moment that it was looking for the fan and the pair of white kid gloves, and she very good-naturedly began hunting about for them, but they were nowhere to be seen—everything seemed to have changed since her swim in the pool, and the great hall, with the glass table and the little door, had vanished completely.\n\nVery soon the Rabbit noticed Alice, as she went hunting about, and called out to her in an angry tone, 'Why, Mary Ann, what are you doing out here? Run home this moment, and fetch me a pair of gloves and a fan! Quick, now!' And Alice was so much frightened that she ran off at once in the direction it pointed to, without trying to explain the mistake it had made."
      },
      {
        "title": "CHAPTER V. Advice from a Caterpillar",
        "content": "The Caterpillar and Alice looked at each other for some time in silence: at last the Caterpillar took the hookah out of its mouth, and addressed her in a languid, sleepy voice.\n\n'Who are you?' said the Caterpillar.\n\nThis was not an encouraging opening for a conversation. Alice replied, rather shyly, 'I—I hardly know, sir, just at present—at least I know who I was when I got up this morning, but I think I must have been changed several times since then.'\n\n'What do you mean by that?' said the Caterpillar sternly. 'Explain yourself!'\n\n'I can't explain myself, I'm afraid, sir,' said Alice, 'because I'm not myself, you see.'\n\n'I don't see,' said the Caterpillar.\n\n'I'm afraid I can't put it more clearly,' Alice replied very politely, 'for I can't understand it myself to begin with; and being so many different sizes in a day is very confusing.'"
      },
      {
        "title": "CHAPTER VI. Pig and Pepper",
        "content": "For a minute or two she stood looking at the house, and wondering what to do next, when suddenly a footman in livery came running out of the wood—(she considered him to be a footman because he was in livery: otherwise, judging by his face only, she would have called him a fish)—and rapped loudly at the door with his knuckles. It was opened by another footman in livery, with a round face, and large eyes like a frog; and both footmen, Alice noticed, had powdered hair that curled all over their heads. She felt very curious to know what it was all about, and crept a little way out of the wood to listen.\n\nThe Fish-Footman began by producing from under his arm a great letter, nearly as large as himself, and this he handed over to the other, saying, in a solemn tone, 'For the Duchess. An invitation from the Queen to play croquet.' The Frog-Footman repeated, in the same solemn tone, only changing the order of the words a little, 'From the Queen. An invitation for the Duchess to play croquet.'"
      },
      {
        "title": "CHAPTER VII. A Mad Tea-Party",
        "content": "There was a table set out under a tree in front of the house, and the March Hare and the Hatter were having tea at it: a Dormouse was sitting between them, fast asleep, and the other two were using it as a cushion, resting their elbows on it, and talking over its head. 'Very uncomfortable for the Dormouse,' thought Alice; 'only, as it's asleep, I suppose it doesn't mind.'\n\nThe table was a large one, but the three were all crowded together at one corner of it: 'No room! No room!' they cried out when they saw Alice coming. 'There's plenty of room!' said Alice indignantly, and she sat down in a large arm-chair at one end of the table.\n\n'Have some wine,' the March Hare said in an encouraging tone.\n\nAlice looked all round the table, but there was nothing on it but tea. 'I don't see any wine,' she remarked.\n\n'There isn't any,' said the March Hare.\n\n'Then it wasn't very civil of you to offer it,' said Alice angrily.\n\n'It wasn't very civil of you to sit down without being invited,' said the March Hare."
      },
      {
        "title": "CHAPTER VIII. The Queen's Croquet-Ground",
        "content": "A large rose-tree stood near the entrance of the garden: the roses growing on it were white, but there were three gardeners at it, busily painting them red. Alice thought this a very curious thing, and she went nearer to watch them, and just as she came up to them she heard one of them say, 'Look out now, Five! Don't go splashing paint over me like that!'\n\n'I couldn't help it,' said Five, in a sulky tone; 'Seven jogged my elbow.'\n\nOn which Seven looked up and said, 'That's right, Five! Always lay the blame on others!'\n\n'You'd better not talk!' said Five. 'I heard the Queen say only yesterday you deserved to be beheaded!'\n\n'What for?' said the one who had spoken first.\n\n'That's none of your business, Two!' said Seven.\n\n'Yes, it is his business!' said Five, 'and I'll tell him—it was for bringing the cook tulip-roots instead of onions.'"
      },
      {
        "title": "CHAPTER IX. The Mock Turtle's Story",
        "content": "'You can't think how glad I am to see you again, you dear old thing!' said the Duchess, as she tucked her arm affectionately into Alice's, and they walked off together.\n\nAlice was very glad to find her in such a pleasant temper, and thought to herself that perhaps it was only the pepper that had made her so savage when they met in the kitchen.\n\n'When I'm a Duchess,' she said to herself, (not in a very hopeful tone though), 'I won't have any pepper in my kitchen at all. Soup does very well without—Maybe it's always pepper that makes people hot-tempered,' she went on, very much pleased at having found out a new kind of rule, 'and vinegar that makes them sour—and camomile that makes them bitter—and—and barley-sugar and such things that make children sweet-tempered. I only wish people knew that: then they wouldn't be so stingy about it, you know—'"
      },
      {
        "title": "CHAPTER X. The Lobster Quadrille",
        "content": "The Mock Turtle sighed deeply, and drew the back of one flapper across his eyes. He looked at Alice, and tried to speak, but for a minute or two sobs choked his voice. 'Same as if he had a bone in his throat,' said the Gryphon: and it set to work shaking him and punching him in the back. At last the Mock Turtle recovered his voice, and, with tears running down his cheeks, he went on again:—\n\n'You may not have lived much under the sea—' ('I haven't,' said Alice)—'and perhaps you were never even introduced to a lobster—' (Alice began to say 'I once tasted—' but checked herself hastily, and said 'No, never') '—so you can have no idea what a delightful thing a Lobster Quadrille is!'\n\n'No, indeed,' said Alice. 'What sort of a dance is it?'\n\n'Why,' said the Gryphon, 'you first form into a line along the sea-shore—'"
      },
      {
        "title": "CHAPTER XI. Who Stole the Tarts?",
        "content": "The King and Queen of Hearts were seated on their throne when they arrived, with a great crowd assembled about them—all sorts of little birds and beasts, as well as the whole pack of cards: the Knave was standing before them, in chains, with a soldier on each side to guard him; and near the King was the White Rabbit, with a trumpet in one hand, and a scroll of parchment in the other. In the very middle of the court was a table, with a large dish of tarts upon it: they looked so good, that it made Alice quite hungry to look at them—'I wish they'd get the trial done,' she thought, 'and hand round the refreshments!'\n\nBut there seemed to be no chance of this, so she began looking at everything about her, to pass away the time.\n\nAlice had never been in a court of justice before, but she had read about them in books, and she was quite pleased to find that she knew the name of nearly everything there. 'That's the judge,' she said to herself, 'because of his great wig.'"
      },
      {
        "title": "CHAPTER XII. Alice's Evidence",
        "content": "'Here!' cried Alice, quite forgetting in the flurry of the moment how large she had grown in the last few minutes, and she jumped up in such a hurry that she tipped over the jury-box with the edge of her skirt, upsetting all the jurymen on to the heads of the crowd below, and there they lay sprawling about, reminding her very much of a globe of goldfish she had accidentally upset the week before.\n\n'Oh, I beg your pardon!' she exclaimed in a tone of great dismay, and began picking them up again as quickly as she could, for the accident of the goldfish kept running in her head, and she had a vague sort of idea that they must be collected at once and put back into the jury-box, or they would die.\n\n'The trial cannot proceed,' said the King in a very grave voice, 'until all the jurymen are back in their proper places—all,' he repeated with great emphasis, looking hard at Alice as he said so.\n\nAlice looked at the jury-box, and saw that, in her haste, she had put the Lizard in head downwards, and the poor little thing was waving its tail about in a melancholy way, being quite unable to move. She soon got it out again, and put it right; 'not that it signifies much,' she said to herself; 'I should think it would be quite as much use in the trial one way up as the other.'"
      }
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
    final int maxCharsPerPage = 1000; // Adjust this value based on your screen size/preferences
    
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
                        // Chapter indicator
                       
                        
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
                            style: TextStyle(
                              color: const Color.fromARGB(255, 230, 230, 230),
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
                    child: Text(
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
                            "This book has been securely downloaded in your app until ${widget.expiryDate.day}/${widget.expiryDate.month}/${widget.expiryDate.year}.",
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

// Interactive Review Card Widget with like and reply functionality
class InteractiveReviewCard extends StatefulWidget {
  final ReviewModel review;
  
  const InteractiveReviewCard({
    super.key,
    required this.review,
  });
  
  @override
  State<InteractiveReviewCard> createState() => _InteractiveReviewCardState();
}

class _InteractiveReviewCardState extends State<InteractiveReviewCard> {
  late int likeCount;
  bool isLiked = false;
  bool showReplyField = false;
  final TextEditingController _replyController = TextEditingController();
  List<String> replies = [];
  
  @override
  void initState() {
    super.initState();
    likeCount = widget.review.likes;
  }
  
  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
  
  void toggleLike() {
    setState(() {
      if (isLiked) {
        likeCount--;
      } else {
        likeCount++;
      }
      isLiked = !isLiked;
    });
  }
  
  void toggleReplyField() {
    setState(() {
      showReplyField = !showReplyField;
    });
  }
  
  void addReply() {
    if (_replyController.text.isNotEmpty) {
      setState(() {
        replies.add(_replyController.text);
        _replyController.clear();
        showReplyField = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.review.userAvatarUrl),
                radius: 18,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.review.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.review.date,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.review.rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.review.comment,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              InkWell(
                onTap: toggleLike,
                child: Icon(
                  isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, 
                  color: isLiked ? Colors.blue : Colors.grey[500],
                  size: 16
                ),
              ),
              const SizedBox(width: 5),
              Text(
                likeCount.toString(),
                style: TextStyle(
                  color: isLiked ? Colors.blue : Colors.grey[500],
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: toggleReplyField,
                child: Icon(Icons.comment_outlined, color: Colors.grey[500], size: 16),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: toggleReplyField,
                child: Text(
                  "Reply",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          
          // Replies section
          if (replies.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...replies.map((reply) => Container(
              margin: const EdgeInsets.only(left: 20, top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                reply,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 13,
                ),
              ),
            )),
          ],
          
          // Reply field
          if (showReplyField) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Write a reply...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addReply,
                  icon: const Icon(Icons.send, color: Color.fromARGB(255, 165, 133, 36)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Review Model
class ReviewModel {
  final String userName;
  final String userAvatarUrl;
  final String date;
  final double rating;
  final String comment;
  final int likes;
  
  ReviewModel({
    required this.userName,
    required this.userAvatarUrl,
    required this.date,
    required this.rating,
    required this.comment,
    required this.likes,
  });
}