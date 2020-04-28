import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:args/args.dart' as args;
import 'package:benchmark_framework_x/benchmark_framework_x.dart';
import 'package:benchmark_framework_x/src/stats_emitter.dart';
//import 'package:intl/intl.dart';

class DoMeasurementArgs {
  DoMeasurementArgs(this.sendPort, this.warmUpInMillis, this.exerciseInMillis, this.sampleCount,
      this.outerLoop, this.verboseWarmUp, this.verboseExercise);

  SendPort sendPort;
  int warmUpInMillis;
  int exerciseInMillis;
  int sampleCount;
  int outerLoop;
  bool verboseWarmUp;
  bool verboseExercise;
}

Future<void> main(List<String> arguments) async {

  // Initialize Arguments
  final args.ArgParser parser = args.ArgParser();
  parser.addFlag('help', abbr: 'h', negatable: false);
  parser.addFlag('spawn', abbr: 's', negatable: false);
  parser.addFlag('direct', abbr: 'd', negatable: false);
  parser.addFlag('verboseWarmUp', abbr: 'W', negatable: false);
  parser.addFlag('verboseExercise', abbr: 'E', negatable: false);
  parser.addOption('warmUpInMillis', abbr: 'w', defaultsTo: '250');
  parser.addOption('exerciseInMillis', abbr: 'e', defaultsTo: '2000');
  parser.addOption('sampleCount', abbr: 'c', defaultsTo: '100');
  parser.addOption('loops', abbr: 'l', defaultsTo: '5');

  // Local function to print help text
  void printUsage() {
    print('Usage: main.dart');
    print(parser.usage);
    exit(1);
  }

  int warmUpInMillis;
  int exerciseInMillis;
  int sampleCount;
  int loops;
  args.ArgResults argResults;

  try {
    argResults = parser.parse(arguments);
    if (argResults['help'] == true) {
      printUsage();
    }

    warmUpInMillis = int.parse(argResults['warmUpInMillis'] as String);
    exerciseInMillis = int.parse(argResults['exerciseInMillis'] as String);
    sampleCount = int.parse(argResults['sampleCount'] as String);
    loops = int.parse(argResults['loops'] as String);
  } catch (e) {
    print(e);
    printUsage();
  }

  bool runSomething = false;
  if (argResults['spawn'] == true) {
    runSomething = true;

    // Invoke the benchmark in an isolate. This appears to lower the incidence of
    // thermal throttling as compared to Direct measurements below.
    final List<double> measurements = <double>[];

    for (int i = 0; i < loops; i++) {
      final ReceivePort receivePort = ReceivePort();

      final DoMeasurementArgs doma = DoMeasurementArgs(
          receivePort.sendPort,
          warmUpInMillis,
          exerciseInMillis,
          sampleCount,
          i,
          argResults['verboseWarmUp'] as bool,
          argResults['verboseExercise'] as bool);
      final Isolate isolate = await Isolate.spawn(doMeasurement, doma);

      await receivePort.first.then((dynamic values) {
        if (values is List<double>) {
          const PrintEmitter().emit('spawn:  ', values);
        }
      });

      isolate.kill();
    }
  }

  if (argResults['direct'] == true) {
    runSomething = true;

    // Directly do measurements in this isolate
    for (int i = 0; i < loops; i++) {
      final DoMeasurementArgs doma = DoMeasurementArgs(
          null,
          warmUpInMillis,
          exerciseInMillis,
          sampleCount,
          i,
          argResults['verboseWarmUp'] as bool,
          argResults['verboseExercise'] as bool);
      const PrintEmitter().emit('direct: ', doMeasurement(doma));
    }
  }

  // If nothing else was run do a report
  if (!runSomething) {
    const BenchmarkBaseX('report: ').report();
  }

  exit(0);
}

List<double> doMeasurement(DoMeasurementArgs doma) {
  const BenchmarkBaseX bmark = BenchmarkBaseX('empty');
  final List<double> measurements = bmark.measureSamples(
      sampleCount: doma.sampleCount,
      warmUpInMillis: doma.warmUpInMillis,
      minExerciseInMillis: doma.exerciseInMillis,
      verboseWarmUp: doma.verboseWarmUp,
      verboseExercise: doma.verboseExercise);
  if (doma.sendPort != null) {
    doma.sendPort.send(measurements);
  }

  return measurements;
}
