import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class EarningsScreen extends StatelessWidget {
  static const routeName = '/earnings';
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrderProvider>();
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final total = prov.earnings.fold<double>(0, (s, e) => s + e.amount);
    final Color mainGreen = const Color(0xFF43A047);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: mainGreen,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFF6F8FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: mainGreen, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Total Earnings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainGreen,
                        ),
                      ),
                    ),
                    Text(
                      fmt.format(total),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: mainGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: prov.earnings.isEmpty
                  ? Center(
                      child: Text(
                        'No earnings yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: prov.earnings.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final e = prov.earnings[i];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: mainGreen.withOpacity(0.15),
                              child: Icon(Icons.local_shipping, color: mainGreen),
                            ),
                            title: Text(
                              'Order ${e.orderId}',
                              style: TextStyle(fontWeight: FontWeight.bold, color: mainGreen),
                            ),
                            subtitle: Text(
                              DateFormat('dd MMM, hh:mm a').format(e.date),
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: Text(
                              fmt.format(e.amount),
                              style: TextStyle(fontWeight: FontWeight.bold, color: mainGreen),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}