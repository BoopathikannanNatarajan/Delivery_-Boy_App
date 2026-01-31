import 'package:flutter/material.dart';
import '../models/order.dart';
import '../data/mock_data.dart';
import '../models/earning.dart';

class OrderProvider extends ChangeNotifier {
  final List<DeliveryOrder> _orders = List.from(mockOrders);
  final List<EarningEntry> _earnings = List.from(mockEarnings);

  List<DeliveryOrder> get availableOrders =>
      _orders.where((o) => o.status == DeliveryStatus.newJob).toList();

  List<DeliveryOrder> get activeOrders =>
      _orders.where((o) => o.status != DeliveryStatus.delivered && o.status != DeliveryStatus.rejected).toList();

  List<EarningEntry> get earnings => List.unmodifiable(_earnings);

  DeliveryOrder byId(String id) => _orders.firstWhere((o) => o.id == id);

  void accept(String id) {
    final o = byId(id);
    o.status = DeliveryStatus.accepted;
    notifyListeners();
  }

  void reject(String id) {
    final o = byId(id);
    o.status = DeliveryStatus.rejected;
    notifyListeners();
  }

  void updateStatus(String id, DeliveryStatus status) {
    final o = byId(id);
    o.status = status;
    if (status == DeliveryStatus.delivered) {
      _earnings.add(EarningEntry(orderId: o.id, amount: o.payout, date: DateTime.now()));
    }
    notifyListeners();
  }

  void refresh() {}
}
