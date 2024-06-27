import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:intl/intl.dart';

class DescriptionPlanView extends StatefulWidget {
  const DescriptionPlanView({super.key});

  @override
  State<DescriptionPlanView> createState() => _DescriptionPlanViewState();
}

class _DescriptionPlanViewState extends State<DescriptionPlanView> {
  PaymentService paymentService = PaymentService();
  Map<String, dynamic>? lastPayment;
  AuthApi authApi = AuthApi();
  String description = '';

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
        description = paymentData?['productDescription'];
        setState(() {
          lastPayment = paymentData;
        });
        print('description: $description');
        print('paymentData: $paymentData');
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
    String subscriptionStatus = '';
    
    if (context.watch<SubscriptionBloc>().state is SubscriptionActive) {
      subscriptionStatus = 'Active';
    } else if (context.watch<SubscriptionBloc>().state is SubscriptionInactive) {
      subscriptionStatus = 'Inactive';
    } else if (context.watch<SubscriptionBloc>().state is SubscriptionError) {
      subscriptionStatus = 'Error';
    }

    
    String renewalDate = '';
    if (lastPayment != null) {
      try {
        DateTime paymentDate = DateTime.parse(lastPayment!['date']);
        DateTime nextRenewalDate =
            DateTime(paymentDate.year, paymentDate.month + 1, paymentDate.day);
        renewalDate = DateFormat('dd/MM/yy').format(nextRenewalDate);
      } catch (e) {
        print('Error al formatear la fecha: $e');
        renewalDate = 'Date not available';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'General Description of the Plan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {
            context.go('/home/3/subscriptions');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildPlanInfoCard(
                icon: Icons.directions_bus,
                planName: lastPayment != null
                    ? lastPayment!['productName'] ?? 'Unknown plan'
                    : 'Unknown plan',
                status: subscriptionStatus,
                renewalDate: renewalDate,
                color: Colors.blue[100]!,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 16),
              BuildPlanDetailsCard(
                title: 'This plan includes:',
                description: description,
                buttonText: 'See available plan',
                onPressed: () {
                  context.go('/home/3/subscriptions/plans-available');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildPlanInfoCard extends StatelessWidget {
  final IconData icon;
  final String planName;
  final String status;
  final String renewalDate;
  final Color color;
  final Color iconColor;

  const BuildPlanInfoCard({
    super.key,
    required this.icon,
    required this.planName,
    required this.status,
    required this.renewalDate,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: iconColor,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your current plant will be revenue on\n$renewalDate',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuildPlanDetailsCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;
  const BuildPlanDetailsCard(
      {super.key,
      required this.title,
      required this.description,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC4B5FD),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}