import 'package:flutter/material.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart';
import 'package:tasoclean/utils/constants/colors.dart';

class SuggestedProduct {
  const SuggestedProduct({
    required this.name,
    required this.price,
    this.imageUrl,
  });

  final String name;
  final num price;
  final String? imageUrl;
}

const sampleSuggestedProducts = <SuggestedProduct>[
  SuggestedProduct(name: 'Multi-surface cleaner 1L', price: 450),
  SuggestedProduct(name: 'Microfibre cloth set (5)', price: 600),
  SuggestedProduct(name: 'Laundry detergent 2kg', price: 780),
  SuggestedProduct(name: 'Mop & bucket set', price: 1800),
];

class BookingSuggestions extends StatelessWidget {
  const BookingSuggestions({
    super.key,
    required this.products,
    this.onProductTap,
  });

  final List<SuggestedProduct> products;
  final ValueChanged<SuggestedProduct>? onProductTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You might also like',
          style: textTheme.titleMedium?.copyWith(
            color: MColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) => _ProductCard(
              product: products[index],
              onTap: onProductTap == null
                  ? null
                  : () => onProductTap!(products[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, this.onTap});

  final SuggestedProduct product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const placeholder = Center(
      child: Icon(
        Icons.cleaning_services_outlined,
        color: MColors.peachIcon,
        size: 34,
      ),
    );

    return SizedBox(
      width: 150,
      child: Material(
        color: MColors.peach,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                width: double.infinity,
                color: MColors.peachTile,
                child: product.imageUrl == null
                    ? placeholder
                    : Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => placeholder,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    color: MColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Text(
                  formatKes(product.price),
                  style: textTheme.bodySmall?.copyWith(
                    color: MColors.peachSubtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
