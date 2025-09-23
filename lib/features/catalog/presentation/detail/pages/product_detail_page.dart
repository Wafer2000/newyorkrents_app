import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newyorkrents_app/features/catalog/presentation/detail/bloc/detail_bloc.dart';
import 'package:newyorkrents_app/features/catalog/presentation/detail/bloc/detail_event.dart';
import 'package:newyorkrents_app/features/catalog/presentation/detail/bloc/detail_state.dart';
import '../../../domain/repositories/catalog_repository.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final String handle;
  const ProductDetailPage({super.key, required this.handle});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<CatalogRepository>(context, listen: false);
    return BlocProvider(
      create: (_) => DetailBloc(repo: repo)..add(DetailStarted(handle)),
      child: Scaffold(
        appBar: AppBar(title: Text(handle)),
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, s) {
            if (s.status == DetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (s.status == DetailStatus.error) {
              return Center(child: Text(s.error ?? 'Error'));
            }

            final p = s.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (p.images.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: PageView(
                        children: [for (final url in p.images) Image.network(url, fit: BoxFit.cover)],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(p.title, style: Theme.of(context).textTheme.titleLarge),
                  Text('${p.minPrice} ${p.currency}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  if (p.meta.isNotEmpty)
                    Wrap(
                      spacing: 6, runSpacing: -8,
                      children: p.meta.entries.map((e) => Chip(label: Text(e.value))).toList(),
                    ),
                  const SizedBox(height: 12),
                  if (p.descriptionHtml != null && p.descriptionHtml!.trim().isNotEmpty)
                    SelectableText(_stripHtml(p.descriptionHtml!)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _stripHtml(String html) => html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}
