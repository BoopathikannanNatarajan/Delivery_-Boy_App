import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_detail_screen.dart';

class AvailableOrdersScreen extends StatelessWidget {
  static const routeName = '/available';
  const AvailableOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrderProvider>();
    final orders = prov.availableOrders;
    final Color mainGreen = const Color(0xFF43A047);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Orders'),
        backgroundColor: mainGreen,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'No available orders',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) {
                final o = orders[i];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/orderDetail',
                      arguments: OrderDetailArgs(orderId: o.id),
                    ),
                    onLongPress: () => prov.reject(o.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: mainGreen.withOpacity(0.15),
                                child: Icon(Icons.store, color: mainGreen),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${o.vendorName} → ${o.customerName}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: mainGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.flag, color: Colors.red, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  o.pickupAddress,
                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.place, color: mainGreen, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  o.dropAddress,
                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Chip(
                                label: Text(
                                  'Payout: ₹${o.payout.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    color: mainGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: mainGreen.withOpacity(0.1),
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: () {
                                  prov.accept(o.id);
                                  Navigator.pushNamed(
                                    context,
                                    '/orderDetail',
                                    arguments: OrderDetailArgs(orderId: o.id),
                                  );
                                },
                                icon: const Icon(Icons.check_circle, size: 18),
                                label: const Text('Accept'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}