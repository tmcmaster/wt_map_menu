import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_map_menu/src/map_menu_controller.dart';
import 'package:wt_models/wt_models.dart';

class MapMenu extends ConsumerStatefulWidget {
  final String title;
  final AlwaysAliveProviderBase<JsonMap> mapProvider;
  final void Function(String? selected)? onSelection;

  const MapMenu({
    super.key,
    required this.title,
    required this.mapProvider,
    this.onSelection,
  });

  @override
  ConsumerState<MapMenu> createState() => _MapMenuState();
}

class _MapMenuState extends ConsumerState<MapMenu> {
  late MapMenuController controller;
  @override
  void initState() {
    controller = MapMenuController(
      name: 'MapMenu',
      mapProvider: widget.mapProvider,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hideUnselected = ref.watch(controller.hideUnselected);
    final map = hideUnselected
        ? ref.watch(controller.selectionJsonMap)
        : ref.read(controller.completeJsonMap);

    ref.listen(controller.activeSelection, (previous, next) {
      widget.onSelection?.call(next);
    });

    return ColoredBox(
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              _HideUnselectedToggle(
                controller: controller,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 6.0,
                  top: 1,
                ),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...map.entries.map(
                  (entry) => _SelectableItem(
                    controller: controller,
                    breadcrumb: entry.key,
                    title: entry.key,
                    value: entry.value,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _HideUnselectedToggle extends ConsumerWidget {
  final MapMenuController controller;

  const _HideUnselectedToggle({
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideUnselected = ref.watch(controller.hideUnselected);

    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: 20,
      onPressed: () {
        ref.read(controller.hideUnselected.notifier).toggle();
      },
      icon: hideUnselected
          ? const Icon(
              Icons.filter_list,
              color: Colors.orangeAccent,
            )
          : const Icon(
              Icons.list,
              color: Colors.orangeAccent,
            ),
    );
  }
}

class _SelectableItem extends ConsumerWidget {
  final MapMenuController controller;
  final String breadcrumb;
  final String title;
  final dynamic value;

  const _SelectableItem({
    required this.controller,
    required this.breadcrumb,
    required this.title,
    required this.value,
  });

  bool get isMenu => value is Map;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(controller.isSelected(breadcrumb));
    final isExpanded = ref.watch(controller.isExpanded(breadcrumb));
    final isActiveSelection = ref.watch(controller.isActiveSelection(breadcrumb));
    final hideUnselected = ref.watch(controller.hideUnselected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isMenu && !hideUnselected)
              IconButton(
                icon: isExpanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
                color: Colors.orangeAccent,
                onPressed: () {
                  if (isExpanded) {
                    ref.read(controller.expandedSet.notifier).remove(breadcrumb);
                  } else {
                    ref.read(controller.expandedSet.notifier).add(breadcrumb);
                  }
                },
              )
            else
              SizedBox(
                width: hideUnselected ? 6 : 40,
              ),
            Checkbox(
              fillColor: MaterialStateProperty.all(Colors.orangeAccent),
              visualDensity: VisualDensity.compact,
              value: isSelected,
              onChanged: (value) {
                if (isSelected) {
                  ref.read(controller.selectionSet.notifier).remove(breadcrumb);
                  if (isActiveSelection) {
                    ref.read(controller.activeSelection.notifier).setSelection(null);
                  }
                } else {
                  ref.read(controller.selectionSet.notifier).add(breadcrumb);
                }
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Container(
              decoration: BoxDecoration(
                color: isActiveSelection ? Colors.grey.shade300 : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 8, left: 10, right: 10),
                child: isSelected
                    ? InkWell(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          if (isActiveSelection) {
                            ref.read(controller.activeSelection.notifier).setSelection(null);
                          } else {
                            ref.read(controller.activeSelection.notifier).setSelection(breadcrumb);
                          }
                        },
                      )
                    : Text(title),
              ),
            ),
          ],
        ),
        if (isExpanded && value is Map)
          Container(
            padding: const EdgeInsets.only(left: 10),
            // decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: (value as JsonMap)
                  .entries
                  .map(
                    (entry) => _SelectableItem(
                      controller: controller,
                      breadcrumb: breadcrumb.isEmpty ? entry.key : '$breadcrumb : ${entry.key}',
                      title: entry.key,
                      value: entry.value,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
