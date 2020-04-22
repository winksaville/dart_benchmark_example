// Import BenchmarkBase class.
import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter, PrintEmitter;

// Create a new benchmark by extending BenchmarkBase
class BenchmarkBaseX {
  // Empty constructor.
  const BenchmarkBaseX(this.name, {this.emitter=const PrintEmitter()});

  final String name;
  final ScoreEmitter emitter;



  // The benchmark code.
  // This function is not used, if both [warmup] and [exercise] are overridden.
  void run() {}

  // Runs a short version of the benchmark. By default invokes [run] once.
  void warmup() {
    run();
  }

  // Exercices the benchmark. By default invokes [run] 10 times.
  void exercise() {
    for (int i = 0; i < 10; i++) {
      run();
    }
  }

  // Not measured setup code executed prior to the benchmark runs.
  void setup() {}

  // Not measured teardown code executed after the benchmark runs.
  void teardown() {}

  // Measures the score for this benchmark by executing it repeately until
  // time minimum has been reached.
  static double measureFor(Function f, int minimumMillis) {
    int iter = 0;
    final int minimumMicros = minimumMillis * 1000;
    final Stopwatch watch = Stopwatch();
    watch.start();
    int elapsed = 0;
    while (elapsed < minimumMicros) {
      f();
      elapsed = watch.elapsedMicroseconds;
      iter++;
    }
    return elapsed / iter;
  }

  /// Extended version of measure which allows control of warmup and run time
  double measure({int warmupMillis=100, int minRunInMillis=2000}) {
    setup();
    // Warmup and discard result.
    measureFor(() {
      warmup();
    }, warmupMillis);
    // Run the benchmark
    final double result = measureFor(() {
      exercise();
    }, minRunInMillis);
    teardown();
    return result;
  }

  void report({int warmupMillis=100, int minRunInMillis=2000}) {
    emitter.emit(name, measure(warmupMillis: warmupMillis, minRunInMillis: minRunInMillis));
  }
}
