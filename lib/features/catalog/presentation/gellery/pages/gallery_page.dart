import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newyorkrents_app/core/config/app_env.dart';
import 'package:newyorkrents_app/core/theme/app_dimensions.dart';
import 'package:newyorkrents_app/features/catalog/presentation/gellery/bloc/gallery_bloc.dart';
import 'package:newyorkrents_app/features/catalog/presentation/gellery/bloc/gallery_event.dart';
import 'package:newyorkrents_app/features/catalog/presentation/gellery/bloc/gallery_state.dart';
import 'package:newyorkrents_app/features/catalog/presentation/gellery/widgets/collections_bar.dart';
import 'package:newyorkrents_app/features/catalog/presentation/gellery/widgets/filter_bar.dart';
import 'package:newyorkrents_app/features/catalog/presentation/gellery/widgets/gallery_grid_helper.dart' as gh;
import 'package:newyorkrents_app/features/catalog/presentation/gellery/widgets/product_card.dart';
import 'package:newyorkrents_app/features/common/widgets/app_header.dart';
import 'package:newyorkrents_app/features/common/widgets/mobile_menu_sheet.dart';
import 'package:newyorkrents_app/features/common/widgets/search_sheet.dart';

class GalleryPage extends StatefulWidget {
  final String initialHandle;
  const GalleryPage({super.key, required this.initialHandle});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    super.initState();
    context.read<GalleryBloc>().add(GalleryStarted(widget.initialHandle));
  }

  void _openMenu() {
    final items = AppEnv.collectionHandles;
    if (items.isEmpty) return;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => MobileMenuSheet(
        items: items,
        onSelect: (h) {
          Navigator.pop(context);
          context.read<GalleryBloc>().add(GalleryStarted(h));
        },
      ),
    );
  }

  void _openSearch() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => SearchSheet(
        onSubmit: (q) {
          Navigator.pop(context);
          if (q.trim().isNotEmpty) context.push('/search/$q');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        onMenu: _openMenu,
        onSearch: _openSearch,
        onCart: () { /* TODO: navegar a /cart si lo habilitas */ },
        // logo: Image.asset('assets/logo.png', height: 22), // opcional
      ),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, s) {
          if (s.status == GalleryStatus.loading && s.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.status == GalleryStatus.error) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('No se pudo cargar', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(s.error ?? ''),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.read<GalleryBloc>().add(GalleryStarted(s.handle.isEmpty ? widget.initialHandle : s.handle)),
                  child: const Text('Reintentar'),
                ),
              ]),
            );
          }

          final all = AppEnv.collectionHandles;
          final currentHandle = (s.handle.isNotEmpty ? s.handle : widget.initialHandle);

          return NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200 &&
                  s.status != GalleryStatus.loading && s.hasNext) {
                context.read<GalleryBloc>().add(const GalleryLoadMore());
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                if (all.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: CollectionsBar(
                        handles: all,
                        current: currentHandle,
                        onSelect: (h) => context.read<GalleryBloc>().add(GalleryStarted(h)),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: FilterBar(
                    facets: s.facets,
                    activeInputs: s.activeInputs,
                    onApply: (inputs) => context.read<GalleryBloc>().add(GalleryApplyFilters(inputs)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppDimens.screenPadding),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final cols = gh.gridColumnsForWidth(width);
                      final aspect = gh.gridChildAspectRatio(width, AppDimens.screenPadding, AppDimens.gridGutter, cols);
                      return SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final item = s.items[i];
                            return ProductCard(
                              p: item,
                              onTap: () => context.push('/product/${item.handle}'),
                            );
                          },
                          childCount: s.items.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          mainAxisSpacing: AppDimens.gridGutter,
                          crossAxisSpacing: AppDimens.gridGutter,
                          childAspectRatio: aspect,
                        ),
                      );
                    },
                  ),
                ),
                if (s.status == GalleryStatus.loading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
