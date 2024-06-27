import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/blocs/subscription/subscription_bloc.dart';

class PlansAvailableView extends StatelessWidget {
  const PlansAvailableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Available Plans',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {
            context.go('/subscription-check');
          },
        ),
      ),
      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          bool isSubscriptionActive = state is SubscriptionActive;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildPlanCard(
                    planName: 'Premium',
                    amount: 7.88,
                    features: const [
                      '1 Premium account',
                      'Browse without ads',
                      'Add as many lines as you want to your\nfavorites',
                      'Receive notifications from your favorite\nlines',
                      'Updated information on the status of\nthe next buses closest to your location',
                    ],
                    onPressed: isSubscriptionActive
                        ? null
                        : () {
                            _handlePlanSelection(context, 'Premium', 7.88);
                          },
                  ),
                  const SizedBox(height: 16),
                  BuildPlanCard(
                    planName: 'Students',
                    amount: 5.26,
                    features: const [
                      '1 verified Premium account',
                      'Student discount',
                      'Browse without ads',
                      'Add up to 5 lines to your favorites',
                      'Updated information on the status of\nthe next buses closest to your location',
                    ],
                    onPressed: isSubscriptionActive
                        ? null
                        : () {
                            _handlePlanSelection(context, 'Students', 5.26);
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

  void _handlePlanSelection(
      BuildContext context, String planName, double amount) {
    context.push('/home/3/payments/pay-subscription', extra: {'plan': planName, 'amount': amount});
  }
}

class BuildPlanCard extends StatelessWidget {
  final String planName;
  final double amount;
  final List<String> features;
  final VoidCallback? onPressed;

  const BuildPlanCard({
    super.key,
    required this.planName,
    required this.amount,
    required this.features,
    this.onPressed, 
  });

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
            planName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$$amount',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map((feature) => Text(
                      '• $feature',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onPressed,
              child: const Text('Choose Plan'),
            ),
          ),
        ],
      ),
    );
  }
}