import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class PaymentsView extends StatefulWidget {
  const PaymentsView({super.key});

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  PaymentService paymentService = PaymentService();
  Map<String, dynamic>? lastPayment;
  AuthApi authApi = AuthApi();

  @override
  void initState() {
    super.initState();
    _fetchLastPayment();
  }

  Future<void> _fetchLastPayment() async {
    try {
      final userProfile = await authApi.getUserProfile();
      final userEmail = userProfile?.email ?? '';
      print('userEmail: $userEmail');
      if (userEmail.isNotEmpty) {
        final paymentData = await paymentService.getLastPaymentByEmail(userEmail);
        setState(() {
          lastPayment = paymentData;
        });
        print('lastPayment: $lastPayment');
      } else {
        
        print('Error: No se pudo obtener el email del usuario.');
      }
    } catch (e) {
      
      print('Error al obtener el último pago: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {
            context.go('/home/3');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payments history',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              if (lastPayment != null)
                BuildPaymentItem(
                  title: lastPayment!['productName'] ?? 'Último pago',
                  amount: '${lastPayment!['currency']} ${lastPayment!['amount']}',
                  date: lastPayment!['date'],
                )
              else
                const Center(child: CircularProgressIndicator()),
              // ... [Tu código existente para "Payment method" y el resto] ...
            ],
          ),
        ),
      ),
    );
  }
}

class BuildPaymentItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  const BuildPaymentItem({super.key, required this.title, required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}