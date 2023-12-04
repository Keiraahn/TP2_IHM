import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

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

  void updateCardNumber(String newNumber) {
    setState(() {
      // Supprime tous les espaces pour ne travailler qu'avec des chiffres purs
      String pureNumber = newNumber.replaceAll(' ', '');

      // Remplace les caractères '#' dans cardNumber par les chiffres de pureNumber
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
    debugPrint(boolCvv.toString());
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 27, 17, 2),
          appBar: AppBar(
            title: const Text('Payment Details'),
          ),
          body: Center(
              child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                  child: MyDropdownButton(
                      (valueNumber) => setState(() => cardNumber = valueNumber),
                      (valueName) => setState(() => cardName = valueName),
                      (valueMonth) => setState(() => month = valueMonth),
                      (valueYear) => setState(() => year = valueYear),
                      updateCardNumber,
                      (valueCvv) => setState(() => boolCvv = valueCvv),
                      (currentCvv) => setState(() => CVV = currentCvv))),
              Positioned(
                top: 30,
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
          ))),
    );
  }
}

class MyDropdownButton extends StatefulWidget {
  final Function(String valueNumber) cardNumberChange;
  final Function(String valueName) cardNameChange;
  final Function(String valueYear) yearChange;
  final Function(String valueMonth) monthChange;
  final Function(String) cardNumberUpdate;
  final Function(bool) onCvvSelected;
  final Function(String) CVV;

