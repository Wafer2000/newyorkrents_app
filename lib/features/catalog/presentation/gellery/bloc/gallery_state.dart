import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/facets.dart';

enum GalleryStatus { initial, loading, ready, error }

class GalleryState extends Equatable {
  final GalleryStatus status;
  final String handle;
  final List<ProductEntity> items;
  final bool hasNext;
  final String? cursor;
  final List<FacetGroup> facets;
  final List<String> activeInputs;
  final String? error;

  const GalleryState({
    this.status = GalleryStatus.initial,
    this.handle = '',
    this.items = const [],
    this.hasNext = true,
    this.cursor,
    this.facets = const [],
    this.activeInputs = const [],
    this.error,
  });

  GalleryState copyWith({
    GalleryStatus? status,
    String? handle,
    List<ProductEntity>? items,
    bool? hasNext,
    String? cursor,
    List<FacetGroup>? facets,
    List<String>? activeInputs,
    String? error,
  }) => GalleryState(
    status: status ?? this.status,
    handle: handle ?? this.handle,
    items: items ?? this.items,
    hasNext: hasNext ?? this.hasNext,
    cursor: cursor,
    facets: facets ?? this.facets,
    activeInputs: activeInputs ?? this.activeInputs,
    error: error,
  );

  @override
  List<Object?> get props => [status, handle, items, hasNext, cursor, facets, activeInputs, error];
}
