import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/blocs/subscription/subscription_bloc.dart';

class MySubscriptionView extends StatefulWidget {
  const MySubscriptionView({super.key});

  @override
  State<MySubscriptionView> createState() => _MySubscriptionViewState();
}

class _MySubscriptionViewState extends State<MySubscriptionView> {
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
      if (userEmail.isNotEmpty) {
        final paymentData =
            await paymentService.getLastPaymentByEmail(userEmail);
        setState(() {
          lastPayment = paymentData;
        });
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
        title: const Text('My Subscription'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/home/3');
          },
        ),
      ),
      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          // Obtener el estado actual de la suscripción desde el Bloc
          String subscriptionStatus = '';
          if (state is SubscriptionActive) {
            subscriptionStatus = 'Active';
          } else if (state is SubscriptionInactive) {
            subscriptionStatus = 'Inactive';
          } else if (state is SubscriptionError) {
            subscriptionStatus = 'Error';
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildSubscriptionItem(
                    icon: Icons.directions_bus,
                    title: lastPayment != null
                        ? lastPayment!['productName'] ?? 'Premium'
                        : 'Premium',
                    status: subscriptionStatus,
                    color: Colors.blue[100]!,
                    iconColor: Colors.blue,
                    onTap: () {
                      context.go('/home/3/subscriptions/description-plan');
                    },
                  ),
                  const SizedBox(height: 16),
                  BuildSubscriptionItem(
                    icon: Icons.search,
                    title: 'See plans available',
                    subtitle: 'Premium, Students',
                    color: Colors.white,
                    iconColor: Colors.grey,
                    onTap: () {
                      context.go('/home/3/subscriptions/plans-available');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BuildSubscriptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  const BuildSubscriptionItem({
    super.key,
    required this.icon,
    required this.title,
    this.status = '',
    this.subtitle = '',
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (status.isNotEmpty)
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}