  const MyDropdownButton(
      this.cardNumberChange,
      this.cardNameChange,
      this.monthChange,
      this.yearChange,
      this.cardNumberUpdate,
      this.onCvvSelected,
      this.CVV,
      {super.key});
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton>
    with SingleTickerProviderStateMixin {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final FocusNode cvvFocus = FocusNode();
  String cardType = 'visa';
  String expirationYear = '2024';
  String expirationMonth = '01';
  String CVV = '';

  _MyDropdownButtonState() {
    cvvFocus.addListener(onCvvSelected);
  }

  void onCvvSelected() {
    widget.onCvvSelected(cvvFocus.hasFocus);
  }

  void resetFields() {
    cardNumberController.clear();
    cardNameController.clear();
    cvvController.clear();
  }

  @override
  void initState() {
    super.initState();
    cardNumberController.addListener(_updateCardType);
  }

  @override
  void dispose() {
    cardNumberController.removeListener(_updateCardType);
    cardNumberController.dispose();
    super.dispose();
  }

  void onMonthChanged(String newMonth) {
    setState(() {
      expirationMonth = newMonth;
    });
  }

  void onYearChanged(String newYear) {
    setState(() {
      expirationYear = newYear;
    });
  }

  void _updateCardType() {
    String type = getCardType(cardNumberController.text);
    setState(() {
      cardType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 300,
            height: 450,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 167, 198, 229),
              border:
                  Border.all(color: const Color.fromARGB(255, 246, 244, 244)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    child: TextField(
                      onChanged: (value) {
                        widget.cardNumberChange(value);
                        widget.cardNumberUpdate(value);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(19),
                        FilteringTextInputFormatter.digitsOnly,
                        FonctionFormatInputNumeroCarte(),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Number',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      // width: ,
                      child: TextField(
                    onChanged: (value) {
                      widget.cardNameChange(value);
                    },
                    controller: cardNameController,
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Card Holder',
                    ),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          child: Dropdown(
                        choices: const [
                          '01',
                          '02',
                          '03',
                          '04',
                          '05',
                          '06',
                          '07',
                          '08',
                          '09',
                          '10',
                          '11',
                          '12',
                        ],
                        label: 'Expiration date',
                        onSelected: (value) {
                          widget.monthChange(value);
                        },
                      )),
                      SizedBox(
                          child: Dropdown(
                        choices: const [
                          '2024',
                          '2025',
                          '2026',
                          '2027',
                          '2028',
                          '2029',
                          '2030',
                        ],
                        label: '',
                        onSelected: (value) {
                          widget.yearChange(value);
                        },
                      )),
                      SizedBox(
                          width: 100,
                          height: 50,
                          child: TextField(
                            onChanged: (value) {
                              widget.CVV(value);
                            },
                            focusNode: cvvFocus,
                            controller: cvvController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'CVV',
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: resetFields,
                      child: const Text('Submit'),
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}

class Dropdown extends StatefulWidget {
  final List<String> choices;
  final String label;
  final Function(String) onSelected;
  const Dropdown(
      {super.key,
      required this.choices,
      required this.label,
      required this.onSelected});

  @override
  State<Dropdown> createState() => _DropDownState(choices);
}

class _DropDownState extends State<Dropdown> {
  late String value = '';
  List<String> choices = [];
  _DropDownState(this.choices) {
    value = choices.first;
  }

  @override
  void initState() {
    super.initState();
    value = widget.choices.first; // Initialisation de la valeur
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: value,
            elevation: 16,
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            onChanged: (String? newValue) {
              setState(() {
                value = newValue!;
              });
              widget.onSelected(newValue!);
            },
            items: widget.choices.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()),
      ),
    ]);
  }
}

class FonctionFormatInputNumeroCarte extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    if (newText.length <= 16) {
      StringBuffer buffer = StringBuffer();
      for (int i = 0; i < newText.length; i++) {
        buffer.write(newText[i]);
        int saut = i + 1;
        if (saut % 4 == 0 && saut != newText.length) {
          buffer.write(' ');
        }
      }

      String number = buffer.toString();
      return newValue.copyWith(
        text: number,
        selection: TextSelection.collapsed(offset: number.length),
      );
    }
    return oldValue;
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

class CreditCardImage extends StatelessWidget {
  final String cardNumber;

  const CreditCardImage({Key? key, required this.cardNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cardType = getCardType(cardNumber);
    String imagePath = 'assets/$cardType.png';

    return Stack(
      children: [
        Positioned(
          right: 16,
          top: 20,
          child: Image.asset(
            imagePath,
            width: 60,
            height: 40,
          ),
        ),
      ],
    );
  }
}

class FlipCard extends StatefulWidget {
  final String cardNumber;
  final String cardName;
  final String year;
  final String month;
  final bool boolCvv;
  final String CVV;
  const FlipCard(this.cardNumber, this.cardName, this.year, this.month,
      this.boolCvv, this.CVV,
      {super.key});

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    if (widget.boolCvv) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.boolCvv != oldWidget.boolCvv) {
      _flipImage();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipImage() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        return Transform(
            // Appliquer l'effet miroir à 0.5 pour montrer l'autre image
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(2 * math.pi * _flipAnimation.value),
            alignment: Alignment.center,
            child: _flipAnimation.value < 0.5
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          'assets/7.jpeg',
                          width: 250,
                          height: 160,
                        ),
                      ),
                      Positioned(
                          left: 16,
                          right: 16,
                          top: 75,
                          bottom: 30,
                          child: Text(
                            widget.cardNumber,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: Image.asset(
                          'assets/chip.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Positioned(
                          right: 16,
                          top: 12,
                          child: Image.asset(
                            'assets/${getCardType(widget.cardNumber)}.png',
                            width: 50,
                            height: 50,
                          )),
                      Positioned(
                          bottom: 16,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Card Holder',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                              Text(
                                widget.cardName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),

                              // Text
                            ],
                          )),
                      Positioned(
                          bottom: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Expiration date',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                              Text(widget.year + '/' + widget.month),
                            ],
                          ))
                    ],
                  )
                : Stack(clipBehavior: Clip.none, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/7.jpeg',
                        width: 250,
                        height: 160,
                      ),
                    ),
                    Positioned(
                        top: 20,
                        child: Container(
                          width: 250,
                          height: 25,
                          color: Colors.black,
                        )),
                    Positioned(
                        top: 50,
                        right: 16,
                        child: Text(
                          'Cvv',
                          style: TextStyle(color: Colors.white),
                        )),
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 230,
                            height: 20,
                            color: Colors.white,
                            child: Text(
                              widget.CVV,
                              textAlign: TextAlign.right,
                            ),
                          )),
                    ),
                    Positioned(
                        right: 16,
                        bottom: 2,
                        child: Image.asset(
                          'assets/${getCardType(widget.cardNumber)}.png',
                          width: 50,
                          height: 50,
                        )),
                  ]));
      },
    );
  }
}
