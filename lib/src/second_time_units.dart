import 'dart:math' show pow;
import 'package:dart_numerics/dart_numerics.dart' show log10;

class SecondTimeUnits {
  SecondTimeUnits(this.factor, this.unitsName);

  static const int kMaxDecimalPlaces = 15;
  double factor;
  String unitsName;

  static final List<SecondTimeUnits> _timeUnits = <SecondTimeUnits>[
    SecondTimeUnits(1e0, 's'),
    SecondTimeUnits(1e3, 'ms'),
    SecondTimeUnits(1e3, 'ms'),
    SecondTimeUnits(1e3, 'ms'),
    SecondTimeUnits(1e6, 'us'),
    SecondTimeUnits(1e6, 'us'),
    SecondTimeUnits(1e6, 'us'),
    SecondTimeUnits(1e9, 'ns'),
    SecondTimeUnits(1e9, 'ns'),
    SecondTimeUnits(1e9, 'ns'),
    SecondTimeUnits(1e12, 'ps'),
    SecondTimeUnits(1e12, 'ps'),
    SecondTimeUnits(1e12, 'ps'),
    SecondTimeUnits(1e15, 'fs'),
    SecondTimeUnits(1e15, 'fs'),
    SecondTimeUnits(1e15, 'fs'),
    SecondTimeUnits(0, 's'),
  ];

  static SecondTimeUnits info(double value) {
    value = value.abs();
    if (value == 0 || value >= 1) {
      return _timeUnits[0];
    } else {
      final int log10v = log10(value).toInt().abs() + 1;
      if (log10v < (_timeUnits.length - 1)) {
        return _timeUnits[log10v];
      } else {
        return _timeUnits[_timeUnits.length - 1];
      }
    }
  }

  /// Converts value, which is time in seconds, to a decimal a string and
  /// appends the units on to the end of the string.
  ///
  /// value: is the value to convert
  /// decimalPlaces: is the number of digits to the right of the decimal point.
  ///
  /// returns: a String
  static String asString(double value, {int decimalPlaces = 3}) {
    int decPlaces = decimalPlaces;
    if (decPlaces <= 0) {
      decPlaces = 0;
    } else if (decPlaces > kMaxDecimalPlaces) {
      decPlaces = kMaxDecimalPlaces;
    }

    final SecondTimeUnits stu = info(value);
    if (stu.factor <= 0) {
      // Value is too small for us to print
      // just return the typical output
      return '$value${stu.unitsName}';
    }

    // Compute the "whole number", i.e. value left of decimal point.
    final double pow10 = pow(10, decPlaces).toDouble();
    final double x = (value * stu.factor * pow10).roundToDouble();
    final int whole = x ~/ pow10;

    if (decPlaces <= 0) {
      return '$whole${stu.unitsName}';
    }

    // Compute the "decimal number", i.e. value right of the decimal point.
    int decimal = (x.abs() % pow10).toInt();

    // Convert the decimal to string starting at the least significant
    // digits, which are on the right. I.e. fill "dd"
    final List<int> decimalDigits = List<int>(decPlaces);
    const int zeroCharCode = 0x30;

    for (int i = decPlaces - 1; i >= 0; i--) {
      decimalDigits[i] = zeroCharCode + (decimal % 10).toInt();
      decimal ~/= 10;
      //print('digits[$i]=${decimalDigits[i]} '
      //    '\"${String.fromCharCode(decimalDigits[i])}\"');
    }

    return '$whole.${String.fromCharCodes(decimalDigits)}${stu.unitsName}';
  }
}
