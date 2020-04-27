import 'package:benchmark_framework_x/benchmark_framework_x.dart';
import 'package:test/test.dart';

class BenchmarkDelayMicros extends BenchmarkBaseX {
  BenchmarkDelayMicros(String name, this.delayMicros) : super(name);

  int delayMicros;
  Stopwatch watch = Stopwatch();

  @override
  void run() {
    watch.reset();
    watch.start();
    while (watch.elapsedMicroseconds < delayMicros) {}
  }
}

void main() {
  test('Estimate', () {
    final BenchmarkDelayMicros bm = BenchmarkDelayMicros('Estimate1', 100);

    bm.setup();
    const double searchTimeInSecs = 0.250;
    const double executionTimeInSecs = 2.0;
    const int samples = 100;
    final int innerLoops = bm.estimateInnerLoops(
        searchTimeInSecs, bm.exercise, executionTimeInSecs, samples);
    bm.teardown();

    //print('innerLoops=$innerLoops');
    expect((innerLoops >= 199) && (innerLoops <= 201), isTrue);
  });
}
