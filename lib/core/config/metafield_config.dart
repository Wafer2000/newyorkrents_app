class MetafieldKey {
  final String namespace;
  final String key;
  final String? refField; // si referencia Metaobject, qué field mostrar
  const MetafieldKey(this.namespace, this.key, {this.refField});

  String get id => '$namespace.$key';
  String get alias => 'mf__${namespace.replaceAll('.', '_')}__${key.replaceAll('.', '_')}';
}

class MetafieldConfig {
  /// Ej: "custom.gender,custom.neighborhood"
  static List<MetafieldKey> parseList(String csv, String refMap) {
    final refs = _parseRefMap(refMap);
    return csv
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.contains('.'))
        .map((nk) {
          final parts = nk.split('.');
          final ns = parts.first;
          final k = parts.sublist(1).join('.');
          return MetafieldKey(ns, k, refField: refs['$ns.$k']);
        })
        .toList();
  }

  /// Ej: "custom.neighborhood=name,custom.barrio=title"
  static Map<String, String> _parseRefMap(String refMap) {
    final map = <String, String>{};
    for (final pair in refMap.split(',')) {
      final p = pair.trim();
      if (p.isEmpty || !p.contains('=')) continue;
      final kv = p.split('=');
      map[kv[0].trim()] = kv[1].trim();
    }
    return map;
  }
}
