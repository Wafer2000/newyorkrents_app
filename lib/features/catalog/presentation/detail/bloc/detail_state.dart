import 'package:equatable/equatable.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/product_detail.dart';

enum DetailStatus { loading, ready, error }

class DetailState extends Equatable {
  final DetailStatus status;
  final ProductDetailEntity? data;
  final String? error;

  const DetailState({this.status = DetailStatus.loading, this.data, this.error});

  DetailState copyWith({DetailStatus? status, ProductDetailEntity? data, String? error}) =>
      DetailState(status: status ?? this.status, data: data ?? this.data, error: error);

  @override
  List<Object?> get props => [status, data, error];
}
