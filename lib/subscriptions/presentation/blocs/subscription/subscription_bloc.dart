import 'package:bloc/bloc.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/services/subscription_service.dart'; 

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionService _subscriptionService;

  SubscriptionBloc({required SubscriptionService subscriptionService})
      : _subscriptionService = subscriptionService,
        super(SubscriptionInitial()) {
    on<CheckSubscriptionStatus>(_onCheckSubscriptionStatus);
    on<SubscribeToPlan>(_onSubscribeToPlan);
  }

  Future<void> _onCheckSubscriptionStatus(
      CheckSubscriptionStatus event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      final isSubscribed = await _subscriptionService.isUserSubscribed();
      if (isSubscribed) {
        emit(SubscriptionActive());
      } else {
        emit(SubscriptionInactive());
      }
    } catch (e) {
      emit(SubscriptionError("Failed to check subscription status: $e"));
    }
  }

  Future<void> _onSubscribeToPlan(
      SubscribeToPlan event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      // 1. Crear la suscripción con el SubscriptionService
      await _subscriptionService.createSubscription(
        plan: event.plan,
        amount: event.amount,
      );

      // 2. Disparar CheckSubscriptionStatus sin parámetros
      add(CheckSubscriptionStatus());
    } catch (e) {
      emit(SubscriptionError("Failed to subscribe: $e"));
    }
  }
}