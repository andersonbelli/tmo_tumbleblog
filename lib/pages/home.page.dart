import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_tumbleblog/logic/post_cubit.dart';
import 'package:last_tumbleblog/pages/editor.page.dart';
import 'package:last_tumbleblog/pages/widgets/post_card.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext _, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ojos'),
                        Text(
                          'TumbleBlog',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: const Icon(Icons.remove_red_eye_outlined),
                      onTap: () async => await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<PostCubit>(),
                            child: const EditorPage(),
                          ),
                        ),
                      ).then(
                        (_) => context.read<PostCubit>().getAllPosts(),
                      ),
                    ),
                  ),
                ],
              ),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: const _HomeContent(),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    print(context.read<PostCubit>().posts);

    final posts = context.read<PostCubit>().posts;

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        print(posts);
        return PostCard(
          content: posts[index].data,
        );
      },
    );
  }
}
