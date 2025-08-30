

import 'package:newyorkrents_app/core/config/app_env.dart';
import 'package:newyorkrents_app/core/config/metafield_config.dart';
import 'package:newyorkrents_app/core/network/dio_client.dart';
import 'package:newyorkrents_app/features/catalog/data/models/facet_models.dart';
import 'package:newyorkrents_app/features/catalog/data/models/product_detail_model.dart';
import 'package:newyorkrents_app/features/catalog/data/models/product_model.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/facets.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/product.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/product_detail.dart';

class StorefrontRemoteDS {
  final DioClient _client;
  StorefrontRemoteDS(this._client);

  // ===== Helpers para selection de metafields dinámicos =====
  String _buildMetaSelection(List<MetafieldKey> keys) {
    if (keys.isEmpty) return '';
    final buf = StringBuffer();
    for (final k in keys) {
      buf.writeln('''
        ${k.alias}: metafield(namespace: "${k.namespace}", key: "${k.key}") {
          value
          reference {
            ... on Metaobject {
              handle
              ${k.refField != null ? 'field(key: "${k.refField}") { value }' : ''}
            }
          }
        }
      ''');
    }
    return buf.toString();
  }

  String _collectionQueryWithMeta(List<MetafieldKey> keys) {
    final metaSel = _buildMetaSelection(keys);
    return '''
    query CollectionProducts(
      \$handle: String!, \$first: Int!, \$after: String,
      \$filters: [ProductFilter!], \$sortKey: ProductCollectionSortKeys!, \$reverse: Boolean!
    ) {
      collection(handle: \$handle) {
        products(first: \$first, after: \$after, sortKey: \$sortKey, reverse: \$reverse, filters: \$filters) {
          edges {
            cursor
            node {
              id
              title
              handle
              availableForSale
              featuredImage { url altText }
              priceRange { minVariantPrice { amount currencyCode } }
              $metaSel
            }
          }
          pageInfo { hasNextPage }
        }
      }
    }
    ''';
  }

  String _productDetailQueryWithMeta(List<MetafieldKey> keys) {
    final metaSel = _buildMetaSelection(keys);
    return '''
    query ProductDetail(\$handle: String!, \$imagesFirst: Int!) {
      product(handle: \$handle) {
        id
        title
        handle
        availableForSale
        descriptionHtml
        priceRange { minVariantPrice { amount currencyCode } }
        images(first: \$imagesFirst) {
          nodes { url altText }
        }
        $metaSel
      }
    }
    ''';
  }

  // ===== Listado de colección =====
  Future<({List<ProductEntity> items, bool hasNext, String? cursor})> fetchCollectionProducts({
    required String handle,
    required int first,
    String? after,
    required String sortKey,
    required bool reverse,
    List<Map<String, dynamic>>? filters,
  }) async {
    final mfKeys = MetafieldConfig.parseList(AppEnv.mfListCsv, AppEnv.mfRefMap);
    final query = _collectionQueryWithMeta(mfKeys);

    final data = await _client.postGql({
      'query': query,
      'variables': {
        'handle': handle,
        'first': first,
        'after': after,
        'filters': filters,
        'sortKey': sortKey,
        'reverse': reverse,
      }
    });

    if (data['errors'] != null) throw Exception('GraphQL errors: ${data['errors']}');
    final col = data['data']?['collection'];
    if (col == null) throw Exception('Collection not found or unpublished');

    final edges = (col['products']?['edges'] as List?) ?? [];
    final metaAliases = [for (final k in mfKeys) k.alias];

    final items = <ProductEntity>[];
    String? last;
    for (final e in edges) {
      last = e['cursor'] as String?;
      items.add(ProductModel.fromGql(e['node'] as Map<String, dynamic>, metaAliases: metaAliases));
    }
    final hasNext = (col['products']?['pageInfo']?['hasNextPage'] as bool?) ?? false;
    return (items: items, hasNext: hasNext, cursor: last);
  }

  // ===== Facets (chips oficiales de Shopify) =====
  static const _facetsQuery = r'''
  query Facets($handle: String!, $first: Int!) {
    collection(handle: $handle) {
      products(first: $first) {
        filters {
          id
          label
          type
          values { id label count input }
        }
      }
    }
  }''';

  Future<List<FacetGroup>> fetchAvailableFacets({required String handle}) async {
    final data = await _client.postGql({
      'query': _facetsQuery,
      'variables': {'handle': handle, 'first': 1}
    });
    if (data['errors'] != null) throw Exception('GraphQL errors: ${data['errors']}');
    final list = (data['data']?['collection']?['products']?['filters'] as List?) ?? [];
    return [for (final f in list) FacetGroupModel.fromGql(f as Map<String, dynamic>)];
  }

  // ===== Detalle de producto =====
  Future<ProductDetailEntity> fetchProductDetail({required String handle}) async {
    final mfKeys = MetafieldConfig.parseList(AppEnv.mfListCsv, AppEnv.mfRefMap);
    final query = _productDetailQueryWithMeta(mfKeys);
    final data = await _client.postGql({
      'query': query,
      'variables': {
        'handle': handle,
        'imagesFirst': 12,
      }
    });

    if (data['errors'] != null) throw Exception('GraphQL errors: ${data['errors']}');
    final node = data['data']?['product'];
    if (node == null) throw Exception('Product not found or unpublished');

    final metaAliases = [for (final k in mfKeys) k.alias];
    return ProductDetailModel.fromGql(node as Map<String, dynamic>, metaAliases: metaAliases);
  }
}
