import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/network/dio_client.dart';
import '../core/storage/prefs_service.dart';
import '../features/catalog/data/datasources/storefront_remote_ds.dart';
import '../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../features/catalog/domain/repositories/catalog_repository.dart';

List<SingleChildWidget> buildProviders(PrefsService prefs) => [
  Provider.value(value: prefs),
  Provider<DioClient>(create: (_) => DioClient.create()),
  ProxyProvider<DioClient, StorefrontRemoteDS>(
    update: (_, client, __) => StorefrontRemoteDS(client),
  ),
  ProxyProvider<StorefrontRemoteDS, CatalogRepository>(
    update: (_, ds, __) => CatalogRepositoryImpl(ds),
  ),
];
