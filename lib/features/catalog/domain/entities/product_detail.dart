class ProductDetailEntity {
  final String id;
  final String title;
  final String handle;
  final String? descriptionHtml;
  final List<String> images;
  final String minPrice;
  final String currency;
  final bool available;
  final Map<String, String> meta; // alias -> valor legible

  ProductDetailEntity({
    required this.id,
    required this.title,
    required this.handle,
    required this.descriptionHtml,
    required this.images,
    required this.minPrice,
    required this.currency,
    required this.available,
    this.meta = const {},
  });
}
