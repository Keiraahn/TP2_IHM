import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test1/main.dart';

class FonctionFormatInputNumeroCarte extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    StringBuffer buffer = StringBuffer();

    bool isDeleting = newValue.text.length < oldValue.text.length;
    int lastNonSpaceIndex = oldValue.text.length - 1;
    while (lastNonSpaceIndex >= 0 && oldValue.text[lastNonSpaceIndex] == ' ') {
      lastNonSpaceIndex--;
    }

    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      int nextIndex = i + 1;
      if (getCardType(newText) == 'amex') {
        if ((i == 3 || i == 9) &&
            !(isDeleting && nextIndex >= lastNonSpaceIndex)) {
          buffer.write(' ');
        }
      } else {
        if (nextIndex % 4 == 0 &&
            nextIndex != newText.length &&
            !(isDeleting && nextIndex >= lastNonSpaceIndex)) {
          buffer.write(' ');
        }
      }
    }

    String formattedText = buffer.toString();
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
