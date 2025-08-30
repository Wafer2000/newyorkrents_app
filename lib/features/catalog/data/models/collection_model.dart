import '../../domain/entities/collection.dart';

class CollectionModel extends CollectionEntity {
  CollectionModel({required super.id, required super.title, required super.handle, super.imageUrl});

  factory CollectionModel.fromGql(Map<String, dynamic> node) {
    final img = node['image'] as Map<String, dynamic>?;
    return CollectionModel(
      id: node['id'] as String,
      title: node['title'] as String,
      handle: node['handle'] as String,
      imageUrl: img?['url'] as String?,
    );
  }
}
