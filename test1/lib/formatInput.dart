import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test1/main.dart';

class FonctionFormatInputNumeroCarte extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    if (getCardType(newText) == 'amex') {
      if (newText.length <= 15) {
        StringBuffer buffer = StringBuffer();
        for (int i = 0; i < newText.length; i++) {
          buffer.write(newText[i]);
          if (i == 3 || i == 9) {
            buffer.write(' ');
          }
        }

        String number = buffer.toString();
        return newValue.copyWith(
          text: number,
          selection: TextSelection.collapsed(offset: number.length),
        );
      }
    } else {
      if (newText.length <= 16) {
        StringBuffer buffer = StringBuffer();
        for (int i = 0; i < newText.length; i++) {
          buffer.write(newText[i]);
          int saut = i + 1;
          if (saut % 4 == 0 && newText.length > newText.length - 4) {
            buffer.write(' ');
          }
        }

        String number = buffer.toString();
        return newValue.copyWith(
          text: number,
          selection: TextSelection.collapsed(offset: number.length),
        );
      }
    }

    return oldValue;
  }
}
