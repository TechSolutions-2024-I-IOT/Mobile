part of 'payment_bloc.dart';


abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final Map<String, dynamic> data;

  PaymentSuccess(this.data);
}

class PaymentFailure extends PaymentState {
  final String error;

  PaymentFailure(this.error);
}
