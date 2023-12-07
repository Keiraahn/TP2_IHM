import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'dropDown.dart';
import 'formatInput.dart';

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
  late ValueNotifier<int> maxLengthNotifier;

  String cardType = 'visa';
  String expirationYear = '2024';
  String expirationMonth = '01';
  String CVV = '';
  bool isButtonDisabled = true;
  int testlength = 1;

  _MyDropdownButtonState() {
    cvvFocus.addListener(onCvvSelected);
  }

  void onCvvSelected() {
    widget.onCvvSelected(cvvFocus.hasFocus);
  }

  void _updateCardType() {
    String type = getCardType(cardNumberController.text);
    setState(() {
      cardType = type;
    });
  }

  @override
  void initState() {
    super.initState();
    maxLengthNotifier = ValueNotifier(updatelength());
    cardNumberController.addListener(_updateCardType);
    cardNumberController.addListener(updateMaxLength);
  }

  void updateMaxLength() {
    int newLength = updatelength();
    if (maxLengthNotifier.value != newLength) {
      maxLengthNotifier.value = newLength;
    }
  }

  @override
  void dispose() {
    cardNumberController.removeListener(_updateCardType);
    cardNumberController.removeListener(updateMaxLength);
    cardNumberController.dispose();
    maxLengthNotifier.dispose();
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

  int updatelength() {
    if (getCardType(cardNumberController.text) == 'amex') {
      return testlength = 15;
    } else {
      return testlength = 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 300,
            height: 400,
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
                    child: ValueListenableBuilder(
                      valueListenable: maxLengthNotifier,
                      builder: (context, int maxLength, child) {
                        debugPrint(maxLength.toString());
                        return TextField(
                          controller: cardNumberController,
                          onChanged: (value) {
                            widget.cardNumberChange(value);
                            widget.cardNumberUpdate(value);
                            updateMaxLength();
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(maxLength),
                            FonctionFormatInputNumeroCarte(),
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Card Number',
                          ),
                        );
                      },
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
                      onPressed: isButtonDisabled ? null : null,
                      child: const Text('Submit'),
                    ),
                  )
                ]),
          ),
        ],
      ),
    ));
  }
}
