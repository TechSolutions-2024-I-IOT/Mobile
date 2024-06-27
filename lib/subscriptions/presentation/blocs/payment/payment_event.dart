part of 'payment_bloc.dart';


abstract class PaymentEvent {}

class CreatePaymentIntent extends PaymentEvent {
  final String name;
  final String address;
  final String pin;
  final String city;
  final String state;
  final String country;
  final String currency;
  final String amount;
  final String? customerEmail;

  CreatePaymentIntent({
    required this.name,
    required this.address,
    required this.pin,
    required this.city,
    required this.state,
    required this.country,
    required this.currency,
    required this.amount,
    this.customerEmail,
  });
}
