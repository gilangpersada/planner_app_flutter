class Category {
  final String id;
  final String title;
  final int color;

  Category({this.id, this.title, this.color});

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id ?? '',
      title: map['category_name'] ?? '',
      color: map['color'] ?? '',
    );
  }
}
