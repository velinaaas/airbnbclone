import 'dart:convert';
import 'package:airbnbclone/views/booking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailPropertyPage extends StatefulWidget {
  final int propertyId;

  const DetailPropertyPage({
    Key? key,
    required this.propertyId,
  }) : super(key: key);

  @override
  State<DetailPropertyPage> createState() => _DetailPropertyPageState();
}

class _DetailPropertyPageState extends State<DetailPropertyPage> with TickerProviderStateMixin {
  Map<String, dynamic>? propertyData;
  List<Map<String, dynamic>> reviews = [];
  bool isLoading = true;
  bool isLoadingReviews = true;
  String? errorMessage;
  String? reviewErrorMessage;
  PageController _pageController = PageController();
  int _currentPhotoIndex = 0;
  bool isFavorite = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    fetchPropertyData();
    fetchReviews();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchPropertyData() async {
    final url = Uri.parse(
      'https://apiairbnb-production.up.railway.app/api/guest/properties/${widget.propertyId}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          propertyData = jsonDecode(response.body);
          isLoading = false;
          errorMessage = null;
        });
        _animationController.forward();
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Gagal memuat data properti (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  Future<void> fetchReviews() async {
  print('🔍 Fetching reviews for property ID: ${widget.propertyId}');
  
  final url = Uri.parse(
    'https://apiairbnb-production.up.railway.app/api/guest/properties/${widget.propertyId}/reviews',
  );

  try {
    print('📡 Making request to: $url');
    final response = await http.get(url);
    
    print('📥 Response status code: ${response.statusCode}');
    print('📥 Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('✅ Parsed response data: $responseData');
      
      // Coba beberapa struktur data yang mungkin
      List<Map<String, dynamic>> reviewsList = [];
      
      if (responseData is Map<String, dynamic>) {
        // Jika response berupa object dengan key 'data'
        if (responseData.containsKey('data') && responseData['data'] is List) {
          reviewsList = List<Map<String, dynamic>>.from(responseData['data']);
          print('📋 Found reviews in data key: ${reviewsList.length} reviews');
        }
        // Jika response berupa object dengan key 'reviews'
        else if (responseData.containsKey('reviews') && responseData['reviews'] is List) {
          reviewsList = List<Map<String, dynamic>>.from(responseData['reviews']);
          print('📋 Found reviews in reviews key: ${reviewsList.length} reviews');
        }
        // Jika response langsung berupa object yang berisi review fields
        else if (responseData.containsKey('id_review') || responseData.containsKey('rating') || responseData.containsKey('comment')) {
          reviewsList = [Map<String, dynamic>.from(responseData)];
          print('📋 Found single review object: 1 review');
        }
      }
      // Jika response langsung berupa array
      else if (responseData is List) {
        reviewsList = List<Map<String, dynamic>>.from(responseData);
        print('📋 Found direct array: ${reviewsList.length} reviews');
      }
      
      // Log setiap review untuk debugging
      for (int i = 0; i < reviewsList.length; i++) {
        print('📝 Review $i: ${reviewsList[i]}');
      }
      
      setState(() {
        reviews = reviewsList;
        isLoadingReviews = false;
        reviewErrorMessage = null;
      });
      
      print('✅ Successfully loaded ${reviews.length} reviews');
    } else {
      print('❌ Error response: ${response.statusCode} - ${response.body}');
      setState(() {
        isLoadingReviews = false;
        reviewErrorMessage = 'Gagal memuat review (${response.statusCode}): ${response.body}';
      });
    }
  } catch (e, stackTrace) {
    print('💥 Exception occurred: $e');
    print('📚 Stack trace: $stackTrace');
    setState(() {
      isLoadingReviews = false;
      reviewErrorMessage = 'Terjadi kesalahan saat memuat review: $e';
    });
  }
}

  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    double total = reviews.fold(0.0, (sum, review) => sum + (review['rating']?.toDouble() ?? 0.0));
    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink.shade50, Colors.orange.shade50],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Memuat Detail Properti...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.shade50, Colors.orange.shade50],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                          SizedBox(height: 16),
                          Text(
                            'Oops! Terjadi Kesalahan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            errorMessage!,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });
                        fetchPropertyData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5A5F),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                      ),
                      child: Text('Coba Lagi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final data = propertyData!;
    final photos = (data['photos'] as List).map((photo) => photo['image_url'] as String).toList();

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.share, color: Colors.white),
                    onPressed: () => _shareProperty(data),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        key: ValueKey(isFavorite),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildPhotoSlider(photos),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property Title & Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['title'] ?? 'Judul tidak tersedia',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        data['address'] ?? 'Alamat tidak tersedia',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  averageRating > 0 ? averageRating.toStringAsFixed(1) : '4.8',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Property Details Cards
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard(Icons.people, '${data['max_guests'] ?? 0}', 'Tamu')),
                          SizedBox(width: 12),
                          Expanded(child: _buildInfoCard(Icons.bed, '${data['bedrooms'] ?? 0}', 'Kamar Tidur')),
                          SizedBox(width: 12),
                          Expanded(child: _buildInfoCard(Icons.bathtub, '${data['bathrooms'] ?? 0}', 'Kamar Mandi')),
                        ],
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Host Information Card
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue.shade50, Colors.purple.shade50],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  'https://tse2.mm.bing.net/th/id/OIP.34dslCyrK7Nh4zqQf9lxwAHaE8?cb=iwc2&rs=1&pid=ImgDetMain',
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tuan Rumah',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    data['host_name'] ?? 'Tidak diketahui',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    data['host_email'] ?? 'Email tidak tersedia',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF25D366).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () => _openWhatsApp(
                                  data['phone_number'] ?? '+6281933773092',
                                  data['host_name'] ?? 'Host',
                                  data['title'] ?? 'Properti'
                                ),
                                icon: Icon(Icons.chat_bubble, color: Colors.white, size: 22),
                                tooltip: 'Chat WhatsApp',
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Description Section
                      Text(
                        'Tentang Properti Ini',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          data['description'] ?? 'Deskripsi tidak tersedia',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Reviews Section
                      _buildReviewsSection(),
                      
                      SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harga per malam',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Rp${_formatPrice(data['price_per_night'])}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:const Color(0xFFFF5A5F),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFFF5A5F), Colors.purple.shade400],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color:const Color(0xFFFF5A5F),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookingPage(propertyId: widget.propertyId)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Review & Rating',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Spacer(),
            if (!isLoadingReviews && reviews.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${averageRating.toStringAsFixed(1)} (${reviews.length})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 16),
        
        if (isLoadingReviews)
          Container(
            padding: EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFFF5A5F)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat review...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else if (reviewErrorMessage != null)
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade400),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    reviewErrorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoadingReviews = true;
                      reviewErrorMessage = null;
                    });
                    fetchReviews();
                  },
                  child: Text('Coba Lagi'),
                ),
              ],
            ),
          )
        else if (reviews.isEmpty)
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey.shade400),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada review',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jadilah yang pertama memberikan review!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              ...reviews.take(3).map((review) => _buildReviewCard(review)),
              if (reviews.length > 3)
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: TextButton(
                    onPressed: () => _showAllReviews(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5A5F).withOpacity(0.1),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Lihat semua ${reviews.length} review',
                      style: TextStyle(
                        color: const Color(0xFFFF5A5F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
  print('Building review card with data: $review');
  
  // Handle berbagai kemungkinan nama field
  final rating = (review['rating'] ?? review['rating_value'] ?? 0).toDouble();
  final comment = review['comment'] ?? review['review_text'] ?? review['description'] ?? '';
  
  // Handle nama guest dengan berbagai kemungkinan field
  String guestName = 'Anonim';
  if (review['guest_name'] != null && review['guest_name'].toString().isNotEmpty) {
    guestName = review['guest_name'].toString();
  } else if (review['user_name'] != null && review['user_name'].toString().isNotEmpty) {
    guestName = review['user_name'].toString();
  } else if (review['name'] != null && review['name'].toString().isNotEmpty) {
    guestName = review['name'].toString();
  }
  
  // Handle tanggal dengan berbagai kemungkinan field
  String createdAt = review['created_at'] ?? review['date'] ?? review['review_date'] ?? '';
  
  DateTime? reviewDate;
  try {
    if (createdAt.isNotEmpty) {
      reviewDate = DateTime.parse(createdAt);
    }
  } catch (e) {
    print('⚠️ Failed to parse date: $createdAt - $e');
    reviewDate = null;
  }

  return Container(
    margin: EdgeInsets.only(bottom: 16),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 2),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFF5A5F).withOpacity(0.1),
                child: Text(
                  guestName.isNotEmpty ? guestName[0].toUpperCase() : 'A',
                  style: TextStyle(
                    color: const Color(0xFFFF5A5F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guestName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  if (reviewDate != null)
                    Text(
                      _formatDate(reviewDate),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    )
                  else if (createdAt.isNotEmpty)
                    Text(
                      createdAt,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 2),
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (comment.isNotEmpty) ...[
          SizedBox(height: 12),
          Text(
            comment,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
        SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) => Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 16,
          )),
        ),
        // Debug info (hapus setelah berhasil)
        if (true) // Set ke false setelah debugging selesai
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'DEBUG: ${review.toString()}',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ),
      ],
    ),
  );
}

