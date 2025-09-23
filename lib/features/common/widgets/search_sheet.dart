
import 'package:flutter/material.dart';

class SearchSheet extends StatefulWidget {
  final void Function(String) onSubmit;
  const SearchSheet({super.key, required this.onSubmit});

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Buscar…',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (v) => widget.onSubmit(v),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: () => widget.onSubmit(_controller.text), child: const Text('Buscar'))
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
