
import 'package:newyorkrents_app/features/catalog/data/datasources/storefront_remote_ds.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/facets.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/product_detail.dart';
import 'package:newyorkrents_app/features/catalog/domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final StorefrontRemoteDS remote;
  CatalogRepositoryImpl(this.remote);

  @override
  Future<CollectionPageResult> fetchCollectionProducts({
    required String handle,
    required int first,
    String? after,
    required String sortKey,
    required bool reverse,
    List<Map<String, dynamic>>? filters,
  }) async {
    final r = await remote.fetchCollectionProducts(
      handle: handle, first: first, after: after, sortKey: sortKey, reverse: reverse, filters: filters,
    );
    return CollectionPageResult(items: r.items, hasNextPage: r.hasNext, lastCursor: r.cursor);
  }

  @override
  Future<List<FacetGroup>> fetchAvailableFacets({required String handle}) => remote.fetchAvailableFacets(handle: handle);

  @override
  Future<ProductDetailEntity> fetchProductDetail({required String handle}) => remote.fetchProductDetail(handle: handle);
}
