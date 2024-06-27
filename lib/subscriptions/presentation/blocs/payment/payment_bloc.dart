import 'package:bloc/bloc.dart';
import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/services/payment_service.dart';


part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService paymentService;

  PaymentBloc(this.paymentService) : super(PaymentInitial()) {
    on<CreatePaymentIntent>(_onCreatePaymentIntent);
  }

  Future<void> _onCreatePaymentIntent(
      CreatePaymentIntent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());

    final userProfile = await AuthApi().getUserProfile();

    if (userProfile == null) {
      emit(PaymentFailure('User not logged in'));
      return;
    }

    final userEmail = userProfile.email;

    final response = await paymentService.createSubscriptionIntent(
      name: event.name,
      address: event.address,
      pin: event.pin,
      city: event.city,
      state: event.state,
      country: event.country,
      currency: event.currency,
      amount: event.amount,
      customerEmail: userEmail,
    );
    if (response != null) {
      emit(PaymentSuccess(response));
    } else {
      emit(PaymentFailure('Failed to create payment intent'));
    }
  }
}
