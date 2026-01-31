import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';

class KYCScreen extends StatefulWidget {
  static const routeName = '/kyc';
  const KYCScreen({super.key});

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _vehicleCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  bool loading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _vehicleCtrl.dispose();
    _bankCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon, {String? helper}) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: Icon(icon, color: Colors.green[700]),
      filled: true,
      fillColor: Colors.white,
      helperText: helper,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.green[100]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.green[400]!, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFFB2FF59), Color(0xFF69F0AE)]),
              boxShadow: [BoxShadow(color: Colors.greenAccent.withOpacity(0.3), blurRadius: 18)],
            ),
            child: Center(child: Icon(Icons.verified_user_rounded, size: 48, color: Colors.green[700])),
          ),
          const SizedBox(height: 16),
          Text(
            "KYC Verification",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[900]),
          ),
          const SizedBox(height: 6),
          Text(
            "Complete your profile to start delivering groceries!",
            style: TextStyle(fontSize: 15, color: Colors.green[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 2),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Personal Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[800])),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: _inputDecoration('Full name', Icons.person_rounded),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 18),
                Text("Vehicle Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[800])),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _vehicleCtrl,
                  decoration: _inputDecoration('Vehicle details', Icons.directions_bike_rounded, helper: 'e.g. Bike, Car, etc.'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Enter vehicle details' : null,
                ),
                const SizedBox(height: 18),
                Text("Bank Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[800])),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _bankCtrl,
                  decoration: _inputDecoration('Bank account (for payouts)', Icons.account_balance_rounded, helper: 'Account number or UPI ID'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Enter bank details' : null,
                ),
                const SizedBox(height: 28),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF43EA6D), Color(0xFFFFF176)]),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.greenAccent.withOpacity(0.18), blurRadius: 12)],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      splashColor: Colors.yellowAccent.withOpacity(0.2),
                      onTap: loading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Please fill all fields correctly.'),
                                    backgroundColor: Colors.red[400],
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                                return;
                              }
                              setState(() => loading = true);
                              await Future.delayed(const Duration(milliseconds: 700));
                              if (!mounted) return;
                              Provider.of<AuthProvider>(context, listen: false).completeKyc();
                              Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Center(
                          child: loading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Submit KYC',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: Stack(
        children: [
          // Decorative grocery icons
          Positioned(top: 60, left: 30, child: Icon(Icons.shopping_cart_rounded, size: 38, color: Colors.green[100])),
          Positioned(top: 140, right: 40, child: Icon(Icons.local_offer_rounded, size: 32, color: Colors.green[100])),
          Positioned(bottom: 120, left: 20, child: Icon(Icons.fastfood_rounded, size: 35, color: Colors.green[100])),
          Positioned(bottom: 200, right: 30, child: Icon(Icons.emoji_food_beverage_rounded, size: 28, color: Colors.green[100])),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    _buildForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
