import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last_tumbleblog/config/editor_embed_builder.dart';
import 'package:last_tumbleblog/config/launch_url.dart';
import 'package:last_tumbleblog/logic/post_cubit.dart';
import 'package:parchment_delta/parchment_delta.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  final FocusNode _focusNode = FocusNode();
  FleatherController? _controller;

  @override
  void initState() {
    super.initState();
    // if (kIsWeb) BrowserContextMenu.disableContextMenu();
    _initController();
  }

  @override
  void dispose() {
    super.dispose();
    // if (kIsWeb) BrowserContextMenu.enableContextMenu();
  }

  Future<void> _initController() async {
    // try {
    //   final result = await rootBundle.loadString('assets/welcome.json');
    //   final heuristics = ParchmentHeuristics(
    //     formatRules: [],
    //     insertRules: [
    //       ForceNewlineForInsertsAroundInlineImageRule(),
    //     ],
    //     deleteRules: [],
    //   ).merge(ParchmentHeuristics.fallback);
    //   final doc = ParchmentDocument.fromJson(
    //     jsonDecode(result),
    //     heuristics: heuristics,
    //   );
    //   _controller = FleatherController(document: doc);
    // } catch (err, st) {
    //   log(name: 'Cannot read welcome.json: ', '$err\n$st');
    //   _controller = FleatherController();
    // }
    // setState(() {});
    _controller = FleatherController();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const CircularProgressIndicator(
            color: Colors.purple,
          );
        }
        return Scaffold(
          appBar: AppBar(elevation: 0, title: const Text('Editor')),
          body: _controller == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                )
              : Column(
                  children: [
                    // IgnorePointer(
                    //   child:
                    FleatherToolbar.basic(
                      controller: _controller!,
                      hideDirection: true,
                      hideCodeBlock: true,
                      leading: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          onPressed: _controller != null
                              ? () async {
                                  print('ANDERSON --- ${_controller?.document.toJson()}');
                                  final postCreated = await context
                                      .read<PostCubit>()
                                      .createPost(jsonEncode(_controller!.document.toJson()));

                                  if (postCreated) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                              : null,
                          child: const Text(
                            'publish',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          onPressed: () {},
                          child: const Text('draft'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: () async {
                            try {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                final selection = _controller!.selection;
                                _controller!.replaceText(
                                  selection.baseOffset,
                                  selection.extentOffset - selection.baseOffset,
                                  EmbeddableObject('image', inline: false, data: {
                                    'source_type': kIsWeb ? 'url' : 'file',
                                    'source': image.path,
                                  }),
                                );
                                _controller!.replaceText(
                                  selection.baseOffset + 1,
                                  0,
                                  '\n',
                                  selection: TextSelection.collapsed(offset: selection.baseOffset + 2),
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
                      trailing: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade200,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          onPressed: () {
                            _controller = FleatherController();
                            setState(() {});
                          },
                          child: const Text(
                            'cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    // ),
                    Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                    Expanded(
                      child: FleatherEditor(
                        controller: _controller!,
                        focusNode: _focusNode,
                        padding: EdgeInsets.only(
                          top: 28,
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        onLaunchUrl: launchUrlHelper,
                        maxContentWidth: 800,
                        embedBuilder: embedBuilder,
                        spellCheckConfiguration: SpellCheckConfiguration(
                          spellCheckService: DefaultSpellCheckService(),
                          misspelledSelectionColor: Colors.red,
                          misspelledTextStyle: DefaultTextStyle.of(context).style,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// This is an example insert rule that will insert a new line before and
/// after inline image embed.
class ForceNewlineForInsertsAroundInlineImageRule extends InsertRule {
  @override
  Delta? apply(Delta document, int index, Object data) {
    if (data is! String) return null;

    final iter = DeltaIterator(document);
    final previous = iter.skip(index);
    final target = iter.next();
    final cursorBeforeInlineEmbed = _isInlineImage(target.data);
    final cursorAfterInlineEmbed = previous != null && _isInlineImage(previous.data);

    if (cursorBeforeInlineEmbed || cursorAfterInlineEmbed) {
      final delta = Delta()..retain(index);
      if (cursorAfterInlineEmbed && !data.startsWith('\n')) {
        delta.insert('\n');
      }
      delta.insert(data);
      if (cursorBeforeInlineEmbed && !data.endsWith('\n')) {
        delta.insert('\n');
      }
      return delta;
    }
    return null;
  }

  bool _isInlineImage(Object data) {
    if (data is EmbeddableObject) {
      return data.type == 'image' && data.inline;
    }
    if (data is Map) {
      return data[EmbeddableObject.kTypeKey] == 'image' && data[EmbeddableObject.kInlineKey];
    }
    return false;
  }
}