// Juga tambahkan button untuk force refresh reviews di UI
Widget _buildDebugRefreshButton() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 16),
    child: ElevatedButton.icon(
      onPressed: () {
        print('🔄 Manual refresh reviews triggered');
        setState(() {
          isLoadingReviews = true;
          reviewErrorMessage = null;
          reviews.clear();
        });
        fetchReviews();
      },
      icon: Icon(Icons.refresh),
      label: Text('Debug: Refresh Reviews'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
  );
}

void _showAllReviews() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      'Semua Review',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${averageRating.toStringAsFixed(1)} (${reviews.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[800],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[200]),
              // Reviews list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildReviewCard(reviews[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSlider(List<String> photos) {
    if (photos.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 64, color: Colors.grey[400]),
              SizedBox(height: 8),
              Text(
                'Tidak ada foto tersedia',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPhotoIndex = index;
            });
          },
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(photos[index]),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    // Handle image loading error
                  },
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            );
          },
        ),
        if (photos.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: photos.asMap().entries.map((entry) {
                int index = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPhotoIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        if (photos.length > 1)
          Positioned(
            bottom: 40,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(
                '${_currentPhotoIndex + 1}/${photos.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5A5F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF5A5F),
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0';
    
    try {
      int priceInt = int.parse(price.toString());
      String priceStr = priceInt.toString();
      
      // Add thousand separators
      String result = '';
      for (int i = 0; i < priceStr.length; i++) {
        if (i > 0 && (priceStr.length - i) % 3 == 0) {
          result += '.';
        }
        result += priceStr[i];
      }
      
      return result;
    } catch (e) {
      return price.toString();
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _shareProperty(Map<String, dynamic> data) {
    // Implement share functionality
    final String shareText = '''
🏠 ${data['title'] ?? 'Properti Airbnb'}

📍 ${data['address'] ?? 'Alamat tidak tersedia'}
💰 Rp${_formatPrice(data['price_per_night'])}/malam
⭐ Rating: ${averageRating > 0 ? averageRating.toStringAsFixed(1) : '4.8'}

👥 Maks ${data['max_guests'] ?? 0} tamu
🛏️ ${data['bedrooms'] ?? 0} kamar tidur  
🛁 ${data['bathrooms'] ?? 0} kamar mandi

${data['description'] ?? ''}

Pesan sekarang di aplikasi kami!
    ''';
    
    // Here you would typically use share_plus package
    // Share.share(shareText);
    
    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur berbagi akan segera tersedia'),
        backgroundColor: const Color(0xFFFF5A5F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openWhatsApp(String phoneNumber, String hostName, String propertyTitle) async {
    String cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (!cleanPhoneNumber.startsWith('+')) {
      if (cleanPhoneNumber.startsWith('0')) {
        cleanPhoneNumber = '+62${cleanPhoneNumber.substring(1)}';
      } else if (cleanPhoneNumber.startsWith('62')) {
        cleanPhoneNumber = '+$cleanPhoneNumber';
      } else {
        cleanPhoneNumber = '+62$cleanPhoneNumber';
      }
    }

    final message = Uri.encodeComponent(
      'Halo $hostName! 👋\n\n'
      'Saya tertarik dengan properti Anda: "$propertyTitle"\n\n'
      'Bisakah Anda memberikan informasi lebih lanjut mengenai:\n'
      '• Ketersediaan tanggal\n'
      '• Fasilitas yang tersedia\n'
      '• Kebijakan booking\n\n'
      'Terima kasih! 🙏'
    );

    final whatsappUrl = 'https://wa.me/$cleanPhoneNumber?text=$message';

    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        // Fallback to regular phone call or SMS
        final phoneUrl = 'tel:$cleanPhoneNumber';
        if (await canLaunch(phoneUrl)) {
          await launch(phoneUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tidak dapat membuka WhatsApp atau telepon'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat membuka WhatsApp'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}