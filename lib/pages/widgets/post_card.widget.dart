import 'dart:convert';
import 'dart:developer';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:tmo_tumbleblog/config/editor_embed_builder.dart';
import 'package:tmo_tumbleblog/config/launch_url.dart';
import 'package:tmo_tumbleblog/pages/editor.page.dart';

class PostCard extends StatefulWidget {
  final String content;

  const PostCard({
    super.key,
    required this.content,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  FleatherController? _controller;

  @override
  void initState() {
    super.initState();
    // if (kIsWeb) BrowserContextMenu.disableContextMenu();
    _initController();
  }

  Future<void> _initController() async {
    try {
      // final result = await rootBundle.loadString('assets/welcome.json');
      final result = widget.content;
      print('anderson --- doc -> ${result[0]}');

      final heuristics = ParchmentHeuristics(
        formatRules: [],
        insertRules: [
          ForceNewlineForInsertsAroundInlineImageRule(),
        ],
        deleteRules: [],
      ).merge(ParchmentHeuristics.fallback);
      final doc = ParchmentDocument.fromJson(
        jsonDecode(result),
        heuristics: heuristics,
      );
      _controller = FleatherController(document: doc);
    } catch (err, st) {
      log(name: 'Cannot read - error: ', '$err');
      log(name: 'Cannot read - stack: ', '$st');
      _controller = FleatherController();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Container(
        color: Colors.grey,
        width: 300,
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 38.0, horizontal: 32),
        child: FleatherEditor(
          controller: _controller!,
          readOnly: true,
          enableInteractiveSelection: false,
          showCursor: false,
          padding: EdgeInsets.only(
            top: 28,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          onLaunchUrl: launchUrlHelper,
          maxContentWidth: 800,
          embedBuilder: embedBuilder,
        ),
      ),
    );
  }
}
