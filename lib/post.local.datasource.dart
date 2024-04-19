import 'dart:convert';

import 'package:tmo_tumbleblog/local_storage.dart';
import 'package:tmo_tumbleblog/post.model.dart';

abstract class IPostDataSource {
  Future<bool> createPost({
    required Post post,
  });

  getSinglePost({
    required String id,
  });

  Future<List<Post>> getAllPosts();
}

class PostLocalDataSource implements IPostDataSource {
  final LocalStorage storage;

  PostLocalDataSource({required this.storage});

  @override
  Future<bool> createPost({
    required Post post,
  }) async =>
      await storage.writeData(post.id, json.encode(post.toJson()));

  @override
  Future<List<Post>> getAllPosts() async {
    final localData = await storage.retrieveData();

    List<Post> postsList = [];

    localData.forEach((key, value) {
      print(value);
      postsList.add(Post.fromJson(json.decode(value)));
    });

    return postsList;
  }

  @override
  getSinglePost({required String id}) {
    // TODO: implement getPosts
    throw UnimplementedError();
  }
}
