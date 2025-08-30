
import 'package:newyorkrents_app/features/catalog/domain/entities/product_detail.dart';
import 'package:newyorkrents_app/features/catalog/domain/repositories/catalog_repository.dart';

class GetProductDetail {
  final CatalogRepository repo;
  GetProductDetail(this.repo);
  Future<ProductDetailEntity> call(String handle) => repo.fetchProductDetail(handle: handle);
}
