import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String _baseUrl = 'https://api.stripe.com/v1';

  Future<Map<String, dynamic>?> createCustomer(String email) async {
    final url = Uri.parse('$_baseUrl/customers');
    const secretKey = 'sk_test_51PRHFWILNSnESdAQoPfpkHAl1dZ97sJziWj2SJW6ePZ8VRwgi3rV0mv20AcV6cALK8Z8wEpAPSaG9GEK9n94VXXZ001fNt01Bv';
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error in creating customer');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createSubscriptionIntent({
    required String name,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String currency,
    required String amount,
    String? customerEmail,
  }) async {
    final url = Uri.parse('$_baseUrl/payment_intents');
    const secretKey = 'sk_test_51PRHFWILNSnESdAQoPfpkHAl1dZ97sJziWj2SJW6ePZ8VRwgi3rV0mv20AcV6cALK8Z8wEpAPSaG9GEK9n94VXXZ001fNt01Bv';

    final intAmount = (double.parse(amount) * 100).toInt();
    final customer = await createCustomer(customerEmail!);

    final body = {
      'amount': intAmount.toString(),
      'currency': currency.toLowerCase(),
      'automatic_payment_methods[enabled]': 'true',
      'description': "Test Subscription",
      'shipping[name]': name,
      'shipping[address][line1]': address,
      'shipping[address][postal_code]': pin,
      'shipping[address][city]': city,
      'shipping[address][state]': state,
      'shipping[address][country]': country,
      'customer': customer!['id'],
      'receipt_email': customerEmail,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error in calling payment intent: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

   Future<Map<String, dynamic>?> getLastPaymentByEmail(String email) async {
    final url = Uri.parse('$_baseUrl/payment_intents');
    const secretKey = 'sk_test_51PRHFWILNSnESdAQoPfpkHAl1dZ97sJziWj2SJW6ePZ8VRwgi3rV0mv20AcV6cALK8Z8wEpAPSaG9GEK9n94VXXZ001fNt01Bv';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $secretKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentIntents = data['data'] as List;

        final lastPayment = paymentIntents.firstWhere(
          (payment) =>
              payment['receipt_email'] == email &&
              payment['status'] == 'succeeded',
          orElse: () => null,
        );

        print('lastPayment: $lastPayment');

        if (lastPayment != null) {
          
          final price = await _getPriceByAmount(lastPayment['amount']);
          print('price: $price');

          final product = await _getProductByPriceId(price!['id']);
          print('product: $product');

          return {
            'amount': _formatPrice(price['unit_amount']),
            'recipientEmail': lastPayment['receipt_email'],
            'date': DateTime.fromMillisecondsSinceEpoch(
                    lastPayment['created'] * 1000)
                .toString(),
            'productName': product?['name'],
            'productDescription': product?['description'],
            'currency': price['currency'],
          };

        } else {
          print('No successful payments found for this email.');
          return null;
        }
      } else {
        print('Error fetching payment intents: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getProductByPriceId(String priceId) async {
  final url = Uri.parse('$_baseUrl/products');
  const secretKey = 'sk_test_51PRHFWILNSnESdAQoPfpkHAl1dZ97sJziWj2SJW6ePZ8VRwgi3rV0mv20AcV6cALK8Z8wEpAPSaG9GEK9n94VXXZ001fNt01Bv';

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $secretKey',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = data['data'] as List;

      // Buscar el producto que coincida con el priceId
      final foundProduct = products.firstWhere(
        (product) => product['default_price'] == priceId, 
        orElse: () => null,
      );

      return foundProduct; // Retorna el producto encontrado o null
    } else {
      print('Error fetching products: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}

  Future<Map<String, dynamic>?> _getPriceByAmount(int amount) async {
  final url = Uri.parse('$_baseUrl/prices');
  const secretKey = 'sk_test_51PRHFWILNSnESdAQoPfpkHAl1dZ97sJziWj2SJW6ePZ8VRwgi3rV0mv20AcV6cALK8Z8wEpAPSaG9GEK9n94VXXZ001fNt01Bv';

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $secretKey',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prices = data['data'] as List;

     
      final foundPrice = prices.firstWhere(
        (price) => price['unit_amount'] == amount,
        orElse: () => null,
      );

      return foundPrice;
    } else {
      print('Error fetching price details: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}

  String _formatPrice(int amount) {
    return (amount / 100).toStringAsFixed(2);
  }
}

