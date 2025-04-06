import 'package:flutter/material.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A32),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A32),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
              onPressed: () => Navigator.pop(context),
            ),
            const Text('Books details', style: TextStyle(color: Colors.white)),
          ],
        ),
        elevation: 0,
        automaticallyImplyLeading: false, // Remove default back button
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3, // Changed to 3 books as requested
        itemBuilder: (context, index) {
          // Sample book data with adjusted data for 3 books
          final List<Map<String, dynamic>> books = [
            {
              "title": "Dracula",
              "author": "Bram Stoker",
              "coverAsset": 'assets/images/dracula.png',
              "rating": 4.8,
            },
            {
              "title": "Frankenstein",
              "author": "Mary Shelley",
              "coverAsset": 'assets/images/frankenstein.png',
              "rating": 4.6,
            },
            {
              "title": "Alice Wonderlands",
              "author": "Lewis Carroll",
              "coverAsset": 'assets/images/alice.png',
              "rating": 4.7,
            },
          ];
          
          return BookListItem(
            title: books[index]["title"],
            author: books[index]["author"],
            coverAsset: books[index]["coverAsset"],
            rating: books[index]["rating"],
            onTap: () {
              // When the book item is tapped, navigate to BookDetailsScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsScreen(
                    key: Key(books[index]["title"]), // Add a key
                    bookTitle: books[index]["title"],
                    author: books[index]["author"],
                    coverImageAsset: books[index]["coverAsset"],
                    description: "Twenty-year-old Violet Sorrengail was supposed to enter the Scribe Quadrant, living a quiet life among books and history. Now, she's forced to train as a candidate at the elite Basgiath War College, competing to become a dragon rider. Surviving means forming a telepathic connection with a deadly dragon and facing brutal training. With fewer riders every year, most cadets won't survive—or they'll drop out. But uncovering dangerous conspiracies, navigating unexpected friendships, and finding romance wasn't part of her plan. Violet must bond with a dragon or face death—and confront the plots that threaten her kingdom.",
                    rating: books[index]["rating"],
                    totalRatings: 3245,
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Book list item widget
class BookListItem extends StatelessWidget {
  final String title;
  final String author;
  final String coverAsset; // Changed from coverUrl to coverAsset
  final double rating;
  final VoidCallback onTap;

  const BookListItem({
    super.key,
    required this.title,
    required this.author,
    required this.coverAsset,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover - changed to use Asset
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                coverAsset,
                height: 120,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: 80,
                    color: Colors.grey[800],
                    child: const Icon(Icons.book, color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Book details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailsScreen extends StatefulWidget {
  final String bookTitle;
  final String author;
  final String coverImageAsset; // Changed from coverImageUrl to coverImageAsset
  final String description;
  final double rating;
  final int totalRatings;
  final List<ReviewModel> reviews;

  const BookDetailsScreen({
    required Key key, // Made key required
    required this.bookTitle,
    required this.author,
    required this.coverImageAsset,
    required this.description,
    required this.rating,
    required this.totalRatings,
    required this.reviews,
  }) : super(key: key); // Pass key to super constructor

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool showAllReviews = false;
  final ScrollController _scrollController = ScrollController();
  
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed "Start Reading" button at bottom
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 165, 133, 36),
                  foregroundColor: const Color(0xFF0A0A32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Start Reading",
                  style: TextStyle(
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