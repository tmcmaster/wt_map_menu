import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wt_map_menu/src/definition_data.dart';
import 'package:wt_models/wt_models.dart';

class MapMenuController {
  late Provider<JsonMap> jsonMap;

  late StateNotifierProvider<JsonMapStateNotifier, JsonMap> completeJsonMap;

  late StateNotifierProvider<BreadcrumbSetStateNotifier, Set<String>> selectionSet;
  late AutoDisposeProviderFamily<bool, String> isSelected;
  late Provider<JsonMap> selectionJsonMap;

  late StateNotifierProvider<BreadcrumbSetStateNotifier, Set<String>> expandedSet;
  late AutoDisposeProviderFamily<bool, String> isExpanded;

  late StateNotifierProvider<ActiveSelectionStateNotifier, String?> activeSelection;
  late AutoDisposeProviderFamily<bool, String> isActiveSelection;

  late StateNotifierProvider<BooleanStateNotifier, bool> hideUnselected;
  late StateNotifierProvider<BooleanStateNotifier, bool> expandAll;

  MapMenuController({
    required String name,
    required AlwaysAliveProviderBase<DefinitionData> definitionDataProvider,
  }) {
    jsonMap = Provider(
      name: 'DefinitionIndex($name).jsonMap',
      (ref) => ref.watch(hideUnselected) ? ref.watch(selectionJsonMap) : ref.watch(completeJsonMap),
    );

    completeJsonMap = StateNotifierProvider<JsonMapStateNotifier, JsonMap>(
      name: 'DefinitionIndex($name).completeJsonMap',
      (ref) {
        final definitionData = ref.watch(definitionDataProvider);
        return JsonMapStateNotifier(definitionData.map);
      },
    );

    selectionJsonMap = Provider<JsonMap>(
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

    selectionSet = StateNotifierProvider<BreadcrumbSetStateNotifier, Set<String>>(
      name: 'DefinitionIndex($name).selectionSet',
      (ref) => BreadcrumbSetStateNotifier(),
    );
    isSelected = Provider.family.autoDispose<bool, String>(
      name: 'DefinitionIndex($name).isSelected.family',
      (ref, breadcrumb) {
        return ref.watch(selectionSet).contains(breadcrumb);
      },
    );

    expandedSet = StateNotifierProvider<BreadcrumbSetStateNotifier, Set<String>>(
      name: 'DefinitionIndex($name).expandedSet',
      (ref) => BreadcrumbSetStateNotifier(),
    );
    isExpanded = Provider.family.autoDispose<bool, String>(
      name: 'DefinitionIndex($name).isExpanded.family',
      (ref, breadcrumb) {
        return ref.watch(expandAll) || ref.watch(expandedSet).contains(breadcrumb);
      },
    );

    activeSelection = StateNotifierProvider<ActiveSelectionStateNotifier, String?>(
      name: 'DefinitionIndex($name).activeSelection',
      (ref) => ActiveSelectionStateNotifier(),
    );
    isActiveSelection = Provider.family.autoDispose<bool, String>(
      name: 'DefinitionIndex($name).isActiveSelection.family',
      (ref, breadcrumb) {
        return ref.watch(activeSelection) == breadcrumb;
      },
    );

    expandAll = StateNotifierProvider<BooleanStateNotifier, bool>(
      name: 'DefinitionIndex($name).expandAll',
      (ref) => BooleanStateNotifier(),
    );
    hideUnselected = StateNotifierProvider<BooleanStateNotifier, bool>(
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
