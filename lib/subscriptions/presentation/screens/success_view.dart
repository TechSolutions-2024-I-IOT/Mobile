import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/blocs/subscription/subscription_bloc.dart';

class SuccessView extends StatelessWidget {
  final String amount;
  final String currency;

  const SuccessView({
    super.key,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Success')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thanks for your $amount $currency subscription",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "We appreciate your support",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            BlocBuilder<SubscriptionBloc, SubscriptionState>(
              builder: (context, state) {
                if (state is SubscriptionLoading) {
                  return const CircularProgressIndicator();
                } else if (state is SubscriptionActive) {
                  return const Text(
                    "Your subscription is active",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  );
                } else if (state is SubscriptionInactive) {
                  return const Text(
                    "Your subscription is inactive",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  );
                } else if (state is SubscriptionError) {
                  return Text(
                    "Error: ${state.message}",
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  );
                } else {
                  return const Text(
                    "Unknown subscription state",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent.shade400),
                child: const Text("Subscribe again", style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
