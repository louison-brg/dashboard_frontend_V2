
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraint = 450;

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
        padding: const EdgeInsets.symmetric(vertical: smallSpacing),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.label,
                    style: Theme.of(context).textTheme.titleSmall),
                Tooltip(
                  message: widget.tooltipMessage,
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(Icons.info_outline, size: 16)),
                ),
              ],
            ),
            ConstrainedBox(
              constraints:
              const BoxConstraints.tightFor(width: widthConstraint),
              // Tapping within the a component card should request focus
              // for that component's children.
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 20.0),
                      child: Center(
                        child: widget.child,
                      ),
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
  const ComponentGroupDecoration(
      {super.key, required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Fully traverse this component group before moving on
    return FocusTraversalGroup(
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              children: [
                Text(label, style: Theme.of(context).textTheme.titleLarge),
                colDivider,
                ...children
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SearchAnchors extends StatefulWidget {
  final Function(String) onSearch;

  const SearchAnchors({
    super.key,
    required this.onSearch,
});

  @override
  State<SearchAnchors> createState() => _SearchAnchorsState();
}

class _SearchAnchorsState extends State<SearchAnchors> {
  final TextEditingController _controller = TextEditingController();

  String? selectedYoutuber;
  List<String> searchHistory = [];

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map((youtuber) => ListTile(
      leading: const Icon(Icons.history),
      title: Text(youtuber),
      trailing: IconButton(
          icon: const Icon(Icons.call_missed),
          onPressed: () {
            controller.text = youtuber;
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          }),
      onTap: () {
        controller.closeView(youtuber);
        handleSelection(youtuber);
      },
    ));
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    return searchHistory
        .where((youtuber) => youtuber.contains(input))
        .map((filteredYoutuber) => ListTile(
      leading: CircleAvatar(),
      title: Text(filteredYoutuber),
      trailing: IconButton(
          icon: const Icon(Icons.call_missed),
          onPressed: () {
            controller.text = filteredYoutuber;
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          }),
      onTap: () {
        controller.closeView(filteredYoutuber);
        handleSelection(filteredYoutuber);
      },
    ));
  }

  void handleSelection(String youtuber) {
    setState(() {
      selectedYoutuber = youtuber;
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, youtuber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ComponentDecoration(
      child: Column(
        children: <Widget>[
          SearchAnchor.bar(
            barHintText: 'Search a youtuber ',
            suggestionsBuilder: (context, controller) {
              if (controller.text.isEmpty) {
                if (searchHistory.isNotEmpty) {
                  return getHistoryList(controller);
                }
                return <Widget>[
                  const Center(
                    child: Text('No search history.',
                        style: TextStyle(color: Colors.grey)),
                  )
                ];
              }
              return getSuggestions(controller);
            },
          ),
        ],
      ),
    );
  }
}
