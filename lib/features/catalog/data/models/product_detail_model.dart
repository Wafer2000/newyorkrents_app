
import 'package:newyorkrents_app/features/catalog/domain/entities/product_detail.dart';

class ProductDetailModel extends ProductDetailEntity {
  ProductDetailModel({
    required super.id,
    required super.title,
    required super.handle,
    required super.descriptionHtml,
    required super.images,
    required super.minPrice,
    required super.currency,
    required super.available,
    super.meta = const {},
  });

  factory ProductDetailModel.fromGql(Map<String, dynamic> node, {required List<String> metaAliases}) {
    final min = node['priceRange']?['minVariantPrice'] as Map<String, dynamic>?;
    final imgs = <String>[
      for (final n in (node['images']?['nodes'] as List? ?? [])) (n['url'] as String)
    ];

    final meta = <String, String>{};
    for (final alias in metaAliases) {
      final m = node[alias] as Map<String, dynamic>?;
      if (m == null) continue;
      final ref = m['reference'] as Map<String, dynamic>?;
      final field = ref?['field'] as Map<String, dynamic>?;
      final display = (field?['value'] as String?) ?? (m['value'] as String?);
      if (display != null && display.trim().isNotEmpty) meta[alias] = display;
    }

    return ProductDetailModel(
      id: node['id'] as String,
      title: node['title'] as String,
      handle: node['handle'] as String,
      descriptionHtml: node['descriptionHtml'] as String?,
      images: imgs,
      minPrice: (min?['amount'] as String?) ?? '0.0',
      currency: (min?['currencyCode'] as String?) ?? 'USD',
      available: (node['availableForSale'] as bool?) ?? false,
      meta: meta,
    );
  }
}
