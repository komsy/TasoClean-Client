import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasoclean/features/shop/controllers/checkout_controller.dart'
    show CheckoutController, formatAmount;
import 'package:tasoclean/features/shop/controllers/order_controller.dart';
import 'package:tasoclean/features/shop/models/order_model.dart';
import 'package:tasoclean/features/shop/screens/store/product_widgets.dart' show ProductImage;

// Local palette – swap for MColors equivalents if you have them
const _kBlue = Color(0xFF4A78D0);
const _kDark = Color(0xFF1B1B1D);
const _kCard = Color(0xFF2A2A2D);
const _kPeach = Color(0xFFE9C98F);

String _fmtDate(DateTime d) => '${d.day} ${CheckoutController.month(d)} ${d.year}';

class OrdersScreen extends StatefulWidget {
  /// 0 = Services, 1 = Products
  const OrdersScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(OrdersController()); // re-created on every visit so it refetches
  }

  @override
  void dispose() {
    Get.delete<OrdersController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab,
      child: Scaffold(
        backgroundColor: _kDark,
        body: Column(
          children: [
            const _Header(),
            const Expanded(
              child: TabBarView(children: [_ServicesTab(), _ProductsTab()]),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Header + pill tabs
// ─────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _kBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 20, 18),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                  ),
                  Text('My orders',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    tabs: const [
                      Tab(height: 36, text: 'Services'),
                      Tab(height: 36, text: 'Products'),
                    ],
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

// ─────────────────────────────────────────────────────────────
// Tabs
// ─────────────────────────────────────────────────────────────
class _ServicesTab extends StatelessWidget {
  const _ServicesTab();

  @override
  Widget build(BuildContext context) {
    final c = OrdersController.instance;

    return Obx(() {
      if (c.loadingBookings.value) return const Center(child: CircularProgressIndicator());

      final error = c.bookingsError.value;
      if (error != null) return _ErrorState(message: error, onRetry: c.fetchBookings);

      final list = c.bookings.toList();
      if (list.isEmpty) {
        return const _EmptyState(
          icon: Icons.cleaning_services_outlined,
          title: 'No service bookings yet',
          subtitle: 'Book a trusted pro and it will show up here.',
        );
      }

      return RefreshIndicator(
        onRefresh: c.fetchBookings,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, i) => _BookingCard(booking: list[i]),
        ),
      );
    });
  }
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context) {
    final c = OrdersController.instance;

    return Obx(() {
      if (c.loadingProducts.value) return const Center(child: CircularProgressIndicator());

      final error = c.productsError.value;
      if (error != null) return _ErrorState(message: error, onRetry: c.fetchProductOrders);

      final list = c.productOrders.toList();
      if (list.isEmpty) {
        return const _EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: 'No product orders yet',
          subtitle: 'Orders from the Taso Store will show up here.',
        );
      }

      return RefreshIndicator(
        onRefresh: c.fetchProductOrders,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, i) => _ProductOrderCard(order: list[i]),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// Cards
// ─────────────────────────────────────────────────────────────
BoxDecoration get _cardDecoration => BoxDecoration(
      color: _kCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
    );

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});
  final BookingModel booking;

  String get _when {
    final d = booking.scheduledDate;
    if (d == null) return booking.timeSlot;
    final day = '${CheckoutController.weekday(d)}, ${d.day} ${CheckoutController.month(d)}';
    return booking.timeSlot.isEmpty ? day : '$day · ${booking.timeSlot}';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final dueNow = booking.status == 'pending_payment' && booking.amountDueNow > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(booking.reference,
                    style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
              _StatusChip(status: booking.status),
            ],
          ),
          if (booking.createdAt != null) ...[
            const SizedBox(height: 2),
            Text('Placed ${_fmtDate(booking.createdAt!)}',
                style: t.bodySmall?.copyWith(color: Colors.white54)),
          ],
          Divider(height: 22, color: Colors.white.withValues(alpha: 0.08)),
          for (final l in booking.lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${l.name}${l.quantity > 1 ? ' x ${l.quantity}' : ''}',
                        style: t.bodyMedium?.copyWith(color: Colors.white)),
                  ),
                  Text(formatAmount(l.lineTotal), style: t.bodyMedium?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
          Divider(height: 22, color: Colors.white.withValues(alpha: 0.08)),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 18, color: _kPeach),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_when, style: t.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: t.bodyMedium?.copyWith(color: Colors.white60)),
              Text('KSh ${formatAmount(booking.servicesTotal)}',
                  style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
            ],
          ),
          if (dueNow) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Deposit due', style: t.bodySmall?.copyWith(color: _kPeach)),
                Text('KSh ${formatAmount(booking.amountDueNow)}',
                    style: t.bodySmall?.copyWith(color: _kPeach, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductOrderCard extends StatelessWidget {
  const _ProductOrderCard({required this.order});
  final ProductOrderModel order;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    const maxThumbs = 4;
    final shown = order.items.take(maxThumbs).toList();
    final extra = order.items.length - shown.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(order.reference,
                    style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
              _StatusChip(status: order.status),
            ],
          ),
          if (order.createdAt != null) ...[
            const SizedBox(height: 2),
            Text('Placed ${_fmtDate(order.createdAt!)}',
                style: t.bodySmall?.copyWith(color: Colors.white54)),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              for (final item in shown)
                Container(
                  width: 52,
                  height: 52,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ProductImage(url: item.image),
                ),
              if (extra > 0)
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('+$extra',
                      style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (order.items.isNotEmpty)
            Text(
              order.items.map((i) => i.name).take(2).join(', ') + (order.items.length > 2 ? '…' : ''),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.bodyMedium?.copyWith(color: Colors.white70),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                  style: t.bodyMedium?.copyWith(color: Colors.white60)),
              Text('KSh ${formatAmount(order.total)}',
                  style: t.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  (String, Color) get _style {
    switch (status.toLowerCase()) {
      case 'pending_payment':
        return ('Awaiting payment', const Color(0xFFF2B84B));
      case 'pending':
        return ('Pending', const Color(0xFFF2B84B));
      case 'confirmed':
        return ('Confirmed', const Color(0xFF6FA0FF));
      case 'processing':
        return ('Processing', const Color(0xFF6FA0FF));
      case 'shipped':
        return ('On the way', const Color(0xFF6FA0FF));
      case 'completed':
        return ('Completed', const Color(0xFF4CAF6A));
      case 'delivered':
        return ('Delivered', const Color(0xFF4CAF6A));
      case 'cancelled':
        return ('Cancelled', const Color(0xFFE5484D));
      default:
        final s = status.replaceAll('_', ' ');
        return (s.isEmpty ? 'Unknown' : s[0].toUpperCase() + s.substring(1), Colors.white54);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color) = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Empty + error states
// ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: Colors.white.withValues(alpha: 0.3)),
            const SizedBox(height: 14),
            Text(title, style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center, style: t.bodyMedium?.copyWith(color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}