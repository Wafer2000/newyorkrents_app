import '../entities/facets.dart';
import '../repositories/catalog_repository.dart';

class GetAvailableFacets {
  final CatalogRepository repo;
  GetAvailableFacets(this.repo);
  Future<List<FacetGroup>> call({required String handle}) => repo.fetchAvailableFacets(handle: handle);
}
