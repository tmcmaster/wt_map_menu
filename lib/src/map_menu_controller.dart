import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_models/wt_models.dart';

class MapMenuController {
  late AutoDisposeProvider<JsonMap> jsonMap;

  late AutoDisposeStateNotifierProvider<JsonMapStateNotifier, JsonMap> completeJsonMap;

  late AutoDisposeStateNotifierProvider<BreadcrumbSetStateNotifier, Set<String>> selectionSet;
  late AutoDisposeProviderFamily<bool, String> isSelected;
  late AutoDisposeProvider<JsonMap> selectionJsonMap;

  late AutoDisposeStateNotifierProvider<BreadcrumbSetStateNotifier, Set<String>> expandedSet;
  late AutoDisposeProviderFamily<bool, String> isExpanded;

  late AutoDisposeStateNotifierProvider<ActiveSelectionStateNotifier, String?> activeSelection;
  late AutoDisposeProviderFamily<bool, String> isActiveSelection;

  late AutoDisposeStateNotifierProvider<BooleanStateNotifier, bool> hideUnselected;
  late AutoDisposeStateNotifierProvider<BooleanStateNotifier, bool> expandAll;

  MapMenuController({
    required String name,
    required AlwaysAliveProviderBase<JsonMap> mapProvider,
  }) {
    jsonMap = Provider.autoDispose(
      name: 'DefinitionIndex($name).jsonMap',
      (ref) => ref.watch(hideUnselected) ? ref.watch(selectionJsonMap) : ref.watch(completeJsonMap),
    );

    completeJsonMap = StateNotifierProvider.autoDispose<JsonMapStateNotifier, JsonMap>(
      name: 'DefinitionIndex($name).completeJsonMap',
      (ref) {
        final map = ref.watch(mapProvider);
        return JsonMapStateNotifier(map);
      },
    );

    selectionJsonMap = Provider.autoDispose<JsonMap>(
      name: 'DefinitionIndex($name).selectionJsonMap',
      (ref) {
        final set = ref.watch(selectionSet);
        final newMap = <String, dynamic>{};
        for (final breadcrumb in set) {
          final parts = breadcrumb.split(' : ');
          JsonMap mapPointer = newMap;
          for (int p = 0; p < parts.length; p++) {
            final part = parts[p];
            final isLast = p == parts.length - 1;
            if (!mapPointer.containsKey(part)) {
              mapPointer[part] = <String, void>{};
            }
            if (isLast) {
              break;
            }
            mapPointer = mapPointer[part] as JsonMap;
          }
        }
        return newMap;
      },
    );

    selectionSet = StateNotifierProvider.autoDispose<BreadcrumbSetStateNotifier, Set<String>>(
      name: 'DefinitionIndex($name).selectionSet',
      (ref) => BreadcrumbSetStateNotifier(),
    );
    isSelected = Provider.family.autoDispose<bool, String>(
      name: 'DefinitionIndex($name).isSelected.family',
      (ref, breadcrumb) {
        return ref.watch(selectionSet).contains(breadcrumb);
      },
    );

    expandedSet = StateNotifierProvider.autoDispose<BreadcrumbSetStateNotifier, Set<String>>(
      name: 'DefinitionIndex($name).expandedSet',
      (ref) => BreadcrumbSetStateNotifier(),
    );
    isExpanded = Provider.family.autoDispose<bool, String>(
      name: 'DefinitionIndex($name).isExpanded.family',
      (ref, breadcrumb) {
        return ref.watch(expandAll) || ref.watch(expandedSet).contains(breadcrumb);
      },
    );

    activeSelection = StateNotifierProvider.autoDispose<ActiveSelectionStateNotifier, String?>(
      name: 'DefinitionIndex($name).activeSelection',
      (ref) => ActiveSelectionStateNotifier(),
    );
    isActiveSelection = Provider.family.autoDispose<bool, String>(
      name: 'DefinitionIndex($name).isActiveSelection.family',
      (ref, breadcrumb) {
        return ref.watch(activeSelection) == breadcrumb;
      },
    );

    expandAll = StateNotifierProvider.autoDispose<BooleanStateNotifier, bool>(
      name: 'DefinitionIndex($name).expandAll',
      (ref) => BooleanStateNotifier(),
    );
    hideUnselected = StateNotifierProvider.autoDispose<BooleanStateNotifier, bool>(
      name: 'DefinitionIndex($name).hideUnSelected',
      (ref) => BooleanStateNotifier(),
    );
  }
}

class JsonMapStateNotifier extends StateNotifier<JsonMap> {
  JsonMapStateNotifier(super.state);
}

class ActiveSelectionStateNotifier extends StateNotifier<String?> {
  ActiveSelectionStateNotifier() : super(null);

  // ignore: use_setters_to_change_properties
  void setSelection(String? selection) {
    state = selection;
  }
}

class BooleanStateNotifier extends StateNotifier<bool> {
  BooleanStateNotifier() : super(false);
  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}

class BreadcrumbSetStateNotifier extends StateNotifier<Set<String>> {
  static const initialState = {
    'Concepts',
    'Concepts : Language Fundamentals',
    'Domains',
    'Domains : Automotive',
  };

  BreadcrumbSetStateNotifier() : super({});

  void add(String item) {
    state = {
      ...state,
      item,
    };
  }

  void remove(String item) {
    state = state.where((e) => e != item).toSet();
  }
}
