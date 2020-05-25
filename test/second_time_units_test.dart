import 'package:benchmark_framework_x/benchmark_framework_x.dart';
import 'package:test/test.dart';

void main() {
  group('SecondsTimeUnits.info', () {
    test('infinity seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(double.infinity);
      expect(result.factor, 1);
      expect(result.unitsName, 's');
    });

    test('negativeInfinity seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(-double.negativeInfinity);
      expect(result.factor, 1);
      expect(result.unitsName, 's');
    });

    test('nan seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(double.nan);
      expect(result.factor, 1);
      expect(result.unitsName, 's');
    });

    test('-nan seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(-double.nan);
      expect(result.factor, 1);
      expect(result.unitsName, 's');
    });

    test('10.0 seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(10.0);
      expect(result.factor, 1);
      expect(result.unitsName, 's');
    });

    test('10.0 seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(10.0);
      expect(result.factor, 1);
      expect(result.unitsName, 's');
    });

    test('1.123456 seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(1.123456);
      expect(result.factor, 1);
      expect(result.unitsName, 's');
    });

    test('-1.23456 seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(-1.23456);
      expect(result.factor, 1);
      expect(result.unitsName, 's');
    });

    test('0.1 seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(0.1);
      expect(result.factor, 1e3);
      expect(result.unitsName, 'ms');
    });

    test('123e-3 seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(123e-3);
      expect(result.factor, 1e3);
      expect(result.unitsName, 'ms');
    });

    test('1e-4 seconds', () {
      final SecondTimeUnits result = SecondTimeUnits.info(1e-4);
      expect(result.factor, 1e6);
      expect(result.unitsName, 'us');
    });
  });

  group('SecondsTimeUnits.asString', () {
    test('infinity seconds', () {
      final String result = SecondTimeUnits.asString(double.infinity, decimalPlaces: 2);
      expect(result, 'inf.00s');
    });

    test('minus Infinity seconds', () {
      final String result = SecondTimeUnits.asString(-double.infinity, decimalPlaces: 2);
      expect(result, '-inf.00s');
    });

    test('negativeInfinity seconds', () {
      final String result = SecondTimeUnits.asString(double.negativeInfinity, decimalPlaces: 2);
      expect(result, '-inf.00s');
    });

    test('minus negativeInfinity seconds', () {
      final String result = SecondTimeUnits.asString(-double.negativeInfinity, decimalPlaces: 2);
      expect(result, 'inf.00s');
    });

    test('NaN seconds', () {
      final String result = SecondTimeUnits.asString(double.nan, decimalPlaces: 2);
      expect(result, '0.00s');
    });

    test('-NaN seconds', () {
      final String result = SecondTimeUnits.asString(-double.nan, decimalPlaces: 2);
      expect(result, '0.00s');
    });

    test('10 seconds with negative decimalPlaces', () {
      final String result = SecondTimeUnits.asString(10.0, decimalPlaces: -1);
      expect(result, '10s');
    });

    test('10.49 seconds 0 decimalPlaces rounds towards 0', () {
      final String result = SecondTimeUnits.asString(10.49, decimalPlaces: 0);
      expect(result, '10s');
    });

    test('10.5 seconds 0 decimalPlaces rounds away from 0', () {
      final String result = SecondTimeUnits.asString(10.5, decimalPlaces: 0);
      expect(result, '11s');
    });

    test('10.5 seconds 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(10.5, decimalPlaces: 1);
      expect(result, '10.5s');
    });

    test('10.5554 3 decimalPlaces rounds towards 0', () {
      final String result = SecondTimeUnits.asString(10.5554, decimalPlaces: 3);
      expect(result, '10.555s');
    });

    test('10.5555 seconds 3 decimalPlaces rounds away from 0', () {
      final String result = SecondTimeUnits.asString(10.5555, decimalPlaces: 3);
      expect(result, '10.556s');
    });

    test('1 second 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(1.0, decimalPlaces: 0);
      expect(result, '1s');
    });

    test('1 second 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(1.0, decimalPlaces: 1);
      expect(result, '1.0s');
    });

    test('1 second 2 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(1.0, decimalPlaces: 2);
      expect(result, '1.00s');
    });

    test('-1 second 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-1.0, decimalPlaces: 0);
      expect(result, '-1s');
    });

    test('-1 second 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-1.0, decimalPlaces: 1);
      expect(result, '-1.0s');
    });

    test('-1 second 2 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-1.0, decimalPlaces: 2);
      expect(result, '-1.00s');
    });

    test('-1.4 second 0 decimalPlaces round townards 0', () {
      final String result = SecondTimeUnits.asString(-1.4, decimalPlaces: 0);
      expect(result, '-1s');
    });

    test('-1.5 second 0 decimalPlaces round away from 0', () {
      final String result = SecondTimeUnits.asString(-1.5, decimalPlaces: 0);
      expect(result, '-2s');
    });

    test('999 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(0.999, decimalPlaces: 0);
      expect(result, '999ms');
    });

    test('-999 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-0.999, decimalPlaces: 0);
      expect(result, '-999ms');
    });
    test('999.4 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(0.9994, decimalPlaces: 0);
      expect(result, '999ms');
    });

    // TODO(wink): Should this round to 1s?
    test('999.5 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(0.9995, decimalPlaces: 0);
      expect(result, '1000ms');
    });

    // TODO(wink): Should this round to -1s?
    test('-999.5 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-0.9995, decimalPlaces: 0);
      expect(result, '-1000ms');
    });

    test('999.5 milliseconds 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(0.9995, decimalPlaces: 1);
      expect(result, '999.5ms');
    });

    test('-999.5 milliseconds 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-0.9995, decimalPlaces: 1);
      expect(result, '-999.5ms');
    });

    test('999.5 milliseconds 2 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(0.9995, decimalPlaces: 2);
      expect(result, '999.50ms');
    });

    test('-999.5 milliseconds 2 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-0.9995, decimalPlaces: 2);
      expect(result, '-999.50ms');
    });

    test('999.1 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(0.9991, decimalPlaces: 0);
      expect(result, '999ms');
    });

    test('-999.1 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-0.9991, decimalPlaces: 0);
      expect(result, '-999ms');
    });

    test('1 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(1e-3, decimalPlaces: 0);
      expect(result, '1ms');
    });

    test('-1 milliseconds 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-1e-3, decimalPlaces: 0);
      expect(result, '-1ms');
    });

    test('1.1 milliseconds 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(1.1e-3, decimalPlaces: 1);
      expect(result, '1.1ms');
    });

    test('-1.1 milliseconds 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-1.1e-3, decimalPlaces: 1);
      expect(result, '-1.1ms');
    });

    test('1.1 milliseconds 2 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(1.1e-3, decimalPlaces: 2);
      expect(result, '1.10ms');
    });

    test('-1.1 milliseconds 2 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(-1.1e-3, decimalPlaces: 2);
      expect(result, '-1.10ms');
    });

    test('123.49e-15 femtosecs 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(123.49e-15, decimalPlaces: 0);
      expect(result, '123fs');
    });

    test('123.49e-15 femtosecs 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(123.49e-15, decimalPlaces: 1);
      expect(result, '123.5fs');
    });

    test('123.49e-15 femtosecs 2 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(123.49e-15, decimalPlaces: 2);
      expect(result, '123.49fs');
    });

    test('123.499e-15 femtosecs 2 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(123.499e-15, decimalPlaces: 2);
      expect(result, '123.50fs');
    });

    test('1.49e-15 femtosecs 0 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(1.49e-15, decimalPlaces: 0);
      expect(result, '1fs');
    });

    test('1.49e-15 femtosecs 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(1.49e-15, decimalPlaces: 1);
      expect(result, '1.5fs');
    });

    test('0.149e-15 femtosecs 1 decimalPlaces', () {
      final String result = SecondTimeUnits.asString(0.149e-15, decimalPlaces: 3);
      expect(result, '1.49e-16s');
    });

    test('1.49e-16 to small decimal places ignored', () {
      final String result = SecondTimeUnits.asString(1.49e-16, decimalPlaces: 2);
      expect(result, '1.49e-16s');
    });

    test('1e-323 way to small decimal places are ignored', () {
      final String result = SecondTimeUnits.asString(1e-323, decimalPlaces: 2);
      expect(result, '1e-323s');
    });

    test('1e-324 very close to 0 prints as 0s', () {
      final String result = SecondTimeUnits.asString(1e-324, decimalPlaces: 0);
      expect(result, '0s');
    });

    test('1e-324 very close to 0 as 0.0s decimal places not ignored', () {
      final String result = SecondTimeUnits.asString(1e-324, decimalPlaces: 1);
      expect(result, '0.0s');
    });
  });
}
