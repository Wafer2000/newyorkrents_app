
import 'package:flutter/material.dart';

class MobileMenuSheet extends StatelessWidget {
  final List<String> items;
  final void Function(String) onSelect;
  const MobileMenuSheet({super.key, required this.items, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 4, width: 36, margin: const EdgeInsets.only(bottom: 8), alignment: Alignment.center,
              child: Container(height: 4, width: 36, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2)))),
            for (final h in items) ListTile(
              title: Text(h, style: const TextStyle(fontWeight: FontWeight.w600)),
              onTap: () => onSelect(h),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
