class NewsModel {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String imageUrl;
  final String category;
  final DateTime dateTime;
  
  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.imageUrl,
    required this.category,
    required this.dateTime,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      excerpt: map['excerpt'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      dateTime: map['date'],
    );
  }
}