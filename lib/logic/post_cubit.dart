import 'package:bloc/bloc.dart';
import 'package:last_tumbleblog/local_storage.dart';
import 'package:last_tumbleblog/post.local.datasource.dart';
import 'package:last_tumbleblog/post.model.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostLocalDataSource dataSource = PostLocalDataSource(
    storage: LocalStorage(),
  );

  final List<Post> posts = [];

  PostCubit() : super(PostInitial());

  Future<bool> createPost(
    String document, {
    List<Tag> tags = const [],
    bool visible = true,
  }) async {
    emit(PostLoading());
    final Post post = Post(
      id: idGenerator(),
      data: document,
      tags: tags,
      visible: visible,
    );

    emit(PostInitial());
    return await dataSource.createPost(post: post);
  }

  getAllPosts() async {
    emit(PostLoading());
    print('test');

    posts.addAll(await dataSource.getAllPosts());
    emit(PostInitial());
  }
}
