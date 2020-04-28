import 'package:intl/intl.dart';

import 'stats_emitter.dart';

// Create a new benchmark by extending BenchmarkBase
class BenchmarkBaseX {
  // Empty constructor.
  const BenchmarkBaseX(this.name, {this.emitter = const PrintEmitter()});

  static const int kWarmUpInMillisDefault = 200;
  static const int kExcerciseInMillisDefault = 2000;
  static const int kInnerLoopsDefault = 10;
  static const int kSampleCountDefault = 100;
  static const double kEstimateInnerLoopsErrorFactorDefault = 10 / 100;
  static const double kCalcuationThreadholdDefault = 0.50;

  final String name;
  final StatsEmitter emitter;

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
  static double measureFor(int Function(int) exerciseFunc, int minimumMillis,
      int innerLoops, bool verbose) {
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
      {int warmUpInMillis = kWarmUpInMillisDefault,
      int minExerciseInMillis = kExcerciseInMillisDefault,
      int innerLoops = kInnerLoopsDefault,
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

  void report(
      {int sampleCount = kSampleCountDefault,
      int warmUpInMillis = kWarmUpInMillisDefault,
      int minExerciseInMillis = kExcerciseInMillisDefault}) {
    emitter.emit(
        name,
        measureSamples(sampleCount: sampleCount,
            warmUpInMillis: warmUpInMillis,
            minExerciseInMillis: minExerciseInMillis));
  }

  /// Estaimate the number of innerloops needed to run exerciseFunc
  /// for a specifc period of time.
  ///
  /// searchTimeInSecs: is the maxim amount of time this routine will execute
  /// exerciseFunc: is the routine called to excercies this.run()
  /// executionTimeInSecs: is the time target time exerciseFunc shoudl runt
  /// initialGuess: the initialValue that will be passed to exerciseFunc
  int estimateInnerLoopsFor(
      double searchTimeInSecs,
      int Function(int) exerciseFunc,
      double executionTimeInSecs,
      int initialGuess,
      bool verbose) {
    final Stopwatch watch = Stopwatch();

    final double searchTimeInMicros = searchTimeInSecs * 1000000.0;
    final double executionTimeInMicros = executionTimeInSecs * 1000000.0;

    // innerLoops must be >= 1
    int innerLoops = initialGuess >= 1 ? initialGuess : 1;

    // Calculation threashold
    final double calculationThresholdInMicros =
        kCalcuationThreadholdDefault * executionTimeInMicros;
    if (verbose) {
      print('estimateInnerLoopsFor: '
          'searchTimeInSecs=$searchTimeInMicros'
          'executionTimeInMicros=$executionTimeInMicros '
          'calculationThresholdInMicros=calculationThresholdInMicros');
    }

    // Only spend upto searchTimeInMicros trying to estimate
    final Stopwatch timeoutWatch = Stopwatch();
    timeoutWatch.start();
    int attempts;
    for (attempts = 0;
        timeoutWatch.elapsedMicroseconds < searchTimeInMicros;
        attempts++) {
      if (verbose) {
        print('estimateInnerLoopsFor: top of loop innerLoops=$innerLoops '
            '-- ${attempts + 1} attempt(s) '
            'over ${timeoutWatch.elapsedTicks / timeoutWatch.frequency} secs');
      }

      // Exersize this number of innerLoops
      watch.reset();
      watch.start();
      innerLoops = exerciseFunc(innerLoops);
      watch.stop();

      final double elapsedInMicros = watch.elapsedMicroseconds.toDouble();
      if (elapsedInMicros < calculationThresholdInMicros) {
        //actualExecutionTimeInMicrosse innerLoopNNiN
        double xFactor;
        if (elapsedInMicros < calculationThresholdInMicros / 10) {
          //actualExecutionTimeInMicrosr away increase by 10NNN
          xFactor = 10;
        } else {
          // Getting close, increase by 2
          xFactor = 2;
        }
        innerLoops *= xFactor.toInt();
        if (verbose) {
          print('estimateInnerLoopsFor: low '
              'elapsedMicroseconds=${watch.elapsedMicroseconds.toDouble()} '
              'calculationThreashold=$calculationThresholdInMicros'
              'increace by $xFactor next innerLoops=$innerLoops '
              '-- ${attempts + 1} attempt(s) '
              'over ${timeoutWatch.elapsedTicks / timeoutWatch.frequency} secs');
        }
      } else {
        // Good enough, calcuate the innerLoops
        final double estimatedInnerLoops =
            executionTimeInMicros / watch.elapsedMicroseconds * innerLoops;
        if (verbose) {
          print(
              'estimateInnerLoopsFor: return '
              'estimatedInnerLoops=$estimatedInnerLoops '
              '-- ${attempts + 1} attempt(s) '
              'over ${timeoutWatch.elapsedTicks / timeoutWatch.frequency} secs');
        }
        return estimatedInnerLoops.round();
      }
    }

    // Bummer we couldn't estimate the time
    if (verbose) {
      print(
          'estimateInnerLoopsFor: ****************** Taking last innerLoops=$innerLoops '
          '-- attempt(s) over $searchTimeInSecs secs');
    }
    return innerLoops;
  }

  /// Estimate the innerLoops value such that executing exerciseFunc
  /// takes approximately executionTimeInSecs.
  int estimateInnerLoops(double searchTimeInSecs,
      int Function(int) exerciseFunc, double executionTimeInSecs, int samples,
      {double errorFactor = kEstimateInnerLoopsErrorFactorDefault,
      bool verbose = false}) {
    final double loopTimeInSecs = executionTimeInSecs / samples;
    final double loopTimeInMicros = loopTimeInSecs * 1000000;
    final double maxError = errorFactor * loopTimeInMicros;
    final Stopwatch timeoutWatch = Stopwatch();
    final Stopwatch watch = Stopwatch();
    double lowestError = loopTimeInMicros;
    int bestGuess = 1;

    if (verbose) {
      print('estimateInnerLoops: errorFactor=$errorFactor '
          'searchTimeInSecs=$searchTimeInSecs '
          'loopTimeInSecs=$loopTimeInSecs '
          'loopTimeinMicros=$loopTimeInMicros '
          'maxError=$maxError');
    }
    timeoutWatch.start();
    int attempts;
    for (attempts = 0;
        timeoutWatch.elapsedMicroseconds < (searchTimeInSecs * 1000000);
        attempts++) {
      if (verbose) {
        print('estimateInnerLoops: top of loop -- ${attempts + 1} attempt(s) '
            'over ${timeoutWatch.elapsedTicks / timeoutWatch.frequency} secs');
      }

      // Estimate
      final int v = estimateInnerLoopsFor(
          searchTimeInSecs, exerciseFunc, loopTimeInSecs, bestGuess, verbose);
      if (verbose) {
        print('estimateInnerLoops: v=$v');
      }

      // Time the length of excercising run
      watch.reset();
      watch.start();
      exercise(v);
      watch.stop();

      // Calcuate the error
      final double exerciseTimeInMicros = watch.elapsedMicroseconds.toDouble();
      final double error = (exerciseTimeInMicros - loopTimeInMicros).abs();

      if (verbose) {
        print('estimateInnerLoops: after exercise($v) '
            'elapsedMicroseconds=${watch.elapsedMicroseconds.toDouble()} '
            'loopTimeInMicros=$loopTimeInMicros '
            'error=$error maxError=$maxError '
            '-- ${attempts + 1} attempt(s) '
            'over ${timeoutWatch.elapsedTicks / timeoutWatch.frequency} secs');
      }

      // If within margin of error return v
      if (error < maxError) {
        if (verbose) {
          print('estimateInnerLoops: v=$v '
              '-- ${attempts + 1} attempt(s) '
              'over ${timeoutWatch.elapsedTicks / timeoutWatch.frequency} secs');
        }
        return v;
      } else {
        if (error < lowestError) {
          lowestError = error;
          bestGuess = v;
        }
      }
    }

    // Bummer we couldn't estimate soon enough, we'll return the best we could
    if (verbose) {
      print(
          'estimateInnerLoops: ****************** Taking bestGuess=$bestGuess '
          '-- $attempts attempt(s) '
          'over ${timeoutWatch.elapsedTicks / timeoutWatch.frequency} secs');
    }
    return bestGuess;
  }

  /// Measure and return samples
  List<double> measureSamples(
      {int sampleCount = kSampleCountDefault,
      List<double> sampleListInSecs,
      int warmUpInMillis = kWarmUpInMillisDefault,
      int minExerciseInMillis = kExcerciseInMillisDefault,
      double errorFactor = kEstimateInnerLoopsErrorFactorDefault,
      bool verboseWarmUp = false,
      bool verboseExercise = false}) {
    //print('measureSamples:+');
    setup();
    // Warmup and discard result.
    if (verboseExercise) {
      print('measureSamples: warmup');
    }
    measureFor(warmup, warmUpInMillis, 1, verboseWarmUp);

    final double minExerciseInSecs = minExerciseInMillis / 1000.0;
    final double searchTimeInSecs = warmUpInMillis / 1000.0;
    if (verboseExercise) {
      print('measureSamples: estimate inner loops, '
          'searchTimeInSecs=$searchTimeInSecs '
          'minExerciseInSecs=$minExerciseInSecs sampleCount=$sampleCount');
    }
    final int innerLoops = estimateInnerLoops(
        searchTimeInSecs, exercise, minExerciseInSecs, sampleCount,
        errorFactor: errorFactor, verbose: verboseExercise);

    // Besure we have a list and that its long enough
    //print('measureSamples: init sampleList');
    if ((sampleListInSecs == null) || (sampleListInSecs.length < sampleCount)) {
      sampleListInSecs = List<double>(sampleCount);
    }

    // Run the benchmark and gather the data
    if (verboseExercise) {
      print('measureSamples: beginning loop '
          'sampleCount=$sampleCount innerLoops=$innerLoops');
    }
    final Stopwatch watch = Stopwatch();
    for (int i = 0; i < sampleCount; i++) {
      watch.reset();
      watch.start();
      exercise(innerLoops);
      watch.stop();
      sampleListInSecs[i] = watch.elapsedTicks / watch.frequency / innerLoops;
    }

    teardown();
    if (verboseExercise) {
      print('measureSamples:-');
    }
    return sampleListInSecs;
  }
}
