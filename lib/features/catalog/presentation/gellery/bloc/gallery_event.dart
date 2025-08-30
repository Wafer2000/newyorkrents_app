import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable { const GalleryEvent(); @override List<Object?> get props => []; }
class GalleryStarted extends GalleryEvent { final String handle; const GalleryStarted(this.handle); @override List<Object?> get props => [handle]; }
class GalleryLoadMore extends GalleryEvent { const GalleryLoadMore(); }
class GalleryApplyFilters extends GalleryEvent {
  final List<String> serializedInputs; const GalleryApplyFilters(this.serializedInputs);
  @override List<Object?> get props => [serializedInputs];
}
class GalleryClearFilters extends GalleryEvent { const GalleryClearFilters(); }
