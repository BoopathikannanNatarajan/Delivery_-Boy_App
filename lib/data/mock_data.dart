import '../models/order.dart';
import '../models/earning.dart';

final mockOrders = <DeliveryOrder>[
  DeliveryOrder(
    id: 'ORD1001',
    vendorName: 'Fresh Farm Mart',
    customerName: 'Aarav Sharma',
    customerPhone: '+91 90000 12345',
    pickupAddress: '12 Market St, Sector 15',
    dropAddress: 'Green Heights, Tower 3, Apt 602',
    pickupLat: 28.4595,
    pickupLng: 77.0266,
    dropLat: 28.4721,
    dropLng: 77.0500,
    items: [OrderItem('Tomatoes', 2), OrderItem('Milk 1L', 1), OrderItem('Bread', 1)],
    payout: 65.0,
    createdAt: DateTime.now(),
  ),
  DeliveryOrder(
    id: 'ORD1002',
    vendorName: 'Daily Needs Store',
    customerName: 'Neha Verma',
    customerPhone: '+91 90000 88888',
    pickupAddress: '44 Central Bazaar',
    dropAddress: 'Sunshine Residency, A-902',
    pickupLat: 28.4595,
    pickupLng: 77.0266,
    dropLat: 28.4655,
    dropLng: 77.0415,
    items: [OrderItem('Apples 1kg', 1), OrderItem('Eggs 12', 1)],
    payout: 52.5,
    createdAt: DateTime.now(),
  ),
];

final mockEarnings = <EarningEntry>[
  EarningEntry(orderId: 'ORD0951', amount: 58.0, date: DateTime.now()),
  EarningEntry(orderId: 'ORD0952', amount: 72.5, date: DateTime.now()),
];
