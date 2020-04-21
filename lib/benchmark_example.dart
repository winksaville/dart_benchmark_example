// Import BenchmarkBase class.
import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';

// Create a new benchmark by extending BenchmarkBase
class EmptyBenchmark extends BenchmarkBase {
  const EmptyBenchmark(String name, {ScoreEmitter emitter = const PrintEmitter()})
      : super(name, emitter: emitter);

  // The benchmark code.
  @override
  void run() {}

  // Not measured setup code executed prior to the benchmark runs.
  @override
  void setup() {}

  // Not measured teardown code executed after the benchmark runs.
  @override
  void teardown() {}

  /// Extended version of measure which allows control of warmup and run time
  double measureX({int warmupMillis=100, int minRunInMillis=2000}) {
    setup();

    // Warmup and discard result.
    BenchmarkBase.measureFor(() {
      super.warmup();
    }, warmupMillis);

    // Run the benchmark
    final double result = BenchmarkBase.measureFor(() {
      super.exercise();
    }, minRunInMillis);

    teardown();
    return result;
  }

  /// Extended version of report which allows control of warmup and run time
  void reportX({int warmupMillis=100, int minRunInMillis=2000}) {
    emitter.emit(name, measureX(warmupMillis: warmupMillis, minRunInMillis: minRunInMillis));
  }
}
