import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newyorkrents_app/core/config/app_env.dart';
import 'package:newyorkrents_app/core/storage/prefs_service.dart';
import 'package:newyorkrents_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final CatalogRepository repo;
  final PrefsService prefs;

  GalleryBloc({required this.repo, required this.prefs}) : super(const GalleryState()) {
    on<GalleryStarted>(_onStarted);
    on<GalleryLoadMore>(_onLoadMore);
    on<GalleryApplyFilters>(_onApplyFilters);
    on<GalleryClearFilters>(_onClearFilters);
  }

  Future<void> _onStarted(GalleryStarted e, Emitter<GalleryState> emit) async {
    emit(state.copyWith(status: GalleryStatus.loading, handle: e.handle, items: [], cursor: null, activeInputs: []));
    try {
      final facets = await repo.fetchAvailableFacets(handle: e.handle);
      final page = await repo.fetchCollectionProducts(
        handle: e.handle,
        first: AppEnv.pageSize,
        sortKey: AppEnv.defaultSort,
        reverse: true,
        filters: null,
      );
      await prefs.setLastHandle(e.handle);
      emit(state.copyWith(
        status: GalleryStatus.ready,
        facets: facets,
        items: page.items,
        hasNext: page.hasNextPage,
        cursor: page.lastCursor,
      ));
    } catch (err) {
      emit(state.copyWith(status: GalleryStatus.error, error: '$err'));
    }
  }

  Future<void> _onLoadMore(GalleryLoadMore e, Emitter<GalleryState> emit) async {
    if (!state.hasNext || state.status == GalleryStatus.loading) return;
    emit(state.copyWith(status: GalleryStatus.loading));
    try {
      final filters = _toProductFilters(state.activeInputs);
      final page = await repo.fetchCollectionProducts(
        handle: state.handle,
        first: AppEnv.pageSize,
        sortKey: AppEnv.defaultSort,
        reverse: true,
        after: state.cursor,
        filters: filters,
      );
      emit(state.copyWith(
        status: GalleryStatus.ready,
        items: [...state.items, ...page.items],
        hasNext: page.hasNextPage,
        cursor: page.lastCursor,
      ));
    } catch (err) {
      emit(state.copyWith(status: GalleryStatus.error, error: '$err'));
    }
  }

  Future<void> _onApplyFilters(GalleryApplyFilters e, Emitter<GalleryState> emit) async {
    emit(state.copyWith(status: GalleryStatus.loading, activeInputs: e.serializedInputs, cursor: null, items: []));
    try {
      final filters = _toProductFilters(e.serializedInputs);
      final page = await repo.fetchCollectionProducts(
        handle: state.handle,
        first: AppEnv.pageSize,
        sortKey: AppEnv.defaultSort,
        reverse: true,
        filters: filters,
      );
      await prefs.setLastFilterInputs(jsonEncode(e.serializedInputs));
      emit(state.copyWith(
        status: GalleryStatus.ready,
        items: page.items,
        hasNext: page.hasNextPage,
        cursor: page.lastCursor,
      ));
    } catch (err) {
      emit(state.copyWith(status: GalleryStatus.error, error: '$err'));
    }
  }

  Future<void> _onClearFilters(GalleryClearFilters e, Emitter<GalleryState> emit) async {
    add(const GalleryApplyFilters([]));
  }

  List<Map<String, dynamic>>? _toProductFilters(List<String> inputs) {
    if (inputs.isEmpty) return null;
    return inputs.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }
}
