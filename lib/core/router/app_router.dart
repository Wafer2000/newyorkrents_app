import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newyorkrents_app/core/config/app_env.dart';
import 'package:newyorkrents_app/core/storage/prefs_service.dart';
import 'package:newyorkrents_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:newyorkrents_app/features/catalog/presentation/detail/bloc/detail_bloc.dart';
import 'package:newyorkrents_app/features/catalog/presentation/detail/bloc/detail_event.dart';
import 'package:newyorkrents_app/features/catalog/presentation/detail/pages/product_detail_page.dart';
import 'package:newyorkrents_app/features/catalog/presentation/gellery/bloc/gallery_bloc.dart';
import 'package:newyorkrents_app/features/catalog/presentation/gellery/pages/gallery_page.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static const home = '/';
  static const product = '/product/:handle';
}

class AppRouter {
  static GoRouter build(BuildContext context, PrefsService prefs) {
    final repo = Provider.of<CatalogRepository>(context, listen: false);

    return GoRouter(
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => GalleryBloc(repo: repo, prefs: prefs),
              child: GalleryPage(initialHandle: AppEnv.defaultHandle),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.product,
          builder: (context, state) {
            final handle = state.pathParameters['handle']!;
            return BlocProvider(
              create: (_) => DetailBloc(repo: repo)..add(DetailStarted(handle)),
              child: ProductDetailPage(handle: handle),
            );
          },
        ),
      ],
    );
  }
}
