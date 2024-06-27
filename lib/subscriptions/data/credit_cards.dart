import 'package:chapa_tu_bus_app/subscriptions/domain/entities/credit_card.dart';

final List<CreditCardEntity> tarjetas = <CreditCardEntity>[
  CreditCardEntity(
    cardNumberHidden: '4242',
    cardNumber: '4242424242424242',
    brand: 'visa',
    cvv: '213',
    expiracyDate: '01/25',
    cardHolderName: 'Fernando Herrera'
  ),
  CreditCardEntity(
    cardNumberHidden: '5555',
    cardNumber: '5555555555554444',
    brand: 'mastercard',
    cvv: '213',
    expiracyDate: '01/25',
    cardHolderName: 'Melissa Flores'
  ),
  CreditCardEntity(
    cardNumberHidden: '3782',
    cardNumber: '378282246310005',
    brand: 'american express',
    cvv: '2134',
    expiracyDate: '01/25',
    cardHolderName: 'Eduardo Rios'
  ),
  
];