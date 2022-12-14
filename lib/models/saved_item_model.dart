import 'package:news/models/source_model.dart';
final String tableItems = 'saved_items';

class SavedItemFields{
  static final List<String> values = [
    /// Add all fields
    id, author, description, urlToImage, content, title, url, publishedAt
  ];

  static final String id = "_id";
  static final String author = "author";
  static final String description = "description";
  static final String urlToImage = "urlToImage";
  static final String content = "content";
  static final String title = "title";
  static final String url = "url";
  static final String publishedAt = "publishedAt";


}

class SavedItem {


 final int? id;
 final String author;
 final String description;
  final String urlToImage;
  final String content;
  final String title;
  final  String url;
  final String publishedAt;
  
  const SavedItem({
    this.id,
    required this.author,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.title,
    required this.url,
    required this.publishedAt
  });

 SavedItem copy({
   int? id,
   String? author,
   String? description,
   String? urlToImage,
   String? content,
   String? title,
   String? url,
   String? publishedAt,
   
  }) =>
     SavedItem(
        id: id ?? this.id,
       author: author ?? this.author,
       description: description ?? this.description,
       urlToImage: urlToImage ?? this.urlToImage,
       content: content ?? this.content,
       title: title ?? this.title,
       url: url ?? this.url,
       publishedAt: publishedAt ?? this.publishedAt,
     );

  static SavedItem fromJson(Map<String, Object?> json) => SavedItem(
    id: json[SavedItemFields.id] as int?,
    author: json[SavedItemFields.author] as String,
    description: json[SavedItemFields.description] as String,
    urlToImage: json[SavedItemFields.urlToImage] as String,
    content: json[SavedItemFields.content] as String,
    title: json[SavedItemFields.title] as String,
    url: json[SavedItemFields.url] as String,
    publishedAt: json[SavedItemFields.publishedAt] as String,
  );

  Map<String, Object?> toJson() => {
    SavedItemFields.id: id,
    SavedItemFields.author: author,
    SavedItemFields.description: description,
    SavedItemFields.urlToImage: urlToImage,
    SavedItemFields.content: content,
    SavedItemFields.title: title,
    SavedItemFields.url: url,
    SavedItemFields.publishedAt: publishedAt,
  };
}