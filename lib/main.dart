import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_tumbleblog/logic/post_cubit.dart';
import 'package:last_tumbleblog/pages/home.page.dart';

void main() {
  runApp(const BlogApp());
}

class BlogApp extends StatefulWidget {
  const BlogApp({super.key});

  @override
  State<BlogApp> createState() => _BlogAppState();
}

class _BlogAppState extends State<BlogApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        title: 'Ojos - TumbleBlog',
        home: BlocProvider(
          create: (context) => PostCubit()..getAllPosts(),
          child: const HomePage(),
        ),
      );
}
