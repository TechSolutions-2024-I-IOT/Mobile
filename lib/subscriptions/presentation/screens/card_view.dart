/*import 'package:chapa_tu_bus_app/subscriptions/infrastructure/repositories/payment_repository.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/blocs/payments/payments_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:go_router/go_router.dart';

class CardView extends StatefulWidget {
  const CardView({super.key});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  final _formKey = GlobalKey<FormState>();
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;
  CreditCardBrand? _detectedBrand;
  Color _cardBackgroundColor = Colors.grey.shade200;

  @override
  void initState() {
    super.initState();
  }

  void _updateCreditCardBrand(CreditCardBrand creditCardBrand) {
    _detectedBrand = creditCardBrand;
    _cardBackgroundColor = getCardBackgroundColor(_detectedBrand!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pagos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {
            context.go('/home/3/payments');
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => PaymentsBloc(PaymentRepository()),
        child: BlocListener<PaymentsBloc, PaymentsState>(
          listener: (context, state) {
            if (state is PaymentsSuccess) {
              // Navigate back to payments view after success
              context.go('/home/3/payments');
            } else if (state is PaymentsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  CreditCardWidget(
                    cardNumber: _cardNumber,
                    expiryDate: _expiryDate,
                    cardHolderName: _cardHolderName,
                    cvvCode: _cvvCode,
                    showBackView: _isCvvFocused,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    cardBgColor: _detectedBrand != null
                        ? getCardBackgroundColor(_detectedBrand!)
                        : _cardBackgroundColor,
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange: _updateCreditCardBrand,
                    customCardTypeIcons: <CustomCardTypeIcon>[
                      CustomCardTypeIcon(
                        cardType: CardType.mastercard,
                        cardImage: Image.asset(
                          'assets/images/mastercard.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          CreditCardForm(
                            formKey: _formKey,
                            obscureCvv: false,
                            obscureNumber: false,
                            cardNumber: _cardNumber,
                            cvvCode: _cvvCode,
                            isHolderNameVisible: true,
                            isCardNumberVisible: true,
                            isExpiryDateVisible: true,
                            cardHolderName: _cardHolderName,
                            expiryDate: _expiryDate,
                            onCreditCardModelChange: (CreditCardModel? model) {
                              setState(() {
                                _cardNumber = model!.cardNumber;
                                _expiryDate = model.expiryDate;
                                _cardHolderName = model.cardHolderName;
                                _cvvCode = model.cvvCode;
                                _isCvvFocused = model.isCvvFocused;
                              });
                            },
                            inputConfiguration: InputConfiguration(
                              cardNumberDecoration: InputDecoration(
                                labelText: 'Número de tarjeta',
                                hintText: 'XXXX XXXX XXXX XXXX',
                                hintStyle:
                                    const TextStyle(color: Colors.black),
                                labelStyle: const TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              expiryDateDecoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.black),
                                labelStyle: const TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                    width: 2.0,
                                  ),
                                ),
                                labelText: 'MM/YY',
                                hintText: 'XX/XX',
                              ),
                              cvvCodeDecoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.black),
                                labelStyle: const TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                    width: 2.0,
                                  ),
                                ),
                                labelText: 'CVV',
                                hintText: 'XXX',
                              ),
                              cardHolderDecoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.black),
                                labelStyle: const TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                    width: 2.0,
                                  ),
                                ),
                                labelText: 'Nombre de tarjeta',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: const Color(0xff1b447b),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              child: const Text(
                                'Añadir tarjeta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'halter',
                                  fontSize: 14,
                                  package: 'flutter_credit_card',
                                ),
                              ),
                            ),
                            onPressed: () {
                              /*if (_formKey.currentState!.validate()) {
                                final creditCard = CreditCard(
                                  cardNumberHidden:
                                      _cardNumber.replaceAllMapped(
                                          RegExp(r'\d{4}(?=.*\d)'),
                                          (match) => 'XXXX'),
                                  cardNumber: _cardNumber,
                                  brand: (_detectedBrand!.brandName).toString(),
                                  cvv: _cvvCode,
                                  expiracyDate: _expiryDate,
                                  cardHolderName: _cardHolderName,
                                );
                                context
                                    .read<PaymentsBloc>()
                                    .add(AddCreditCardEvent(creditCard));
                              }*/
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getCardBackgroundColor(CreditCardBrand brand) {
    switch (brand.brandName) {
      case CardType.mastercard:
        return Colors.orange.shade300;
      case CardType.visa:
        return Colors.blue.shade200;
      case CardType.americanExpress:
        return Colors.blueGrey.shade800;
      case CardType.discover:
        return Colors.orange.shade600;
      case CardType.elo:
        return Colors.red.shade300;
      case CardType.rupay:
        return Colors.blue.shade800;
      case CardType.unionpay:
        return Colors.lightBlue.shade200;
      default:
        return Colors.grey.shade200;
    }
  }
}
*/

import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}