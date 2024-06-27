import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/blocs/payment/payment_bloc.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/widgets/reusable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

class PaySubscriptionView extends StatefulWidget {
  final String plan;
  final double amount;

  const PaySubscriptionView({
    super.key,
    required this.plan,
    required this.amount,
  });

  @override
  PaySubscriptionViewState createState() => PaySubscriptionViewState();
}

class PaySubscriptionViewState extends State<PaySubscriptionView> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController currentController = TextEditingController();
  String customerEmail = '';

  final formKey = GlobalKey<FormState>();

  String selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    amountController.text = widget.amount.toStringAsFixed(2);
    currentController.text = selectedCurrency;
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await AuthApi().getUserProfile();
    if (userProfile != null) {
      setState(() {
        nameController.text = '${userProfile.firstName} ${userProfile.lastName}';
        customerEmail = userProfile.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Subscription')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SubscriptionBloc, SubscriptionState>(
            listener: (context, state) {
              if (state is SubscriptionActive) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('¡Suscripción Activa!'),
                      content: const Text('Ya estás suscrito a nuestro servicio.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.go('/home/3/subscriptions');
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (state is SubscriptionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error de suscripción: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<PaymentBloc, PaymentState>(
            listener: (context, state) async {
              if (state is PaymentSuccess) {
                try {
                  await Stripe.instance.initPaymentSheet(
                    paymentSheetParameters: SetupPaymentSheetParameters(
                      customFlow: false,
                      merchantDisplayName: 'Test Merchant',
                      paymentIntentClientSecret: state.data['client_secret'],
                      customerId: state.data['customer'],
                      style: ThemeMode.dark,
                    ),
                  );

                  await Stripe.instance.presentPaymentSheet();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment Successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  print('Payment successful!');

                  context.read<SubscriptionBloc>().add(CheckSubscriptionStatus());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else if (state is PaymentFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error de pago: ${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Subscribe to ${widget.plan} Plan",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                ReusableTextField(
                  controller: amountController,
                  isNumber: true,
                  title: "Subscription Amount",
                  hint: "Any amount you like",
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                ReusableTextField(
                  title: "Name",
                  hint: "Ex. John Doe",
                  controller: nameController,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                ReusableTextField(
                  title: "Address",
                  hint: "Ex. 123 Main St",
                  controller: addressController,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                ReusableTextField(
                  title: "City",
                  hint: "Ex. New York",
                  controller: cityController,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                ReusableTextField(
                  title: "State",
                  hint: "Ex. NY",
                  controller: stateController,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                ReusableTextField(
                  title: "Country",
                  hint: "Ex. USA",
                  controller: countryController,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                ReusableTextField(
                  title: "Postal Code",
                  hint: "Ex. 10001",
                  controller: pinController,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                ReusableTextField(
                  title: "Current", 
                  hint: "USD", 
                  controller: currentController, 
                  readOnly: true
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade400,
                    ),
                    child: const Text(
                      "Proceed to Pay",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        context.read<PaymentBloc>().add(
                          CreatePaymentIntent(
                            name: nameController.text,
                            currency: selectedCurrency,
                            amount: amountController.text,
                            customerEmail: customerEmail, 
                            address: addressController.text, 
                            pin: pinController.text, 
                            city: cityController.text, 
                            state: stateController.text, 
                            country: countryController.text,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
