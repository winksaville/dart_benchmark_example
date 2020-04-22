// Import BenchmarkBase class.
import 'package:benchmark_harness/benchmark_harness.dart'
    show ScoreEmitter, PrintEmitter;
import 'package:intl/intl.dart';

typedef int IntFunc(int loops);

// Create a new benchmark by extending BenchmarkBase
class BenchmarkBaseX {
  // Empty constructor.
  const BenchmarkBaseX(this.name, {this.emitter = const PrintEmitter()});

  final String name;
  final ScoreEmitter emitter;

  // The benchmark code.
  // This function is not used, if both [warmup] and [exercise] are overridden.
  void run() {}

  // Runs a short version of the benchmark. By default invokes [run] once.
  int warmup(int loops) {
    for (int i = 0; i < loops; i++) {
      run();
    }
    return loops;
  }

  // Exercices the benchmark. Returns number of times it looped over [run].
  int exercise(int loops) {
    for (int i = 0; i < loops; i++) {
      run();
    }
    return loops;
  }

  // Not measured setup code executed prior to the benchmark runs.
  void setup() {}

  // Not measured teardown code executed after the benchmark runs.
  void teardown() {}

  // Measures the score for this benchmark by executing it repeately until
  // time minimum has been reached.
  static double measureFor(
      IntFunc exerciseFunc, int minimumMillis, int innerLoops, bool verbose) {
    int iter = 0;
    final Stopwatch watch = Stopwatch();
    final double minimumTicks =
        (watch.frequency.toDouble() * minimumMillis.toDouble()) / 1000.0;
    final int intMinimumTicks = minimumTicks.toInt();
    watch.start();
    int elapsed = 0;
    int loops = 0;
    while (elapsed < intMinimumTicks) {
      final int actualLoops = exerciseFunc(innerLoops);
      elapsed = watch.elapsedTicks;
      iter += actualLoops;
      loops += 1;
    }

    final double timeInSecs = elapsed.toDouble() / watch.frequency.toDouble();
    final double timeInMicros = timeInSecs * 1000000.0;
    final double timePerIterInMicros = timeInMicros / iter.toDouble();
    if (verbose) {
      final NumberFormat f6 = NumberFormat('#,##0.000000');
      final NumberFormat f0 = NumberFormat('#,##0');
      print('time: ${f6.format(timeInSecs)} s  '
          'loops: ${f0.format(loops).padLeft(6)}  '
          'elapsedTicks: ${f0.format(elapsed)}  '
          'iter: ${f0.format(iter)}  '
          'timePerInnerLoop: ${f6.format(timeInSecs / loops * 1000000.0)} us  '
          'timePerIteraton: ${f6.format(timePerIterInMicros)} us');
    }
    return timePerIterInMicros;
  }

  /// Extended version of measure which allows control of warmup and run time
  double measure(
      {int warmUpInMillis = 100,
      int minExerciseInMillis = 2000,
      int innerLoops = 10,
      bool verboseWarmUp = false,
      bool verboseExercise = false}) {
    setup();
    // Warmup and discard result.
    measureFor(warmup, warmUpInMillis, 1, verboseWarmUp);
    // Run the benchmark
    final double result =
        measureFor(exercise, minExerciseInMillis, innerLoops, verboseExercise);
    teardown();
    return result;
  }

  void report({int warmUpInMillis = 250, int minExerciseInMillis = 2000}) {
    emitter.emit(
        name,
        measure(
            warmUpInMillis: warmUpInMillis,
            minExerciseInMillis: minExerciseInMillis));
  }
}
