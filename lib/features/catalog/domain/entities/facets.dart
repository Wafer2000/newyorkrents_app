enum FacetUIType { list, priceRange }

class FacetValue {
  final String id;    // e.g. "filter.p.tag.rooms"
  final String label; // visible label
  final int count;
  final String input; // JSON string that matches ProductFilter
  FacetValue({required this.id, required this.label, required this.count, required this.input});
}

class FacetGroup {
  final String id;        // e.g. "filter.p.tag"
  final String label;     // e.g. "Tags"
  final FacetUIType type; // LIST / PRICE_RANGE
  final List<FacetValue> values;
  FacetGroup({required this.id, required this.label, required this.type, required this.values});
}
