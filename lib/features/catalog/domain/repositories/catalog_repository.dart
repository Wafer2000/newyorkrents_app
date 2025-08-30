
import 'package:newyorkrents_app/features/catalog/domain/entities/facets.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/product.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/product_detail.dart';

class CollectionPageResult {
  final List<ProductEntity> items;
  final bool hasNextPage;
  final String? lastCursor;
  CollectionPageResult({required this.items, required this.hasNextPage, required this.lastCursor});
}

abstract class CatalogRepository {
  Future<CollectionPageResult> fetchCollectionProducts({
    required String handle,
    required int first,
    String? after,
    required String sortKey,
    required bool reverse,
    List<Map<String, dynamic>>? filters,
  });

  Future<List<FacetGroup>> fetchAvailableFacets({required String handle});

  // 👇 NUEVO
  Future<ProductDetailEntity> fetchProductDetail({required String handle});
}
