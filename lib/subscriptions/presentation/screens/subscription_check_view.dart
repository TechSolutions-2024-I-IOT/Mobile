import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/services/subscription_service.dart';

class SubscriptionCheckView extends StatefulWidget {
  const SubscriptionCheckView({super.key});

  @override
  State<SubscriptionCheckView> createState() => _SubscriptionCheckViewState();
}

class _SubscriptionCheckViewState extends State<SubscriptionCheckView> {
  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
  try {
    final subscriptionService = SubscriptionService();
    final userProfile = await AuthApi().getUserProfile();
    final userEmail = userProfile?.email;

    if (userEmail != null) {
      final isActive = await subscriptionService.getPaymentHistory(userEmail);
      print('Is Active: $isActive');

      if (isActive) {
        if (mounted) {
          context.go('/home/0');
        }
      } else {
        if (mounted) {
          _showSubscriptionDialog();
        }
      }
    } else {
      print('Error: Unable to get user email');
      _showSubscriptionDialog();
    }
  } catch (e) {
    print('Error checking subscription status: $e');
    _showSubscriptionDialog();
  }
}


  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Subscription Required'),
          content: const Text(
              'To continue using the app, you need to subscribe to one of our plans.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/home/3/subscriptions/plans-available');
              },
              child: const Text('Subscribe Now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
