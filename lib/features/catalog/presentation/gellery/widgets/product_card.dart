import 'package:flutter/material.dart';
import 'package:newyorkrents_app/features/catalog/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity p;
  final VoidCallback? onTap;
  const ProductCard({super.key, required this.p, this.onTap});

  @override
  Widget build(BuildContext context) {
    final metaChips = p.meta.entries.take(3).map((e) => Chip(
      label: Text(e.value, overflow: TextOverflow.ellipsis),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: p.imageUrl != null
                  ? Image.network(p.imageUrl!, fit: BoxFit.cover)
                  : const ColoredBox(color: Color(0xFFEDEDED), child: Icon(Icons.image_not_supported)),
            ),
          ),
          const SizedBox(height: 8),
          Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('${p.minPrice} ${p.currency}', style: const TextStyle(fontWeight: FontWeight.w600)),
          if (p.meta.isNotEmpty) const SizedBox(height: 4),
          if (p.meta.isNotEmpty) Wrap(spacing: 6, runSpacing: -8, children: metaChips.toList()),
        ],
      ),
    );
  }
}
