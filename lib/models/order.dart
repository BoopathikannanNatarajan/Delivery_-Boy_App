enum DeliveryStatus { newJob, accepted, pickedUp, onTheWay, delivered, rejected }

class OrderItem {
  final String name;
  final int qty;
  OrderItem(this.name, this.qty);
}

class DeliveryOrder {
  final String id;
  final String vendorName;
  final String customerName;
  final String customerPhone;
  final String pickupAddress;
  final String dropAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final List<OrderItem> items;
  final double payout;
  DeliveryStatus status;
  final DateTime createdAt;

  DeliveryOrder({
    required this.id,
    required this.vendorName,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.dropAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.items,
    required this.payout,
    this.status = DeliveryStatus.newJob,
    required this.createdAt,
  });
}
