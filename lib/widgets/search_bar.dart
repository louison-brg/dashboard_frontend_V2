import 'package:flutter/material.dart';

const colDivider = SizedBox(height: 10);
const smallSpacing = 10.0;

class ComponentDecoration extends StatefulWidget {
  const ComponentDecoration({
    super.key,
    this.label = '',
    required this.child,
    this.tooltipMessage = '',
  });
  final String label;
  final Widget child;
  final String? tooltipMessage;

  @override
  State<ComponentDecoration> createState() => _ComponentDecorationState();
}

class _ComponentDecorationState extends State<ComponentDecoration> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 8.0, right: 10.0),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 510),
              child: Focus(
                focusNode: focusNode,
                canRequestFocus: true,
                child: GestureDetector(
                  onTapDown: (_) {
                    focusNode.requestFocus();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComponentGroupDecoration extends StatelessWidget {
  const ComponentGroupDecoration({super.key, required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Fully traverse this component group before moving on
    return FocusTraversalGroup(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.titleLarge),
            colDivider,
            ...children
          ],
        ),
      ),
    );
  }
}

class TextFields extends StatefulWidget {
  final Function(String) onSearch;

  const TextFields({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  final TextEditingController _controllerFilled = TextEditingController();
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft, // Aligner le contenu à gauche
      child: ComponentDecoration(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(smallSpacing),
              child: TextField(
                controller: _controllerFilled,
                onSubmitted: (value) {
                  widget.onSearch(value);
                  _isLoading = true;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: 'Sélectionnez un Youtuber',
                  filled: true,
                  contentPadding: const EdgeInsets.all(5.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

