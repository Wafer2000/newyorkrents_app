import '../repositories/catalog_repository.dart';

class GetCollectionPage {
  final CatalogRepository repo;
  GetCollectionPage(this.repo);

  Future<CollectionPageResult> call({
    required String handle,
    required int first,
    String? after,
    required String sortKey,
    required bool reverse,
    List<Map<String, dynamic>>? filters,
  }) => repo.fetchCollectionProducts(
        handle: handle, first: first, after: after, sortKey: sortKey, reverse: reverse, filters: filters,
      );
}
