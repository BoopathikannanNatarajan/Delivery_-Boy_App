import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import 'available_orders_screen.dart';
import 'earnings_screen.dart';
import 'profile_screen.dart';
import 'order_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProv = context.watch<OrderProvider>();
    final active = orderProv.activeOrders;

    // Use your login page green color theme
    final Color mainGreen = const Color(0xFF43A047); // Change to your login page green if different

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Today',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: mainGreen,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
            },
            icon: Icon(Icons.logout, color: mainGreen),
            tooltip: 'Logout',
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Green gradient header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainGreen, mainGreen.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: mainGreen.withOpacity(0.13),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _AnimatedDashTile(
                      title: 'Active',
                      value: active.length.toString(),
                      icon: Icons.local_shipping,
                      color: mainGreen,
                    ),
                    _AnimatedDashTile(
                      title: 'Available',
                      value: orderProv.availableOrders.length.toString(),
                      icon: Icons.list_alt,
                      color: mainGreen,
                    ),
                    _AnimatedDashTile(
                      title: 'Earnings',
                      value: '₹${orderProv.earnings.fold<double>(0, (s, e) => s + e.amount).toStringAsFixed(0)}',
                      icon: Icons.currency_rupee,
                      color: mainGreen,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Quick Links',
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: mainGreen,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickLinkButton(
                    label: 'Available Orders',
                    icon: Icons.list_alt,
                    color: mainGreen,
                    onTap: () => Navigator.pushNamed(context, AvailableOrdersScreen.routeName),
                  ),
                  _QuickLinkButton(
                    label: 'Earnings',
                    icon: Icons.account_balance_wallet,
                    color: mainGreen,
                    onTap: () => Navigator.pushNamed(context, EarningsScreen.routeName),
                  ),
                  _QuickLinkButton(
                    label: 'Profile',
                    icon: Icons.person,
                    color: mainGreen,
                    onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Active Orders',
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: mainGreen,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 14),
              active.isEmpty
                  ? Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: Text(
                        'No active orders right now',
                        style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: active.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _OrderCard(
                        orderId: active[i].id,
                        vendor: active[i].vendorName,
                        customer: active[i].customerName,
                        status: active[i].status.name,
                        mainGreen: mainGreen,
                        onTap: () => Navigator.pushNamed(
                          context,
                          OrderDetailScreen.routeName,
                          arguments: OrderDetailArgs(orderId: active[i].id),
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

class _AnimatedDashTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _AnimatedDashTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      builder: (context, opacity, child) => Opacity(
        opacity: opacity,
        child: child,
      ),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.92),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QuickLinkButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.09),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String vendor;
  final String customer;
  final String status;
  final Color mainGreen;
  final VoidCallback onTap;
  const _OrderCard({
    required this.orderId,
    required this.vendor,
    required this.customer,
    required this.status,
    required this.mainGreen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: mainGreen.withOpacity(0.15),
                child: Icon(Icons.local_shipping, color: mainGreen, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderId,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: mainGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$vendor → $customer',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: mainGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: mainGreen,
                    fontWeight: FontWeight.w600,
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