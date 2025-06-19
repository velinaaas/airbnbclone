// Model untuk single review
class Review {
  final int idReview;
  final int propertyId;
  final int userId;
  final int bookingId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? userName; // Optional karena mungkin tidak selalu ada

  Review({
    required this.idReview,
    required this.propertyId,
    required this.userId,
    required this.bookingId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.userName,
  });

  // Factory constructor untuk parsing dari JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      idReview: json['id_review'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      bookingId: json['booking_id'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      userName: json['user_name'], // Dari JOIN dengan tabel users
    );
  }

  // Method untuk convert ke JSON (jika diperlukan)
  Map<String, dynamic> toJson() {
    return {
      'id_review': idReview,
      'property_id': propertyId,
      'user_id': userId,
      'booking_id': bookingId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'user_name': userName,
    };
  }
}

// Model untuk response API yang berisi list reviews
class ReviewResponse {
  final List<Review> reviews;

  ReviewResponse({required this.reviews});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    var reviewList = json['reviews'] as List;
    List<Review> reviews = reviewList.map((reviewJson) => Review.fromJson(reviewJson)).toList();
    
    return ReviewResponse(reviews: reviews);
  }
}

// Model untuk statistik review (optional, jika API mengembalikan statistik)
class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count

  ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewStats.fromReviews(List<Review> reviews) {
    if (reviews.isEmpty) {
      return ReviewStats(
        averageRating: 0.0,
        totalReviews: 0,
        ratingDistribution: {},
      );
    }

    double totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    double averageRating = totalRating / reviews.length;

    Map<int, int> distribution = {};
    for (var review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }

    return ReviewStats(
      averageRating: averageRating,
      totalReviews: reviews.length,
      ratingDistribution: distribution,
    );
  }
}