import '../../domain/entities/facets.dart';

FacetUIType _mapType(String t) => t == 'PRICE_RANGE' ? FacetUIType.priceRange : FacetUIType.list;

class FacetValueModel extends FacetValue {
  FacetValueModel({required super.id, required super.label, required super.count, required super.input});
}

class FacetGroupModel extends FacetGroup {
  FacetGroupModel({required super.id, required super.label, required super.type, required super.values});

  factory FacetGroupModel.fromGql(Map<String, dynamic> node) => FacetGroupModel(
    id: node['id'] as String,
    label: node['label'] as String,
    type: _mapType(node['type'] as String),
    values: [
      for (final v in (node['values'] as List? ?? []))
        FacetValueModel(
          id: v['id'] as String,
          label: v['label'] as String,
          count: (v['count'] as num?)?.toInt() ?? 0,
          input: v['input'] as String,
        )
    ],
  );
}
