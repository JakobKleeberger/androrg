import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditorPageState();
  }
}

class _EditorPageState extends State<EditorPage> {
  QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          QuillSimpleToolbar(
            controller: _controller,
            config: QuillSimpleToolbarConfig(),
          ),
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              config: QuillEditorConfig(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
