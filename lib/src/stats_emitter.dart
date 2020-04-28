import 'package:benchmark_framework_x/benchmark_framework_x.dart';
import 'package:stats/stats.dart';

abstract class StatsEmitter {
  void emit(String testName, List<double> values);
}

class PrintEmitter implements StatsEmitter {
  const PrintEmitter();

  @override
  void emit(String testName, List<double> measurements) {
    final Stats<double> stats = Stats<double>.fromData(measurements);
    print('$testName ${measurementToString(stats)}');
  }
}

String measurementToString(Stats<double> stats) {
  return '{'
      'count: ${stats.count}, '
      'average: ${SecondTimeUnits.asString(stats.average.toDouble())}  '
      'min: ${SecondTimeUnits.asString(stats.min.toDouble())}  '
      'max: ${SecondTimeUnits.asString(stats.max.toDouble())}  '
      'median: ${SecondTimeUnits.asString(stats.median.toDouble())}  '
      'standardDeviation: ${SecondTimeUnits.asString(stats.standardDeviation.toDouble())}'
      '}';
}
