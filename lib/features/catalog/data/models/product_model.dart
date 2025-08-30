import '../../domain/entities/product.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.handle,
    required super.imageUrl,
    required super.minPrice,
    required super.currency,
    required super.available,
    super.meta = const {},
  });

  factory ProductModel.fromGql(
    Map<String, dynamic> node, {
    required List<String> metaAliases,
  }) {
    final featured = node['featuredImage'] as Map<String, dynamic>?;
    final min = node['priceRange']?['minVariantPrice'] as Map<String, dynamic>?;

    final meta = <String, String>{};
    for (final alias in metaAliases) {
      final m = node[alias] as Map<String, dynamic>?;
      if (m == null) continue;
      // preferimos campo del metaobject si existe
      final ref = m['reference'] as Map<String, dynamic>?;
      final field = ref?['field'] as Map<String, dynamic>?;
      final display = (field?['value'] as String?) ?? (m['value'] as String?);
      if (display != null && display.trim().isNotEmpty) {
        meta[alias] = display;
      }
    }

    return ProductModel(
      id: node['id'] as String,
      title: node['title'] as String,
      handle: node['handle'] as String,
      imageUrl: featured?['url'] as String?,
      minPrice: (min?['amount'] as String?) ?? '0.0',
      currency: (min?['currencyCode'] as String?) ?? 'USD',
      available: (node['availableForSale'] as bool?) ?? false,
      meta: meta,
    );
  }
}
