import 'package:flutter/material.dart';
import 'FlipCard.dart';
import 'MyDropDownButton.dart';
import 'dropDown.dart';
import 'formatInput.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyApp> {
  String cardNumber = '#### #### #### ####';
  String cardName = 'Adam Smith';
  String year = 'YYYY';
  String month = 'MM';
  bool boolCvv = false;
  String CVV = '';
  int cardHeight = 450;

  void updateCardNumber(String newNumber) {
    setState(() {
      String pureNumber = newNumber.replaceAll(' ', '');
      StringBuffer updatedNumber = StringBuffer();
      int index = 0;
      for (var char in cardNumber.split('')) {
        if (char == '#' && index < pureNumber.length) {
          updatedNumber.write(pureNumber[index]);
          index++;
        } else {
          updatedNumber.write(char);
        }
      }

      cardNumber = updatedNumber.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 17, 2),
      appBar: AppBar(
        title: const Text(
          'Payment Details',
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: SizedBox(
                  height: 600,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      MyDropdownButton(
                          (valueNumber) =>
                              setState(() => cardNumber = valueNumber),
                          (valueName) => setState(() => cardName = valueName),
                          (valueMonth) => setState(() => month = valueMonth),
                          (valueYear) => setState(() => year = valueYear),
                          updateCardNumber,
                          (valueCvv) => setState(() => boolCvv = valueCvv),
                          (currentCvv) => setState(() => CVV = currentCvv)),
                      Positioned(
                        top: 20,
                        child: FlipCard(
                          cardNumber,
                          cardName,
                          month,
                          year,
                          boolCvv,
                          CVV,
                        ),
                      ),
                    ],
                  )))),
    ));
  }
}

String getCardType(String number) {
  RegExp visaRegex = RegExp(r"^4");
  if (visaRegex.hasMatch(number)) return "visa";

  RegExp amexRegex = RegExp(r"^(34|37)");
  if (amexRegex.hasMatch(number)) return "amex";

  RegExp mastercardRegex = RegExp(r"^5[1-5]");
  if (mastercardRegex.hasMatch(number)) return "mastercard";

  RegExp discoverRegex = RegExp(r"^6011");
  if (discoverRegex.hasMatch(number)) return "discover";

  RegExp troyRegex = RegExp(r'^9792');
  if (troyRegex.hasMatch(number)) return 'troy';

  return "visa";
}
