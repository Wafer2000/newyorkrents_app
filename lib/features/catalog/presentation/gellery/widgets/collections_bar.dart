import 'package:flutter/material.dart';

class CollectionsBar extends StatelessWidget {
  final List<String> handles;
  final String current;
  final void Function(String) onSelect;
  const CollectionsBar({super.key, required this.handles, required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    if (handles.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: handles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final h = handles[i];
          final sel = h == current;
          return ChoiceChip(
            label: Text(h),
            selected: sel,
            onSelected: (_) => onSelect(h),
          );
        },
      ),
    );
  }
}
