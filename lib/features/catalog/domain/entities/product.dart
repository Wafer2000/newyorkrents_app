class ProductEntity {
  final String id;
  final String title;
  final String handle;
  final String? imageUrl;
  final String minPrice;
  final String currency;
  final bool available;

  /// Metadatos dinámicos: alias -> valor para pintar
  final Map<String, String> meta; // p. ej. {'mf__custom__gender': 'Hombre', 'mf__custom__neighborhood': 'Queens'}

  ProductEntity({
    required this.id,
    required this.title,
    required this.handle,
    required this.imageUrl,
    required this.minPrice,
    required this.currency,
    required this.available,
    this.meta = const {},
  });
}
