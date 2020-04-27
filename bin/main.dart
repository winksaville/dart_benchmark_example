import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:args/args.dart' as args;
import 'package:benchmark_framework_x/benchmark_framework_x.dart';
import 'package:intl/intl.dart';
import 'package:stats/stats.dart' as st;

class DoMeasurementArgs {
  DoMeasurementArgs(this.sendPort, this.warmUpInMillis, this.exerciseInMillis, this.innerLoops,
      this.outerLoop, this.verboseWarmUp, this.verboseExercise);

  SendPort sendPort;
  int warmUpInMillis;
  int exerciseInMillis;
  int innerLoops;
  int outerLoop;
  bool verboseWarmUp;
  bool verboseExercise;
}

Future<void> main(List<String> arguments) async {

  // Initialize Arguments
  final args.ArgParser parser = args.ArgParser();
  parser.addFlag('spawn', abbr: 's', negatable: false);
  parser.addFlag('direct', abbr: 'd', negatable: false);
  parser.addFlag('verboseWarmUp', abbr: 'W', negatable: false);
  parser.addFlag('verboseExercise', abbr: 'E', negatable: false);
  parser.addOption('warmUpInMillis', abbr: 'w', defaultsTo: '250');
  parser.addOption('exerciseInMillis', abbr: 'e', defaultsTo: '2000');
  parser.addOption('innerLoops', abbr: 'i', defaultsTo: '10');
  parser.addOption('loops', abbr: 'l', defaultsTo: '5');

  // Local function to print help text
  void printUsage() {
    print('Usage: main.dart');
    print(parser.usage);
    exit(1);
  }

  int warmUpInMillis;
  int exerciseInMillis;
  int innerLoops;
  int loops;
  args.ArgResults argResults;

  try {
    argResults = parser.parse(arguments);

    if  ((argResults['spawn'] == false) && (argResults['direct'] == false)) {
      print('Error: expected command line options --spawn (-s) and or --direct (-d)');
      printUsage();
    }

    warmUpInMillis = int.parse(argResults['warmUpInMillis'] as String);
    exerciseInMillis = int.parse(argResults['exerciseInMillis'] as String);
    innerLoops = int.parse(argResults['innerLoops'] as String);
    loops = int.parse(argResults['loops'] as String);
  } catch (e) {
    print(e);
    printUsage();
  }

  if (argResults['spawn'] == true) {
    // Invoke the benchmark in an isolate. This appears to lower the incidence of
    // thermal throttling as compared to Direct measurements below.
    final List<double> measurements = <double>[];

    for (int i = 0; i < loops; i++) {
      final ReceivePort receivePort = ReceivePort();

      final DoMeasurementArgs doma = DoMeasurementArgs(
          receivePort.sendPort,
          warmUpInMillis,
          exerciseInMillis,
          innerLoops,
          i,
          argResults['verboseWarmUp'] as bool,
          argResults['verboseExercise'] as bool);
      final Isolate isolate = await Isolate.spawn(doMeasurement, doma);

      await receivePort.first.then((dynamic value) {
        if (value is double) {
          measurements.add(value);
        }
      });

      isolate.kill();
    }
    final st.Stats<double>stats = st.Stats<double>.fromData(measurements);
    print('spawn mesaurements: ${measurementToString(stats)}');
  }

  if (argResults['direct'] == true) {
    // Directly do measurements in this isolate
    final List<double> measurements = <double>[];
    for (int i = 0; i < loops; i++) {
      final DoMeasurementArgs doma = DoMeasurementArgs(
          null,
          warmUpInMillis,
          exerciseInMillis,
          innerLoops,
          i,
          argResults['verboseWarmUp'] as bool,
          argResults['verboseExercise'] as bool);
      measurements.add(doMeasurement(doma));
    }
    final st.Stats<double> stats = st.Stats<double>.fromData(measurements);
    print('direct mesaurements:  ${measurementToString(stats)}');
  }

  exit(0);
}

double doMeasurement(DoMeasurementArgs doma) {
  const BenchmarkBaseX bmark = BenchmarkBaseX('empty');
  final double measurement = bmark.measure(
      warmUpInMillis: doma.warmUpInMillis,
      minExerciseInMillis: doma.exerciseInMillis,
      innerLoops: doma.innerLoops,
      verboseWarmUp: doma.verboseWarmUp,
      verboseExercise: doma.verboseExercise);
  if (doma.sendPort != null) {
    doma.sendPort.send(measurement);
  }

  return measurement;
}

String measurementToString(st.Stats<double> stats) {
  final NumberFormat f6 = NumberFormat('#,##0.000000');
  final NumberFormat f0 = NumberFormat('#,##0');
  const int pad = 9;
  return '{'
      'count: ${f0.format(stats.count)}, '
      'average: ${f6.format(stats.average).padLeft(pad)} us  '
      'min: ${f6.format(stats.min).padLeft(pad)} us  '
      'max: ${f6.format(stats.max).padLeft(pad)} us  '
      'median: ${f6.format(stats.median).padLeft(pad)} us  '
      'standardDeviation: ${f6.format(stats.standardDeviation).padLeft(pad)} us'
      '}';
}
