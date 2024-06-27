part of 'subscription_bloc.dart';

abstract class SubscriptionEvent {}

class CheckSubscriptionStatus extends SubscriptionEvent {}

class SubscribeToPlan extends SubscriptionEvent {
  final String plan;
  final double amount;

  SubscribeToPlan({
    required this.plan,
    required this.amount,
  });
}
