import 'dart:convert';
import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:http/http.dart' as http;
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/data_sources/subcriptions_datasource_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/models/subscription_model.dart';

class SubscriptionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _baseUrl = 'https://api.stripe.com/v1';
  final String _secretKey =
      'sk_test_51PRHFWILNSnESdAQoPfpkHAl1dZ97sJziWj2SJW6ePZ8VRwgi3rV0mv20AcV6cALK8Z8wEpAPSaG9GEK9n94VXXZ001fNt01Bv';
  final SubscriptionDataSourceDatabase _dbService =
      SubscriptionDataSourceDatabase();
  final AuthApi _authApi = AuthApi();

  Future<Subscription?> getUserSubscription() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      Subscription? subscription =
          await _dbService.getSubscriptionByUserId(firebaseUser.uid);
      return subscription;
    } catch (e) {
      print('Error fetching subscription: $e');
      return null;
    }
  }

  Future<bool> isUserSubscribed() async {
    try {
      final userData = await _getUserData();
      final email = userData['email'];

      return await getPaymentHistory(email);
    } catch (e) {
      print('Error checking subscription status: $e');
      return false;
    }
  }

  Future<void> createSubscription({
    required String plan,
    required double amount,
  }) async {
    try {
      final userData = await _getUserData();

      // 1. Crear un Customer en Stripe
      final customerResponse = await http.post(
        Uri.parse('$_baseUrl/customers'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'email': userData['email']},
      );

      if (customerResponse.statusCode != 200) {
        throw Exception('Error creating customer: ${customerResponse.body}');
      }

      final customer = jsonDecode(customerResponse.body);
      final customerId = customer['id'];

      // 2. Crear la suscripción en Stripe
      final subscriptionResponse = await http.post(
        Uri.parse('$_baseUrl/subscriptions'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'customer': customerId,
          'items[0][price]': _getPlanPriceId(plan),
        },
      );

      if (subscriptionResponse.statusCode != 200) {
        throw Exception(
            'Error creating subscription: ${subscriptionResponse.body}');
      }

      final subscriptionData = jsonDecode(subscriptionResponse.body);
      final subscriptionId = subscriptionData['id'];

      // 3. Guardar la suscripción en la base de datos local
      final newSubscription = Subscription(
        id: subscriptionId,
        userId: userData['userId'],
        plan: plan,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        clientSecret: subscriptionData['latest_invoice']['payment_intent']
            ['client_secret'],
      );

      await _dbService.insertSubscription(newSubscription);
    } catch (e) {
      print('Error creating subscription: $e');
      throw Exception('Failed to create subscription: $e');
    }
  }

  Future<bool> getPaymentHistory(String email) async {
    final url = Uri.parse('$_baseUrl/payment_intents');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_secretKey',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      for (var payment in data) {
        if (payment['receipt_email'] == email) {
          return true;
        }
      }
      return false;
    } else {
      throw Exception('Failed to get payment history: ${response.body}');
    }
  }

  // Método auxiliar para obtener el ID del precio del plan
  String _getPlanPriceId(String plan) {
    switch (plan) {
      case 'Premium':
        return 'price_1PVhcwILNSnESdAQyvXQ8mhS';
      case 'Students':
        return 'price_1PVj1qILNSnESdAQhnhwvdKy';
      default:
        throw Exception('Plan no valid');
    }
  }

  // Obtiene la información del usuario ya sea de Firebase o del backend
  Future<Map<String, dynamic>> _getUserData() async {
    var userData = await _authApi.getUserProfile();

    if (userData != null) {
      return userData.toJson();
    } else {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        return {
          'userId': firebaseUser.uid,
          'email': firebaseUser.email,
          'name': firebaseUser.displayName ?? '',
        };
      } else {
        throw Exception('No user authenticated');
      }
    }
  }
}
