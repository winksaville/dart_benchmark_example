import 'dart:math' show pow, ln10, log;

// From: https://math.stackexchange.com/a/1425065
double log10(double n) {
  return log(n) / ln10;
}

class SecondTimeUnits {
  SecondTimeUnits(this.factor, this.unitsName);

  static const int _kMaxDecimalPlaces = 15;
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
    if (value.isNaN || value == 0 || value >= 1) {
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
  /// value: is the value to convert, an NaN is converted to 0
  /// decimalPlaces: is the number of digits to the right of the decimal point.
  ///
  /// returns: a String
  static String asString(double value, {int decimalPlaces = 3}) {
    if (value.isNaN) {
      value = 0;
    }

    int decPlaces = decimalPlaces;
    if (decPlaces <= 0) {
      decPlaces = 0;
    } else if (decPlaces > _kMaxDecimalPlaces) {
      decPlaces = _kMaxDecimalPlaces;
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
    int whole;
    int decimal;
    if (x.isFinite) {
      whole = x ~/ pow10;
      decimal = (x.abs() % pow10).toInt();
    } else {
      whole = 0;
      decimal = 0;
    }

    if (decPlaces <= 0) {
      return '$whole${stu.unitsName}';
    }


    // Convert the decimal to string starting at the least significant
    // digits, which are on the right.
    final List<int> decimalDigits = List<int>(decPlaces);
    const int zeroCharCode = 0x30;

    for (int i = decPlaces - 1; i >= 0; i--) {
      decimalDigits[i] = zeroCharCode + (decimal % 10).toInt();
      decimal ~/= 10;
      //print('digits[$i]=${decimalDigits[i]} '
      //    '\"${String.fromCharCode(decimalDigits[i])}\"');
    }

    if (x.isFinite) {
      return '$whole.${String.fromCharCodes(decimalDigits)}${stu.unitsName}';
    } else {
       String sign = x >= 0 ? '' : '-';
       return '${sign}inf.${String.fromCharCodes(decimalDigits)}${stu.unitsName}';
    }
  }
}
