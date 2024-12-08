class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String? author;
  final DateTime? publishedAt;
  bool isRead;
  List<String> tags;


  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    this.author,
    this.publishedAt,
    this.isRead = false,
    this.tags = const [],
  });

  // Factory constructor to create an Article from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      urlToImage: json['urlToImage'] ?? '',
      author: json['author'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      isRead: json['isRead'] ?? false,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : [], // Fetching tags from JSON
    );
  }

  // Convert an Article to JSON format
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'author': author,
      'publishedAt': publishedAt?.toIso8601String(),
      'isRead': isRead,
      'tags': tags,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Article &&
        other.title == title &&
        other.description == description &&
        other.urlToImage == urlToImage &&
        other.author == author &&
        other.publishedAt == publishedAt &&
        other.isRead == isRead &&
        other.tags == tags;
  }

  @override
  int get hashCode {
    return title.hashCode ^
    description.hashCode ^
    urlToImage.hashCode ^
    author.hashCode ^
    publishedAt.hashCode ^
    isRead.hashCode ^
    tags.hashCode;
  }


  get content => null;
}
