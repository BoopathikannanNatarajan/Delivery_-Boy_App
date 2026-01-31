import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';

class OrderDetailArgs {
  final String orderId;
  OrderDetailArgs({required this.orderId});
}

class OrderDetailScreen extends StatelessWidget {
  static const routeName = '/orderDetail';
  final OrderDetailArgs args;
  const OrderDetailScreen({super.key, required this.args});

  Color get mainGreen => const Color(0xFF43A047);
  Color get lightGreen => const Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrderProvider>();
    final order = prov.byId(args.orderId);

    Future<void> _openMaps(double lat, double lng) async {
      final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    DeliveryStatus nextStatus(DeliveryStatus s) {
      switch (s) {
        case DeliveryStatus.newJob:
          return DeliveryStatus.accepted;
        case DeliveryStatus.accepted:
          return DeliveryStatus.pickedUp;
        case DeliveryStatus.pickedUp:
          return DeliveryStatus.onTheWay;
        case DeliveryStatus.onTheWay:
          return DeliveryStatus.delivered;
        case DeliveryStatus.delivered:
        case DeliveryStatus.rejected:
          return s;
      }
    }

    String statusLabel(DeliveryStatus s) {
      switch (s) {
        case DeliveryStatus.newJob:
          return 'New';
        case DeliveryStatus.accepted:
          return 'Accepted';
        case DeliveryStatus.pickedUp:
          return 'Picked Up';
        case DeliveryStatus.onTheWay:
          return 'On The Way';
        case DeliveryStatus.delivered:
          return 'Delivered';
        case DeliveryStatus.rejected:
          return 'Rejected';
      }
    }

    final canAdvance = order.status != DeliveryStatus.delivered && order.status != DeliveryStatus.rejected;

    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: mainGreen,
        elevation: 0,
        title: Text(
          'Order ${order.id}',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.vendorName} → ${order.customerName}',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: mainGreen,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.flag, color: Colors.red),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Pickup: ${order.pickupAddress}',
                            style: GoogleFonts.montserrat(fontSize: 14),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _openMaps(order.pickupLat, order.pickupLng),
                          icon: Icon(Icons.navigation, color: mainGreen),
                          label: Text('Navigate', style: GoogleFonts.montserrat(color: mainGreen)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.place, color: mainGreen),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Drop: ${order.dropAddress}',
                            style: GoogleFonts.montserrat(fontSize: 14),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _openMaps(order.dropLat, order.dropLng),
                          icon: Icon(Icons.navigation, color: mainGreen),
                          label: Text('Navigate', style: GoogleFonts.montserrat(color: mainGreen)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Items', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16, color: mainGreen)),
                    const SizedBox(height: 8),
                    ...order.items.map((e) => ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: mainGreen.withOpacity(0.15),
                            child: Icon(Icons.shopping_bag, color: mainGreen),
                          ),
                          title: Text(e.name, style: GoogleFonts.montserrat()),
                          trailing: Text('x${e.qty}', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: mainGreen)),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: mainGreen.withOpacity(0.15),
                      child: Icon(Icons.person, color: mainGreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.customerName, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
                          Text(order.customerPhone, style: GoogleFonts.montserrat(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.phone, color: mainGreen),
                      onPressed: () async {
                        final uri = Uri.parse('tel:${order.customerPhone}');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Chip(
                      backgroundColor: mainGreen.withOpacity(0.1),
                      label: Text(
                        'Status: ${statusLabel(order.status)}',
                        style: GoogleFonts.montserrat(color: mainGreen, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Text('Payout: ₹${order.payout.toStringAsFixed(1)}',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, color: mainGreen)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (canAdvance)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => prov.updateStatus(order.id, nextStatus(order.status)),
                      icon: const Icon(Icons.check_circle),
                      label: Text(
                        'Mark ${statusLabel(nextStatus(order.status))}',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (order.status == DeliveryStatus.newJob)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => prov.reject(order.id),
                        child:Text('Reject', style: GoogleFonts.montserrat(color: Colors.red, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: mainGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, color: mainGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Order complete. Great job!',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, color: mainGreen),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}