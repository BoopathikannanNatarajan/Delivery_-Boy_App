import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'screens/login_screen.dart';
import 'screens/kyc_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/available_orders_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/earnings_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GrocerLink Delivery',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          KYCScreen.routeName: (_) => const KYCScreen(),
          DashboardScreen.routeName: (_) => const DashboardScreen(),
          AvailableOrdersScreen.routeName: (_) => const AvailableOrdersScreen(),
          EarningsScreen.routeName: (_) => const EarningsScreen(),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == OrderDetailScreen.routeName) {
            final args = settings.arguments as OrderDetailArgs;
            return MaterialPageRoute(builder: (_) => OrderDetailScreen(args: args));
          }
          return null;
        },
      ),
    );
  }
}
