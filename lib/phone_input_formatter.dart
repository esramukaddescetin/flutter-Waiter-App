import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.length > 10) {
      newText = newText.substring(0, 10);
    }
    if (newText.length == 0) {
      return TextEditingValue();
    }
    StringBuffer newTextBuffer = StringBuffer();
    newTextBuffer.write('(');
    newTextBuffer.write(newText.substring(0, 3));
    newTextBuffer.write(') ');
    if (newText.length > 3) {
      newTextBuffer.write(newText.substring(3, 6));
      newTextBuffer.write('-');
    }
    if (newText.length > 6) {
      newTextBuffer.write(newText.substring(6, 8));
      newTextBuffer.write('-');
    }
    if (newText.length > 8) {
      newTextBuffer.write(newText.substring(8, 10));
    }
    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(offset: newTextBuffer.length),
    );
  }
}
