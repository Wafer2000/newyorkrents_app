import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newyorkrents_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final CatalogRepository repo;
  DetailBloc({required this.repo}) : super(const DetailState()) {
    on<DetailStarted>(_onStarted);
  }

  Future<void> _onStarted(DetailStarted e, Emitter<DetailState> emit) async {
    emit(const DetailState(status: DetailStatus.loading));
    try {
      final p = await repo.fetchProductDetail(handle: e.handle);
      emit(DetailState(status: DetailStatus.ready, data: p));
    } catch (err) {
      emit(DetailState(status: DetailStatus.error, error: '$err'));
    }
  }
}
