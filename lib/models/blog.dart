class Blog {
  String id, userId, title, desc, name;
  DateTime createdAt;
  String? imageUrl; // New field for image URL

  Blog({
    required this.id,
    required this.userId,
    required this.title,
    required this.desc,
    required this.name,
    required this.createdAt,
    this.imageUrl,
  });

  factory Blog.fromMap(map) {
    return Blog(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      desc: map['desc'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'desc': desc,
      'name': name,
      'createdAt': createdAt.toString(),
      'imageUrl': imageUrl,
    };
  }
}
