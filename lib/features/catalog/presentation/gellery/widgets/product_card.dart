import 'package:flutter/material.dart';
import 'package:newyorkrents_app/core/theme/app_dimensions.dart';
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

    final titleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: AppDimens.cardTitleSize,
      fontWeight: FontWeight.w500,
    );
    final priceStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: AppDimens.cardPriceSize,
      fontWeight: FontWeight.w600,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: AppDimens.cardImageAspect,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.cardRadius),
              child: p.imageUrl != null
                  ? Image.network(p.imageUrl!, fit: BoxFit.cover)
                  : const ColoredBox(color: Color(0xFFEDEDED), child: Icon(Icons.image_not_supported)),
            ),
          ),
          const SizedBox(height: 8),
          Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: titleStyle),
          const SizedBox(height: 2),
          Text('${p.minPrice} ${p.currency}', style: priceStyle),
          if (p.meta.isNotEmpty) const SizedBox(height: 4),
          if (p.meta.isNotEmpty) Wrap(spacing: 6, runSpacing: -8, children: metaChips.toList()),
        ],
      ),
    );
  }
}
