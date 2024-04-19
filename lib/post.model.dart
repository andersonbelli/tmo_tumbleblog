import 'dart:developer';

class Post {
  final String id;
  final List<Tag> tags;
  final String data;
  final bool visible;

  Post({
    required this.id,
    required this.data,
    this.tags = const [],
    this.visible = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tags': tags,
        'data': data,
        'visible': visible,
      };

  factory Post.fromJson(Map<String, dynamic> map) {
    log(name: 'post', map.toString());

    return Post(
      id: map['id'] as String,
      // tags: map['tags'] == [] ? [] : map['tags'],
      data: map['data'] as String,
      visible: map['visible'] as bool,
    );
  }
}

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

class Tag {
  final String name;
  final String color;

  Tag({
    required this.name,
    required this.color,
  });
}
