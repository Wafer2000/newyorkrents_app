import 'package:flutter/material.dart';
import '../../../domain/entities/facets.dart';

typedef OnApply = void Function(List<String> inputs);

class FilterBar extends StatefulWidget {
  final List<FacetGroup> facets;
  final List<String> activeInputs;
  final OnApply onApply;
  const FilterBar({super.key, required this.facets, required this.activeInputs, required this.onApply});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late final Set<String> _selected = {...widget.activeInputs};

  @override
  Widget build(BuildContext context) {
    final tagGroups = widget.facets.where((g) => g.type == FacetUIType.list && (g.label.toLowerCase().contains('tag') || g.id.contains('.tag'))).toList();
    final groups = tagGroups.isNotEmpty ? tagGroups : widget.facets.where((g) => g.type == FacetUIType.list).toList();
    final values = groups.expand((g) => g.values).toList();
    if (values.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final v in values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(v.label),
                selected: _selected.contains(v.input),
                onSelected: (s) {
                  setState(() => s ? _selected.add(v.input) : _selected.remove(v.input));
                  widget.onApply(_selected.toList());
                },
              ),
            ),
          if (_selected.isNotEmpty)
            TextButton.icon(
              onPressed: () { setState(() => _selected.clear()); widget.onApply(const []); },
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar'),
            ),
        ],
      ),
    );
  }
}
