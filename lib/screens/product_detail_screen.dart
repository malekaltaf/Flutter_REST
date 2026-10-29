import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/star_rating.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _cartCount = 0;
  late PageController _pageController;
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    setState(() => _cartCount++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.title} added to cart'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final images = p.images.isNotEmpty ? p.images : [p.thumbnail];

    return Scaffold(
      appBar: AppBar(
        title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: _cartCount > 0
                    ? () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$_cartCount item(s) in cart'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        )
                    : null,
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: colorScheme.error,
                    child: Text(
                      '$_cartCount',
                      style: TextStyle(
                          fontSize: 10, color: colorScheme.onError),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            SizedBox(
              height: 280,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (i) =>
                        setState(() => _currentImage = i),
                    itemBuilder: (_, i) => Hero(
                      tag: i == 0 ? 'product-thumb-${p.id}' : 'img-$i',
                      child: CachedNetworkImage(
                        imageUrl: images[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (_, __) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: const Center(
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: colorScheme.errorContainer,
                          child: Icon(Icons.broken_image_outlined,
                              color: colorScheme.onErrorContainer,
                              size: 48),
                        ),
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImage == i ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentImage == i
                                  ? colorScheme.primary
                                  : colorScheme.outline,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Chip(
                    label: Text(p.category.toUpperCase()),
                    labelStyle: theme.textTheme.labelSmall
                        ?.copyWith(color: colorScheme.primary),
                    side: BorderSide(color: colorScheme.primary),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(p.title,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),

                  // Brand
                  Text('by ${p.brand}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.outline)),
                  const SizedBox(height: 12),

                  // Rating row
                  Row(
                    children: [
                      StarRating(rating: p.rating, size: 20),
                      const SizedBox(width: 8),
                      Text(p.rating.toStringAsFixed(1),
                          style: theme.textTheme.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${p.discountedPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (p.discountPercentage > 0) ...[
                        const SizedBox(width: 10),
                        Text(
                          '\$${p.price.toStringAsFixed(2)}',
                          style:
                              theme.textTheme.titleMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: colorScheme.outline,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${p.discountPercentage.toStringAsFixed(0)}% OFF',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onErrorContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Stock badge
                  Row(
                    children: [
                      Icon(
                        p.stock > 0
                            ? Icons.check_circle_outline_rounded
                            : Icons.cancel_outlined,
                        size: 16,
                        color: p.stock > 0
                            ? Colors.green
                            : colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        p.stock > 0
                            ? '${p.stock} in stock'
                            : 'Out of stock',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: p.stock > 0
                              ? Colors.green
                              : colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Divider(),
                  const SizedBox(height: 12),

                  // Description
                  Text('Description',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(p.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.8),
                          height: 1.5)),

                  const SizedBox(height: 100), // space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: p.stock > 0 ? _addToCart : null,
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: const Text('Add to Cart'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: p.stock > 0 ? _addToCart : null,
                  icon: const Icon(Icons.flash_on_rounded),
                  label: const Text('Buy Now'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
