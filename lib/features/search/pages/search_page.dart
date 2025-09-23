import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final String q;
  const SearchPage({super.key, required this.q});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar: $q')),
      body: const Center(child: Text('Resultados próximamente')),
    );
  }
}
